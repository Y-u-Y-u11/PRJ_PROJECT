package controllers;

import dal.PriceRuleDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import models.PriceRule;

/**
 * Handles pricing rules configuration. Accessible by Admin.
 */
public class PricingController extends HttpServlet {

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
            PriceRuleDAO dao = new PriceRuleDAO();
            List<PriceRule> rules = dao.readPriceRules();
            
            request.setAttribute("rules", rules);
            request.getRequestDispatcher("/views/admin/pricing.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading pricing rules: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String typeID = request.getParameter("typeID");
            String startHour = request.getParameter("startHour");
            String endHour = request.getParameter("endHour");
            double price = Double.parseDouble(request.getParameter("price"));
            
            PriceRule newRule = new PriceRule();
            newRule.setTypeID(typeID);
            newRule.setStartHour(startHour);
            newRule.setEndHour(endHour);
            newRule.setPrice(price);
            
            PriceRuleDAO dao = new PriceRuleDAO();
            dao.createPriceRule(newRule);
            
            // PRG Pattern
            response.sendRedirect(request.getContextPath() + "views/admin/pricing");
            
        } catch (Exception e) {
            request.setAttribute("error", "Failed to add pricing rule: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}
