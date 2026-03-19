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
 * Controller for editing pricing rules.
 */

public class PricingEditController extends HttpServlet {

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
            int ruleId = Integer.parseInt(request.getParameter("id"));
            PriceRuleDAO dao = new PriceRuleDAO();
            PriceRule rule = dao.getPriceRuleById(ruleId);

            if (rule != null) {
                request.setAttribute("rule", rule);
                request.getRequestDispatcher("/views/admin/editPricing.jsp").forward(request, response);
            } else {
                session.setAttribute("error", "Không tìm thấy quy tắc giá!");
                response.sendRedirect(request.getContextPath() + "/admin/pricing");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid ID!");
            response.sendRedirect(request.getContextPath() + "/admin/pricing");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int ruleID = Integer.parseInt(request.getParameter("ruleID"));
        try {
            String typeID = request.getParameter("typeID");
            int startHour = Integer.parseInt(request.getParameter("startHour"));
            int endHour = Integer.parseInt(request.getParameter("endHour"));
            double price = Double.parseDouble(request.getParameter("price"));

            // 1. Validate hours range
            if (startHour < 0 || startHour > 24 || endHour < 0 || endHour > 24 || startHour >= endHour) {
                session.setAttribute("error", "Giờ bắt đầu phải nhỏ hơn giờ kết thúc (0-24h)!");
                response.sendRedirect(request.getContextPath() + "/admin/pricing/edit?id=" + ruleID);
                return;
            }

            PriceRuleDAO dao = new PriceRuleDAO();
            
            // 2. Check for overlaps (exclude self)
            PriceRule overlap = dao.getOverlapRule(typeID, startHour, endHour, ruleID);
            if (overlap != null) {
                session.setAttribute("error", "Thời gian bị trùng lặp với quy tắc #" + overlap.getRuleID() 
                    + " (" + overlap.getStartHour() + "h - " + overlap.getEndHour() + "h)!");
                response.sendRedirect(request.getContextPath() + "/admin/pricing/edit?id=" + ruleID);
                return;
            }

            PriceRule updatedRule = new PriceRule();
            updatedRule.setRuleID(ruleID);
            updatedRule.setTypeID(typeID);
            updatedRule.setStartHour(String.valueOf(startHour));
            updatedRule.setEndHour(String.valueOf(endHour));
            updatedRule.setPrice(price);

            dao.updatePriceRule(updatedRule);
            session.setAttribute("message", "Cập nhật quy tắc giá thành công!");
            response.sendRedirect(request.getContextPath() + "/admin/pricing");

        } catch (Exception e) {
            session.setAttribute("error", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/pricing/edit?id=" + ruleID);
        }
    }
}
