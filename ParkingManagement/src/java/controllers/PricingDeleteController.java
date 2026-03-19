package controllers;

import dal.PriceRuleDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import models.PriceRule;

/**
 * Controller to handle deletion of a pricing rule with a confirmation page.
 */
public class PricingDeleteController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/pricing");
            return;
        }

        try {
            int ruleId = Integer.parseInt(idParam);
            PriceRuleDAO dao = new PriceRuleDAO();
            PriceRule targetRule = null;
            
            // Find the rule
            for (PriceRule rule : dao.readPriceRules()) {
                if (rule.getRuleID() == ruleId) {
                    targetRule = rule;
                    break;
                }
            }

            request.setAttribute("rule", targetRule);
            request.getRequestDispatcher("/views/admin/deletePricing.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Error loading pricing rule for deletion: " + e.getMessage());
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
            int ruleId = Integer.parseInt(request.getParameter("id"));
            PriceRuleDAO dao = new PriceRuleDAO();
            dao.deletePriceRule(ruleId);
            session.setAttribute("message", "Xóa quy tắc giá thành công!");

        } catch (Exception e) {
            session.setAttribute("error", "Lỗi thao tác xóa: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/pricing");
    }
}
