package controllers;

import dal.ParkingTicketDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;

/**
 * Handles vehicle checkout process. Accessible by Staff.
 */
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
        
        // UI đã được chuyển lên Dashboard, không còn trang check-out.jsp rời
        response.sendRedirect(request.getContextPath() + "/staff/dashboard");
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
            
            // Handle edge case: Lost ticket
            if (ticketIdParam == null || ticketIdParam.isEmpty()) {
                request.setAttribute("error", "Bắt buộc phải có mã vé. Vui lòng thực hiện quy trình 'Lost Ticket'.");
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                return;
            }
            
            int ticketID = Integer.parseInt(ticketIdParam);
            
            ParkingTicketDAO ticketDao = new ParkingTicketDAO();
            ticketDao.checkOut(ticketID); // DAO sẽ tự tính tiền và giải phóng chỗ trống
            
            // PRG pattern - Trở về trang Dashboard với thông báo thành công
            response.sendRedirect(request.getContextPath() + "/staff/dashboard?success=checkout");
            
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi xử lý check-out: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}