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
                
                BigDecimal fee = BigDecimal.ZERO;
                if (ticket.getMonthlyCardID() == null) {
                    // Standard billing for transient tickets
                    LocalDateTime now = LocalDateTime.now();
                    long hours = Duration.between(ticket.getCheckInTime().toLocalDateTime(), now).toHours();
                    if (hours == 0) hours = 1; // Minimum charge is 1 hour
                    fee = vt.getCurrentPrice().multiply(BigDecimal.valueOf(hours));
                    request.setAttribute("hours", hours);
                } else {
                    // Subscription holders park for free
                    request.setAttribute("isMonthly", true);
                }
                
                request.setAttribute("ticket", ticket);
                request.setAttribute("vehicleType", vt);
                request.setAttribute("calculatedFee", fee);
                
                if (fee.compareTo(BigDecimal.ZERO) == 0) {
                    PaymentTransaction pt = new PaymentTransaction(0, ticketId, BigDecimal.ZERO, "None/Auto", "Success", "AUTO-" + System.currentTimeMillis(), null);
                    PaymentTransactionDAO ptDao = new PaymentTransactionDAO();
                    ptDao.create(pt);
                    
                    ticket.setStatus("Completed");
                    ticket.setCheckOutTime(java.sql.Timestamp.valueOf(LocalDateTime.now()));
                    model.Users currentUser = (model.Users) request.getSession().getAttribute("LOGIN_USER");
                    ticket.setCheckOutStaffID(currentUser != null ? currentUser.getId() : (Integer) 2);
                    tDao.update(ticket);
                    
                    response.sendRedirect(request.getContextPath() + "/staff/dashboard?msg=checkout_success");
                } else {
                    request.getRequestDispatcher("/views/staff/payments_process.jsp").forward(request, response);
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/staff/dashboard?msg=error_invalid_ticket");
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
