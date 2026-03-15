package controllers;

import dal.MonthlyCardDAO;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import models.MonthlyCard;

/**
 * Handles monthly subscriptions. Accessible by Staff.
 */
public class SubscriptionController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !"staff".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            MonthlyCardDAO dao = new MonthlyCardDAO();
            List<MonthlyCard> cards = dao.readMonthlyCards();
            
            request.setAttribute("cards", cards);
            request.getRequestDispatcher("/views/staff/subscriptions.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading subscriptions: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
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
            String customerID = request.getParameter("customerID");
            String vehicleID = request.getParameter("vehicleID");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String status = request.getParameter("status"); // Active / Expired
            
            MonthlyCard newCard = new MonthlyCard();
            newCard.setCustomerID(customerID);
            newCard.setVehicleID(vehicleID);
            newCard.setStartDate(startDate);
            newCard.setEndDate(endDate);
            newCard.setStatus(status);
            
            MonthlyCardDAO dao = new MonthlyCardDAO();
            dao.createMonthlyCard(newCard);
            
            // PRG pattern
            response.sendRedirect(request.getContextPath() + "views/staff/subscriptions?success=true");
            
        } catch (Exception e) {
            request.setAttribute("error", "Failed to add subscription: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}
