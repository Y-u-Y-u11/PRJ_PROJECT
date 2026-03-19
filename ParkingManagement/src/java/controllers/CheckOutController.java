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
        
        String slotCode = request.getParameter("slotCode");
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
            
            // Handle edge case: Lost ticket
            if (ticketIdParam == null || ticketIdParam.isEmpty()) {
                request.setAttribute("error", "Bắt buộc phải có mã vé. Vui lòng thực hiện quy trình 'Lost Ticket'.");
                request.getRequestDispatcher("/views/error.jsp").forward(request, response);
                return;
            }
            
            int ticketID = Integer.parseInt(ticketIdParam);
            
            ParkingTicketDAO ticketDao = new ParkingTicketDAO();
            ticketDao.checkOut(ticketID); // DAO will automatically calculate the fee and free the slot
            
            // PRG pattern - Return to Dashboard page with success message
            response.sendRedirect(request.getContextPath() + "/staff/dashboard?success=checkout");
            
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi xử lý check-out: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}