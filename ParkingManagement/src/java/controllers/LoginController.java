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
 * Handles user authentication.
 */
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        try {
            UserDAO dao = new UserDAO();
            User account = dao.login(user, pass);

            if (account != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", account);

                // Redirect based on role
                if ("admin".equalsIgnoreCase(account.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/staff/dashboard");
                }
            } else {
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "An internal error occurred: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}
