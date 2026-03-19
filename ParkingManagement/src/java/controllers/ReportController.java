package controllers;

import dal.ParkingTicketDAO;
import dal.ViolationDAO;
import models.ParkingTicket;
import models.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Controller for generating revenue reports.
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
            ParkingTicketDAO ptDao = new ParkingTicketDAO();
            ViolationDAO vDao = new ViolationDAO();
            
            // FIX BUG: Get the full list of parking tickets to print in the table in the reports.jsp file
            List<ParkingTicket> reportData = ptDao.readParkingTickets();
            request.setAttribute("reportData", reportData);
            
            // General statistics
            request.setAttribute("totalRevenue", 0); 
            request.setAttribute("totalTickets", reportData.size());
            request.setAttribute("totalViolations", vDao.readViolations().size());
            
            request.getRequestDispatcher("/views/admin/reports.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error loading reports: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}