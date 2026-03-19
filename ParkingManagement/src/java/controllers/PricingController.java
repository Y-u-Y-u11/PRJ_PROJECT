package controllers;

import dal.PriceRuleDAO;
import java.io.IOException;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import models.PriceRule;

/**
 * Handles pricing rules configuration. Accessible by Admin.
 * Supports sorting by ruleID, typeID, startHour, endHour, price.
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

            // ---- Sorting ----
            String sort = request.getParameter("sort");
            String order = request.getParameter("order");

            if (sort == null || sort.isEmpty()) {
                sort = "ruleID";
            }
            if (order == null || order.isEmpty()) {
                order = "asc";
            }

            Comparator<PriceRule> comparator;
            switch (sort) {
                case "typeID":
                    comparator = Comparator.comparing(PriceRule::getTypeID, Comparator.nullsFirst(String::compareTo));
                    break;
                case "startHour":
                    comparator = Comparator.comparing(PriceRule::getStartHour, Comparator.nullsFirst(String::compareTo));
                    break;
                case "endHour":
                    comparator = Comparator.comparing(PriceRule::getEndHour, Comparator.nullsFirst(String::compareTo));
                    break;
                case "price":
                    comparator = Comparator.comparingDouble(PriceRule::getPrice);
                    break;
                default: // ruleID
                    comparator = Comparator.comparingInt(PriceRule::getRuleID);
                    break;
            }

            if ("desc".equalsIgnoreCase(order)) {
                comparator = comparator.reversed();
            }
            rules = rules.stream().sorted(comparator).collect(Collectors.toList());

            request.setAttribute("rules", rules);
            request.setAttribute("sort", sort);
            request.setAttribute("order", order);
            request.setAttribute("nextOrder", "asc".equalsIgnoreCase(order) ? "desc" : "asc");

            request.getRequestDispatcher("/views/admin/pricing.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error loading pricing rules: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // All POST actions (add, update, delete) have been moved to dedicated controllers:
        // - PricingAddController
        // - PricingEditController
        // - PricingDeleteController
        response.sendRedirect(request.getContextPath() + "/admin/pricing");
    }
}