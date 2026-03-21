package controllers.manager;

import dal.AuditLogDAO;
import dal.VehicleTypeDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.AuditLog;
import model.Users;
import model.VehicleType;

public class VehicleTypesController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        VehicleTypeDAO dao = new VehicleTypeDAO();

        if ("/manager/vehicle-types/create".equals(action)) {
            request.getRequestDispatcher("/views/manager/vehicle_types_create.jsp").forward(request, response);
        } else if ("/manager/vehicle-types/update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            VehicleType vt = dao.getById(id);
            request.setAttribute("vt", vt);
            request.getRequestDispatcher("/views/manager/vehicle_types_update.jsp").forward(request, response);
        } else if ("/manager/vehicle-types".equals(action)) {
            List<VehicleType> list = dao.getAll();
            request.setAttribute("vehicleTypes", list);
            request.getRequestDispatcher("/views/manager/vehicle_types.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        VehicleTypeDAO dao = new VehicleTypeDAO();
        AuditLogDAO auditDao = new AuditLogDAO();
        Users currentUser = (Users) request.getSession().getAttribute("LOGIN_USER");

        if ("/manager/vehicle-types/create".equals(action)) {
            String name = request.getParameter("name");
            BigDecimal currentPrice = new BigDecimal(request.getParameter("currentPrice"));
            boolean requiresPlate = request.getParameter("requiresPlate") != null;
            
            VehicleType vt = new VehicleType(0, name, currentPrice, requiresPlate);
            if (dao.create(vt)) {
                auditDao.create(new AuditLog(0, currentUser.getId(), "CREATE", "VehicleType", 0, null, null, name, "Tạo loại xe mới", null));
                response.sendRedirect(request.getContextPath() + "/manager/vehicle-types");
            } else {
                request.setAttribute("error", "Lỗi tạo loại xe.");
                request.getRequestDispatcher("/views/manager/vehicle_types_create.jsp").forward(request, response);
            }
        } else if ("/manager/vehicle-types/update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            BigDecimal currentPrice = new BigDecimal(request.getParameter("currentPrice"));
            boolean requiresPlate = request.getParameter("requiresPlate") != null;
            
            VehicleType vt = new VehicleType(id, name, currentPrice, requiresPlate);
            if (dao.update(vt)) {
                auditDao.create(new AuditLog(0, currentUser.getId(), "UPDATE", "VehicleType", id, null, null, currentPrice.toString(), "Cập nhật loại xe", null));
                response.sendRedirect(request.getContextPath() + "/manager/vehicle-types");
            } else {
                request.setAttribute("error", "Lỗi cập nhật.");
                request.setAttribute("vt", vt);
                request.getRequestDispatcher("/views/manager/vehicle_types_update.jsp").forward(request, response);
            }
        }
    }
}
