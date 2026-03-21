package controllers.manager;

import dal.ParkingTicketDAO;
import dal.PaymentTransactionDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ParkingTicket;
import model.PaymentTransaction;

public class TicketsController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getServletPath();
        ParkingTicketDAO dao = new ParkingTicketDAO();
        PaymentTransactionDAO ptDao = new PaymentTransactionDAO();

        if ("/manager/tickets".equals(action)) {
            String keyword = request.getParameter("keyword");
            String status = request.getParameter("status");
            List<ParkingTicket> list = dao.getAll(keyword, status);
            
            request.setAttribute("tickets", list);
            request.setAttribute("keyword", keyword);
            request.setAttribute("statusFilter", status);
            request.getRequestDispatcher("/views/manager/tickets.jsp").forward(request, response);
            
        } else if ("/manager/tickets/view".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            ParkingTicket ticket = dao.getById(id);
            List<PaymentTransaction> payments = ptDao.getByTicketId(id);
            
            request.setAttribute("ticket", ticket);
            request.setAttribute("payments", payments);
            request.getRequestDispatcher("/views/manager/tickets_view.jsp").forward(request, response);
        }
    }
}
