package controllers.manager;

import dal.AuditLogDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.AuditLog;
import model.Users;

public class AuditController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("LOGIN_USER");

        // KIỂM TRA ĐĂNG NHẬP
        if (currentUser == null) {
            session.setAttribute("error", "Vui lòng đăng nhập để tiếp tục!");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // KIỂM TRA QUYỀN (Cho phép cả Admin và Manager truy cập)
        String role = currentUser.getRole();
        if (!"Admin".equalsIgnoreCase(role) && !"Manager".equalsIgnoreCase(role)) {
            session.setAttribute("error", "Từ chối truy cập! Bạn không có quyền xem Audit Log.");
            response.sendRedirect(request.getContextPath() + "/login"); // Hoặc redirect về trang chủ của Staff
            return;
        }

        AuditLogDAO auditDao = new AuditLogDAO();

        // XEM DANH SÁCH NHẬT KÝ
        List<AuditLog> logs = auditDao.getAll();
        request.setAttribute("auditLogs", logs);
        request.getRequestDispatcher("/views/manager/audit_report.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // security insurance
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Quyền truy cập vào Audit Controller bị giới hạn thành Read-Only.");
    }
}
