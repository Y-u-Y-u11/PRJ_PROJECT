package controllers;

import dal.ParkingTicketDAO;
import dal.ViolationDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;

/**
 * Handles Analytics, Revenues, and Violations reports. Accessible by Admin.
 */
public class ReportController extends HttpServlet {

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
            // Load base data for analytics
            ParkingTicketDAO ptDao = new ParkingTicketDAO();
            ViolationDAO vDao = new ViolationDAO();
            
            request.setAttribute("totalRevenue", 0); // Need to aggregate in JSP or calculate in DAO
            request.setAttribute("totalTickets", ptDao.readParkingTickets().size());
            request.setAttribute("totalViolations", vDao.readViolations().size());
            
            request.getRequestDispatcher("/views/admin/reports.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading reports: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}
