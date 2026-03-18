package controllers;

import dal.ParkingSlotDAO;
import dal.ParkingTicketDAO;
import dal.ViolationDAO;
import models.ParkingSlot;
import models.ParkingTicket;
import models.Violation;
import models.User;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.time.LocalDate;
import java.time.ZoneId;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "DashboardAdminController", urlPatterns = {"/admin/dashboard"})
public class DashboardAdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            ParkingSlotDAO slotDao = new ParkingSlotDAO();
            ParkingTicketDAO ticketDao = new ParkingTicketDAO();
            ViolationDAO violationDao = new ViolationDAO();
            
            // 1. LẤY DỮ LIỆU SỨC CHỨA (Từ ParkingSlotDAO)
            List<ParkingSlot> slots = slotDao.readParkingSlots();
            int emptySlots = 0;
            for (ParkingSlot s : slots) {
                if ("Empty".equalsIgnoreCase(s.getStatus())) emptySlots++;
            }
            int totalSlots = slots.size();
            
            // 2. LẤY DỮ LIỆU DOANH THU VÀ LƯỢT XE HÔM NAY (Từ ParkingTicketDAO)
            List<ParkingTicket> tickets = ticketDao.readParkingTickets();
            double totalRevenue = 0;
            int todayCars = 0;
            LocalDate today = LocalDate.now();
            
            // Sắp xếp danh sách vé: Vé mới nhất (CheckInTime gần nhất) lên đầu danh sách để làm Lịch sử
            tickets.sort((t1, t2) -> {
                if (t1.getCheckInTime() == null || t2.getCheckInTime() == null) return 0;
                return t2.getCheckInTime().compareTo(t1.getCheckInTime()); // Giảm dần
            });
            
            for (ParkingTicket t : tickets) {
                // Tính lượt xe ra/vào hôm nay
                if (t.getCheckInTime() != null) {
                    LocalDate checkInDate = t.getCheckInTime().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
                    if (checkInDate.equals(today)) {
                        todayCars++;
                    }
                }
                // Tính doanh thu thu được trong hôm nay (dựa vào checkOutTime và status Completed)
                if (t.getCheckOutTime() != null && "Completed".equalsIgnoreCase(t.getStatus())) {
                     LocalDate checkOutDate = t.getCheckOutTime().toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
                     if (checkOutDate.equals(today)) {
                         totalRevenue += t.getTotalFee();
                     }
                }
            }
            
            // 3. LẤY DỮ LIỆU CẢNH BÁO / VI PHẠM (Từ ViolationDAO)
            List<Violation> violations = violationDao.readViolations();
            
            // 4. TẠO THÔNG BÁO HỆ THỐNG ĐỘNG (Dynamic Notifications)
            List<Map<String, String>> systemNotifications = new ArrayList<>();
            
            // Cảnh báo chỗ đỗ
            if (totalSlots > 0) {
                double occupancyRate = (double) (totalSlots - emptySlots) / totalSlots;
                if (occupancyRate >= 0.9) { // Lấp đầy >= 90%
                    Map<String, String> notif = new HashMap<>();
                    notif.put("type", "danger");
                    notif.put("title", "Cảnh báo quá tải");
                    notif.put("time", "Hệ thống");
                    notif.put("message", "Bãi đỗ xe đã lấp đầy " + Math.round(occupancyRate * 100) + "%. Hiện chỉ còn " + emptySlots + " chỗ trống.");
                    systemNotifications.add(notif);
                }
            }
            
            // Thông báo vi phạm mới nhất (nếu có)
            if (!violations.isEmpty()) {
                Violation lastVio = violations.get(violations.size() - 1); // Lấy vi phạm cuối
                Map<String, String> notif = new HashMap<>();
                notif.put("type", "warning");
                notif.put("title", "Có vi phạm chưa xử lý");
                notif.put("time", "Gần đây");
                notif.put("message", "Ghi nhận vi phạm tại vé #" + lastVio.getTicketID() + " - " + lastVio.getReason());
                systemNotifications.add(notif);
            }
            
            // Cập nhật tình hình chung
            Map<String, String> infoNotif = new HashMap<>();
            infoNotif.put("type", "primary");
            infoNotif.put("title", "Báo cáo trong ngày");
            infoNotif.put("time", "Hôm nay");
            infoNotif.put("message", "Hệ thống đã tiếp nhận " + todayCars + " lượt xe ra vào trong ngày hôm nay.");
            systemNotifications.add(infoNotif);


            // 5. SET ATTRIBUTES LÊN JSP
            request.setAttribute("emptySlots", emptySlots);
            request.setAttribute("totalSlots", totalSlots);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("todayCars", todayCars);
            request.setAttribute("activeViolations", violations.size());
            
            request.setAttribute("recentHistories", tickets); 
            request.setAttribute("systemNotifications", systemNotifications); 
            
            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tải thống kê hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}