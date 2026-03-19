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
 * Controller to handle deletion/deactivation of a staff member with a confirmation page.
 */
public class StaffDeleteController extends HttpServlet {

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
            response.sendRedirect(request.getContextPath() + "/admin/staffManagement");
            return;
        }

        try {
            int staffId = Integer.parseInt(idParam);
            UserDAO dao = new UserDAO();
            User staff = dao.getUserById(staffId);

            request.setAttribute("staff", staff);
            request.getRequestDispatcher("/views/admin/deleteStaff.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Error loading staff for deletion: " + e.getMessage());
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
            int staffId = Integer.parseInt(request.getParameter("id"));
            UserDAO dao = new UserDAO();
            dao.deleteUsers(staffId);
            session.setAttribute("message", "Nhân viên đã được vô hiệu hóa/xóa thành công!");

        } catch (Exception e) {
            session.setAttribute("error", "Lỗi thao tác xóa: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/staffManagement");
    }
}
