package controllers.manager;

import dal.AuditLogDAO;
import dal.ParkingSlotDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.AuditLog;
import model.ParkingSlot;
import model.Users;

public class SlotsController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        ParkingSlotDAO dao = new ParkingSlotDAO();

        if ("/manager/slots/create".equals(action)) {
            request.getRequestDispatcher("/views/manager/slots_create.jsp").forward(request, response);
        } else if ("/manager/slots/update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            ParkingSlot s = dao.getById(id);
            request.setAttribute("slot", s);
            request.getRequestDispatcher("/views/manager/slots_update.jsp").forward(request, response);
        } else if ("/manager/slots".equals(action)) {
            List<ParkingSlot> list = dao.getAll();
            request.setAttribute("slots", list);
            request.getRequestDispatcher("/views/manager/slots.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        ParkingSlotDAO dao = new ParkingSlotDAO();
        AuditLogDAO auditDao = new AuditLogDAO();
        Users currentUser = (Users) request.getSession().getAttribute("LOGIN_USER");

        if ("/manager/slots/create".equals(action)) {
            String code = request.getParameter("code");
            
            ParkingSlot s = new ParkingSlot(0, code);
            if (dao.create(s)) {
                auditDao.create(new AuditLog(0, currentUser.getId(), "CREATE", "ParkingSlot", 0, null, null, code, "Tạo Ô đỗ mới", null));
                response.sendRedirect(request.getContextPath() + "/manager/slots");
            } else {
                request.setAttribute("error", "Lỗi tạo Ô đỗ (có thể trùng mã).");
                request.getRequestDispatcher("/views/manager/slots_create.jsp").forward(request, response);
            }
        } else if ("/manager/slots/update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String code = request.getParameter("code");
            
            ParkingSlot s = new ParkingSlot(id, code);
            if (dao.update(s)) {
                auditDao.create(new AuditLog(0, currentUser.getId(), "UPDATE", "ParkingSlot", id, null, null, code, "Cập nhật mã Ô đỗ", null));
                response.sendRedirect(request.getContextPath() + "/manager/slots");
            } else {
                request.setAttribute("error", "Lỗi cập nhật.");
                request.setAttribute("slot", s);
                request.getRequestDispatcher("/views/manager/slots_update.jsp").forward(request, response);
            }
        }
    }
}
