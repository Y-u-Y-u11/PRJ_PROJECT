package controllers;

import dal.PriceRuleDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import models.PriceRule;

/**
 * Handles pricing rules configuration. Accessible by Admin.
 */
@WebServlet(name = "PricingController", urlPatterns = {"/admin/pricing"})
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
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Đọc tham số action để biết cần làm gì (mặc định là add)
        String action = request.getParameter("action");
        if (action == null) {
            action = "add";
        }

        try {
            PriceRuleDAO dao = new PriceRuleDAO();

            if ("add".equals(action)) {
                String typeID = request.getParameter("typeID");
                String startHour = request.getParameter("startHour");
                String endHour = request.getParameter("endHour");
                double price = Double.parseDouble(request.getParameter("price"));
                
                PriceRule newRule = new PriceRule();
                newRule.setTypeID(typeID);
                newRule.setStartHour(startHour);
                newRule.setEndHour(endHour);
                newRule.setPrice(price);
                
                dao.createPriceRule(newRule);
                session.setAttribute("message", "Thêm quy tắc giá thành công!");
                
            } else if ("update".equals(action)) {
                int ruleID = Integer.parseInt(request.getParameter("ruleID"));
                String typeID = request.getParameter("typeID");
                String startHour = request.getParameter("startHour");
                String endHour = request.getParameter("endHour");
                double price = Double.parseDouble(request.getParameter("price"));
                
                PriceRule updatedRule = new PriceRule();
                updatedRule.setRuleID(ruleID);
                updatedRule.setTypeID(typeID);
                updatedRule.setStartHour(startHour);
                updatedRule.setEndHour(endHour);
                updatedRule.setPrice(price);
                
                dao.updatePriceRule(updatedRule);
                session.setAttribute("message", "Cập nhật quy tắc giá thành công!");
                
            } else if ("delete".equals(action)) {
                int ruleID = Integer.parseInt(request.getParameter("ruleID"));
                dao.deletePriceRule(ruleID);
                session.setAttribute("message", "Xóa quy tắc giá thành công!");
            }
            
            // Áp dụng PRG Pattern - Chỉnh sửa lại URL redirect cho chính xác
            response.sendRedirect(request.getContextPath() + "/admin/pricing");
            
        } catch (Exception e) {
            session.setAttribute("error", "Thao tác thất bại: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/pricing");
        }
    }
}