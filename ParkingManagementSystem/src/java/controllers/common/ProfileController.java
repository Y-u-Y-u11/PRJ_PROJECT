package controllers.common;

import dal.UsersDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Users;

public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/common/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        Users sessionUser = (Users) request.getSession().getAttribute("LOGIN_USER");
        String fullName = request.getParameter("fullName");
        
        sessionUser.setFullName(fullName);
        UsersDAO dao = new UsersDAO();
        boolean updated = dao.updateProfile(sessionUser.getId(), fullName);
        
        if (updated) {
            request.setAttribute("successMessage", "Cập nhật hồ sơ thành công!");
        } else {
            request.setAttribute("errorMessage", "Cập nhật hồ sơ thất bại. Vui lòng thử lại!");
        }
        
        request.setAttribute("successMessage", "Cập nhật hồ sơ thành công!");
        request.getRequestDispatcher("/views/common/profile.jsp").forward(request, response);
    }
}
