package controllers.staff;

import dal.CustomerDAO;
import dal.ParkingTicketDAO;
import dal.PaymentTransactionDAO;
import dal.ViolationDAO;
import java.io.IOException;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Customer;
import model.ParkingTicket;
import model.PaymentTransaction;
import model.Violation;

public class ViolationsController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getServletPath();
        ParkingTicketDAO tDao = new ParkingTicketDAO();
        ViolationDAO vDao = new ViolationDAO();

        if ("/staff/violations".equals(action)) {
            String keyword = request.getParameter("keyword");
            List<Violation> violations = vDao.getAll(keyword);
            
            request.setAttribute("violations", violations);
            request.setAttribute("keyword", keyword);
            request.getRequestDispatcher("/views/staff/violations.jsp").forward(request, response);
            
        } else if ("/staff/violations/create".equals(action)) {
            String ticketIdParam = request.getParameter("ticketId");
            if (ticketIdParam != null && !ticketIdParam.trim().isEmpty()) {
                ParkingTicket ticket = tDao.getById(Integer.parseInt(ticketIdParam));
                request.setAttribute("ticket", ticket);
            }
            request.getRequestDispatcher("/views/staff/violations_create.jsp").forward(request, response);
            
        } else if ("/staff/violations/update".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                Violation v = vDao.getById(Integer.parseInt(idParam));
                request.setAttribute("violation", v);
                request.getRequestDispatcher("/views/staff/violations_update.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/violations");
            }
        } else if ("/staff/violations/delete".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                Violation v = vDao.getById(Integer.parseInt(idParam));
                request.setAttribute("violation", v);
                request.getRequestDispatcher("/views/staff/violation_delete_confirm.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/violations");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        request.setCharacterEncoding("UTF-8");
        String action = request.getServletPath();
        ViolationDAO vDao = new ViolationDAO();
        CustomerDAO cDao = new CustomerDAO();
        PaymentTransactionDAO ptDao = new PaymentTransactionDAO();

        if ("/staff/violations/create".equals(action)) {
            Integer ticketId = null;
            String ticketIdParam = request.getParameter("ticketId");
            if (ticketIdParam != null && !ticketIdParam.trim().isEmpty()) {
                ticketId = Integer.parseInt(ticketIdParam);
            }
            
            String customerName = request.getParameter("customerName");
            String customerPhone = request.getParameter("customerPhone");
            
            Customer c = new Customer(0, customerName, customerPhone);
            cDao.create(c); 
            
            Customer cLookup = cDao.getAll(customerPhone).isEmpty() ? null : cDao.getAll(customerPhone).get(0);
            Integer customerId = cLookup != null ? cLookup.getId() : null;
            
            String reason = request.getParameter("reason");
            BigDecimal fine = new BigDecimal(request.getParameter("fine"));
            
            Violation v = new Violation(0, ticketId, customerId, reason, fine, "Unpaid", null);
            if (vDao.create(v)) {
                response.sendRedirect(request.getContextPath() + "/staff/violations?msg=success");
            } else {
                request.setAttribute("error", "Lỗi lập biên bản vi phạm.");
                doGet(request, response);
            }
            
        } else if ("/staff/violations/update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String reason = request.getParameter("reason");
            BigDecimal fine = new BigDecimal(request.getParameter("fine"));
            String status = request.getParameter("status");
            String paymentMethod = request.getParameter("paymentMethod"); // Lấy phương thức thanh toán
            
            Violation v = vDao.getById(id);
            if (v != null) {
                String oldStatus = v.getStatus(); // Lưu lại trạng thái cũ
                v.setReason(reason);
                v.setFine(fine);
                v.setStatus(status);
                
                if (vDao.update(v)) {
                    // Nếu cập nhật thành công và chuyển trạng thái sang Paid (trước đó chưa Paid)
                    if ("Paid".equals(status) && !"Paid".equals(oldStatus)) {
                        PaymentTransaction pt = new PaymentTransaction();
                        pt.setTicketID(v.getTicketID()); // Có thể null
                        pt.setAmount(fine);
                        pt.setMethod(paymentMethod != null ? paymentMethod : "Cash");
                        pt.setStatus("Success");
                        pt.setReferenceCode("VIO-" + v.getId() + "-" + System.currentTimeMillis());
                        ptDao.create(pt);
                    }
                    response.sendRedirect(request.getContextPath() + "/staff/violations?msg=update_success");
                } else {
                    request.setAttribute("error", "Cập nhật thất bại.");
                    doGet(request, response);
                }
            }
            
        } else if ("/staff/violations/delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            if (vDao.delete(id)) {
                response.sendRedirect(request.getContextPath() + "/staff/violations?msg=delete_success");
            } else {
                Violation v = vDao.getById(id);
                request.setAttribute("violation", v);
                request.setAttribute("error", "Không thể xóa biên bản này. Vui lòng kiểm tra lại.");
                request.getRequestDispatcher("/views/staff/violation_delete_confirm.jsp").forward(request, response);
            }
        }
    }
}