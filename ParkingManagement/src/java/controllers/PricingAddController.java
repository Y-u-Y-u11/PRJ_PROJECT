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
 * Controller for adding new pricing rules.
 */
public class PricingAddController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/views/admin/addPricing.jsp").forward(request, response);
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

        try {
            String typeID = request.getParameter("typeID");
            int startHour = Integer.parseInt(request.getParameter("startHour"));
            int endHour = Integer.parseInt(request.getParameter("endHour"));
            double price = Double.parseDouble(request.getParameter("price"));

            // 1. Validate hours range
            if (startHour < 0 || startHour > 24 || endHour < 0 || endHour > 24 || startHour >= endHour) {
                session.setAttribute("error", "Giờ bắt đầu phải nhỏ hơn giờ kết thúc (0-24h)!");
                response.sendRedirect(request.getContextPath() + "/admin/pricing/add");
                return;
            }

            PriceRuleDAO dao = new PriceRuleDAO();

            // 2. Check for overlaps
            PriceRule overlap = dao.getOverlapRule(typeID, startHour, endHour, -1);
            if (overlap != null) {
                session.setAttribute("error", "Thời gian bị trùng lặp với quy tắc #" + overlap.getRuleID()
                        + " (" + overlap.getStartHour() + "h - " + overlap.getEndHour() + "h)!");
                response.sendRedirect(request.getContextPath() + "/admin/pricing/add");
                return;
            }

            PriceRule newRule = new PriceRule();
            newRule.setTypeID(typeID);
            newRule.setStartHour(String.valueOf(startHour));
            newRule.setEndHour(String.valueOf(endHour));
            newRule.setPrice(price);

            dao.createPriceRule(newRule);
            session.setAttribute("message", "Thêm quy tắc giá thành công!");
            response.sendRedirect(request.getContextPath() + "/admin/pricing");

        } catch (Exception e) {
            session.setAttribute("error", "Lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/pricing/add");
        }
    }
}
