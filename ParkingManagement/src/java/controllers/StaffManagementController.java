package controllers;

import dal.UserDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;

/**
 * Handles operations related to Staff accounts. Accessible only by Admin.
 */
public class StaffManagementController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Security check: Must be Admin
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            UserDAO dao = new UserDAO();
            List<User> listStaff = dao.getAllStaff();
            request.setAttribute("listStaff", listStaff);
            request.getRequestDispatcher("/views/admin/staffManagement.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Error retrieving staff: " + e.getMessage());
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

        String action = request.getParameter("action");
        try {
            UserDAO dao = new UserDAO();
            if ("add".equals(action)) {
                User newStaff = new User();
                newStaff.setFullName(request.getParameter("fullName"));
                newStaff.setUsername(request.getParameter("username"));
                newStaff.setPassword(request.getParameter("password")); // Hash this in production
                newStaff.setRole("staff");
                newStaff.setPhone(request.getParameter("phone"));
                newStaff.setStatus(true);
                
                dao.createUser(newStaff);
            } else if ("delete".equals(action)) {
                int staffId = Integer.parseInt(request.getParameter("id"));
                dao.deleteUsers(staffId);
            }
            
            // PRG Pattern
            response.sendRedirect(request.getContextPath() + "views/admin/staffManagement");
            
        } catch (Exception e) {
            request.setAttribute("error", "Failed to perform action: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}
