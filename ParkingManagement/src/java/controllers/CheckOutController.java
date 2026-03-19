package controllers;

import dal.DBContext;
import dal.ParkingTicketDAO;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import models.ParkingTicket;

public class CheckOutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !"staff".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String slotCode = request.getParameter("slotCode");
        ParkingTicket activeTicket = null;
        
        // Truy vấn trực tiếp để lấy Ticket đang đỗ tại Slot này để hiển thị lên form
        try {
            DBContext db = new DBContext();
            String sql = "SELECT pt.* FROM ParkingTicket pt JOIN ParkingSlot ps ON pt.slotID = ps.slotID WHERE ps.slotCode = ? AND pt.status = 'Parking'";
            PreparedStatement stm = db.connection.prepareStatement(sql);
            stm.setString(1, slotCode);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                activeTicket = new ParkingTicket();
                activeTicket.setTicketID(rs.getInt("ticketID"));
                activeTicket.setVehicleID(rs.getString("vehicleID"));
                activeTicket.setCheckInTime(rs.getTimestamp("checkInTime"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("ticket", activeTicket);
        request.setAttribute("slotCode", slotCode);
        request.getRequestDispatcher("/views/staff/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !"staff".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String ticketIdParam = request.getParameter("ticketID");
            
            if (ticketIdParam == null || ticketIdParam.isEmpty()) {
                request.setAttribute("error", "Không tìm thấy mã vé!");
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                return;
            }
            
            int ticketID = Integer.parseInt(ticketIdParam);
            
            // DAO tự động tính tiền, cập nhật vé và giải phóng Slot
            ParkingTicketDAO ticketDao = new ParkingTicketDAO();
            ticketDao.checkOut(ticketID); 
            
            response.sendRedirect(request.getContextPath() + "/staff/dashboard?success=checkout");
            
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi xử lý check-out: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}