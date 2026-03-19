package controllers;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;

/**
 * Controller for editing staff details.
 */

public class StaffEditController extends HttpServlet {

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
            int staffId = Integer.parseInt(request.getParameter("id"));
            UserDAO dao = new UserDAO();
            User staff = dao.getUserById(staffId);
            
            if (staff != null) {
                request.setAttribute("staff", staff);
                request.getRequestDispatcher("/views/admin/editStaff.jsp").forward(request, response);
            } else {
                session.setAttribute("error", "Không tìm thấy nhân viên!");
                response.sendRedirect(request.getContextPath() + "/admin/staffManagement");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid ID!");
            response.sendRedirect(request.getContextPath() + "/admin/staffManagement");
        }
    }
}
