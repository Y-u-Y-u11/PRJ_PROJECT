package controllers;

import dal.ParkingTicketDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;

public class CheckInController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !"staff".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String slotID = request.getParameter("slotID");
        String slotCode = request.getParameter("slotCode");
        
        request.setAttribute("slotID", slotID);
        request.setAttribute("slotCode", slotCode);
        request.getRequestDispatcher("/views/staff/checkin.jsp").forward(request, response);
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
            int slotID = Integer.parseInt(request.getParameter("slotID"));
            
            // Xử lý ID của Xe - Mặc định là 1 nếu parse lỗi
            int vehicleID = 1; 
            try {
                vehicleID = Integer.parseInt(request.getParameter("vehicleID"));
            } catch (Exception ignored) {}
            
            // Lấy ID người trực
            int userID = (currentUser != null) ? currentUser.getUserID() : 1;

            // Gọi DAO tạo vé vào và cập nhật Slot thành Occupied
            ParkingTicketDAO dao = new ParkingTicketDAO();
            dao.checkIn(vehicleID, slotID, userID);

            // PRG pattern - Trở về trang Dashboard và hiện thông báo
            response.sendRedirect(request.getContextPath() + "/staff/dashboard?success=checkin");

        } catch (Exception e) {
            request.setAttribute("error", "Lỗi xử lý check-in: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}