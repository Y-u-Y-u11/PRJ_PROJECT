package controllers;

import dal.ViolationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import models.Violation;

import java.io.IOException;

/**
 * Controller to handle deletion of a violation with a confirmation page.
 */
public class ViolationDeleteController extends HttpServlet {
    // Show confirmation page
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/violations");
            return;
        }
        int id = Integer.parseInt(idParam);
        ViolationDAO dao = new ViolationDAO();
        Violation v = null;
        for (Violation vi : dao.readViolations()) {
            if (vi.getViolationID() == id) {
                v = vi;
                break;
            }
        }
        request.setAttribute("violation", v);
        request.getRequestDispatcher("/views/admin/deleteViolation.jsp").forward(request, response);
    }

    // Perform deletion after confirmation
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int id = Integer.parseInt(idParam);
            ViolationDAO dao = new ViolationDAO();
            dao.deleteViolation(id);
            session.setAttribute("message", "Xóa vi phạm thành công!");
        }
        response.sendRedirect(request.getContextPath() + "/admin/violations");
    }
}
