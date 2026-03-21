package controllers.staff;

import dal.ParkingTicketDAO;
import dal.PaymentTransactionDAO;
import dal.VehicleTypeDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDateTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ParkingTicket;
import model.PaymentTransaction;
import model.VehicleType;

public class PaymentsController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getServletPath();
        ParkingTicketDAO tDao = new ParkingTicketDAO();
        VehicleTypeDAO vDao = new VehicleTypeDAO();

        if ("/staff/payments/process".equals(action)) {
            int ticketId = Integer.parseInt(request.getParameter("ticketId"));
            ParkingTicket ticket = tDao.getById(ticketId);
            
            if (ticket != null && "Parking".equals(ticket.getStatus())) {
                VehicleType vt = vDao.getById(ticket.getTypeID());
                
                LocalDateTime now = LocalDateTime.now();
                long hours = Duration.between(ticket.getCheckInTime().toLocalDateTime(), now).toHours();
                if (hours == 0) hours = 1; // Minimum 1 hour charge
                
                BigDecimal fee = vt.getCurrentPrice().multiply(BigDecimal.valueOf(hours));
                
                request.setAttribute("ticket", ticket);
                request.setAttribute("vehicleType", vt);
                request.setAttribute("hours", hours);
                request.setAttribute("calculatedFee", fee);
                
                request.getRequestDispatcher("/views/staff/payments_process.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/tickets/search?error=invalid_ticket");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getServletPath();
        ParkingTicketDAO tDao = new ParkingTicketDAO();
        PaymentTransactionDAO ptDao = new PaymentTransactionDAO();

        if ("/staff/payments/process".equals(action)) {
            int ticketId = Integer.parseInt(request.getParameter("ticketId"));
            BigDecimal amount = new BigDecimal(request.getParameter("amount"));
            String method = request.getParameter("method");
            
            PaymentTransaction pt = new PaymentTransaction(0, ticketId, amount, method, "Success", "REF-" + System.currentTimeMillis(), null);
            
            if (ptDao.create(pt)) {
                // Update Ticket Status to Completed & set CheckOutTime
                ParkingTicket ticket = tDao.getById(ticketId);
                ticket.setStatus("Completed");
                ticket.setCheckOutTime(java.sql.Timestamp.valueOf(LocalDateTime.now()));
                ticket.setCheckOutStaffID(((model.Users) request.getSession().getAttribute("LOGIN_USER")).getId());
                tDao.update(ticket);
                
                // Update Slot Status to Available? implicitly handled.
                response.sendRedirect(request.getContextPath() + "/staff/dashboard?msg=payment_success");
            } else {
                request.setAttribute("error", "Lỗi xử lý thanh toán.");
                doGet(request, response);
            }
        }
    }
}
