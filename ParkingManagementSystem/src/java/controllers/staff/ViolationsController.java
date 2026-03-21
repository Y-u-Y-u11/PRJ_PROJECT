package controllers.staff;

import dal.CustomerDAO;
import dal.ParkingTicketDAO;
import dal.ViolationDAO;
import java.io.IOException;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import model.ParkingTicket;
import model.Violation;

public class ViolationsController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getServletPath();
        ParkingTicketDAO tDao = new ParkingTicketDAO();

        if ("/staff/violations/create".equals(action)) {
            String ticketIdParam = request.getParameter("ticketId");
            if (ticketIdParam != null && !ticketIdParam.trim().isEmpty()) {
                ParkingTicket ticket = tDao.getById(Integer.parseInt(ticketIdParam));
                request.setAttribute("ticket", ticket);
            }
            request.getRequestDispatcher("/views/staff/violations_create.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getServletPath();
        ViolationDAO vDao = new ViolationDAO();
        CustomerDAO cDao = new CustomerDAO();
        ParkingTicketDAO tDao = new ParkingTicketDAO();

        if ("/staff/violations/create".equals(action)) {
            Integer ticketId = null;
            String ticketIdParam = request.getParameter("ticketId");
            if (ticketIdParam != null && !ticketIdParam.trim().isEmpty()) {
                ticketId = Integer.parseInt(ticketIdParam);
            }
            
            // For violation we need a customer. Let's create customer if not exists
            String customerName = request.getParameter("customerName");
            String customerPhone = request.getParameter("customerPhone");
            
            Customer c = new Customer(0, customerName, customerPhone);
            cDao.create(c); // DAO creates and sets generated ID? Wait DAO uses GET_GENERATED_KEYS but does it set to the object? 
            // The DAO returns boolean, we might need a workaround or assume standard DB structure if keys aren't set back.
            // A more complete DAO would return the generated ID. To be safe, look it up.
            Customer cLookup = cDao.getAll(customerPhone).isEmpty() ? null : cDao.getAll(customerPhone).get(0);
            Integer customerId = cLookup != null ? cLookup.getId() : null;
            
            String reason = request.getParameter("reason");
            BigDecimal fine = new BigDecimal(request.getParameter("fine"));
            
            Violation v = new Violation(0, ticketId, customerId, reason, fine, "Unpaid", null);
            if (vDao.create(v)) {
                response.sendRedirect(request.getContextPath() + "/staff/dashboard?msg=violation_success");
            } else {
                request.setAttribute("error", "Lỗi lập biên bản vi phạm.");
                doGet(request, response);
            }
        }
    }
}
