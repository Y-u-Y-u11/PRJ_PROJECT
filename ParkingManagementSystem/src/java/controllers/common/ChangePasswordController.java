package controllers.common;

import dal.UsersDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Users;

public class ChangePasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/common/changePassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        Users user = (Users) request.getSession().getAttribute("LOGIN_USER");
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        
        if (!user.getPasswordHash().equals(currentPassword)) {
            // Note: In real production, compare hashes
            request.setAttribute("error", "Mật khẩu hiện tại không đúng.");
            request.getRequestDispatcher("/views/common/changePassword.jsp").forward(request, response);
            return;
        }
        
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp.");
            request.getRequestDispatcher("/views/common/changePassword.jsp").forward(request, response);
            return;
        }
        
        UsersDAO dao = new UsersDAO();
        if (dao.changePassword(user.getId(), newPassword)) { // storing plain text assuming plain text configuration
            user.setPasswordHash(newPassword);
            request.setAttribute("success", "Đổi mật khẩu thành công!");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra, vui lòng thử lại.");
        }
        
        request.getRequestDispatcher("/views/common/changePassword.jsp").forward(request, response);
    }
}
