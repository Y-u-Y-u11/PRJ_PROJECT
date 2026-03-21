package controllers.manager;

import dal.AuditLogDAO;
import dal.UsersDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.AuditLog;
import model.Users;

public class UsersController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        UsersDAO dao = new UsersDAO();

        if ("/manager/users/create".equals(action)) {
            request.getRequestDispatcher("/views/manager/users_create.jsp").forward(request, response);
        } else if ("/manager/users/update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Users u = dao.getById(id);
            request.setAttribute("staff", u);
            request.getRequestDispatcher("/views/manager/users_update.jsp").forward(request, response);
        } else if ("/manager/users".equals(action)) {
            List<Users> list = dao.getAllStaffs();
            request.setAttribute("staffList", list);
            request.getRequestDispatcher("/views/manager/users.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        UsersDAO dao = new UsersDAO();
        AuditLogDAO auditDao = new AuditLogDAO();
        Users currentUser = (Users) request.getSession().getAttribute("LOGIN_USER");

        if ("/manager/users/create".equals(action)) {
            String username = request.getParameter("username");
            String fullName = request.getParameter("fullName");
            String password = request.getParameter("password");
            
            Users u = new Users(0, username, password, fullName, "staff", "active");
            if (dao.createStaff(u)) {
                auditDao.create(new AuditLog(0, currentUser.getId(), "CREATE", "Users", 0, null, null, username, "Tạo nhân viên mới", null));
                response.sendRedirect(request.getContextPath() + "/manager/users");
            } else {
                request.setAttribute("error", "Lỗi tạo tài khoản.");
                request.getRequestDispatcher("/views/manager/users_create.jsp").forward(request, response);
            }
        } else if ("/manager/users/update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String fullName = request.getParameter("fullName");
            String status = request.getParameter("status");
            
            Users u = dao.getById(id);
            u.setFullName(fullName);
            u.setStatus(status);
            
            if (dao.updateStaff(u)) {
                auditDao.create(new AuditLog(0, currentUser.getId(), "UPDATE", "Users", id, null, null, status, "Cập nhật nhân viên", null));
                response.sendRedirect(request.getContextPath() + "/manager/users");
            } else {
                request.setAttribute("error", "Lỗi cập nhật.");
                request.setAttribute("staff", u);
                request.getRequestDispatcher("/views/manager/users_update.jsp").forward(request, response);
            }
        } else if ("/manager/users/delete".equals(action)) {
            // Soft delete recommended, or hard delete
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteStaff(id);
            auditDao.create(new AuditLog(0, currentUser.getId(), "DELETE", "Users", id, null, null, null, "Xóa nhân viên", null));
            response.sendRedirect(request.getContextPath() + "/manager/users");
        }
    }
}
