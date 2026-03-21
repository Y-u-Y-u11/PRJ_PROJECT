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

// Nhớ cấu hình mapping cho Servlet này trong web.xml (vd: /manager/audit và /manager/audit/export)
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

        String action = request.getRequestURI().substring(request.getContextPath().length());
        AuditLogDAO auditDao = new AuditLogDAO();

        // =========================
        // XUẤT BÁO CÁO CSV
        // =========================
        if (action.endsWith("/export")) {
            response.setContentType("text/csv; charset=UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=\"audit_report.csv\"");
            
            try (PrintWriter writer = response.getWriter()) {
                // Thêm ký tự BOM (Byte Order Mark) để Excel có thể đọc đúng tiếng Việt UTF-8
                writer.write('\ufeff'); 
                writer.println("ID,Staff ID,Action Type,Table Name,Record ID,Column Name,Old Value,New Value,Reason,Created At");
                
                List<AuditLog> logs = auditDao.getAll();
                for (AuditLog log : logs) {
                    writer.printf("%d,%d,%s,%s,%d,%s,%s,%s,%s,%s\n",
                            log.getId(),
                            log.getStaffID(),
                            escapeCSV(log.getActionType()),
                            escapeCSV(log.getTableName()),
                            log.getRecordID(),
                            escapeCSV(log.getColumnName()),
                            escapeCSV(log.getOldValue()),
                            escapeCSV(log.getNewValue()),
                            escapeCSV(log.getReason()),
                            log.getCreatedAt() != null ? log.getCreatedAt().toString() : ""
                    );
                }
            }
        } 
        // =========================
        // XEM DANH SÁCH NHẬT KÝ
        // =========================
        else {
            List<AuditLog> logs = auditDao.getAll();
            request.setAttribute("auditLogs", logs);
            // Bạn cũng nên chắc chắn file JSP này được đặt đúng thư mục (vd: /views/manager/audit_report.jsp hoặc /views/admin/audit_report.jsp)
            request.getRequestDispatcher("/views/manager/audit_report.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // TÍNH NĂNG CHỈ ĐỌC: Chặn hoàn toàn mọi thao tác thay đổi dữ liệu (POST) vào Controller này
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Quyền truy cập vào Audit Controller bị giới hạn thành Chỉ Đọc (Read-Only).");
    }

    // Hàm tiện ích hỗ trợ định dạng chuỗi an toàn khi xuất file CSV
    private String escapeCSV(String value) {
        if (value == null) return "";
        if (value.contains(",") || value.contains("\"") || value.contains("\n")) {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        return value;
    }
}