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
        
        // Load the checkout page
        request.getRequestDispatcher("/views/staff/check-out.jsp").forward(request, response);
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
                request.setAttribute("error", "Ticket number is required. Please follow 'Lost Ticket' procedure.");
                request.getRequestDispatcher("/views/staff/check-out.jsp").forward(request, response);
                return;
            }
            
            int ticketID = Integer.parseInt(ticketIdParam);
            
            ParkingTicketDAO ticketDao = new ParkingTicketDAO();
            ticketDao.checkOut(ticketID); // This calculates total fee, overtime charges internally in DAO
            
            // PRG pattern
            response.sendRedirect(request.getContextPath() + "views/staff/check-out?success=true");
            
        } catch (Exception e) {
            request.setAttribute("error", "Failed checkout process: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}
