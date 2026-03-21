package controllers.manager;

import dal.PaymentTransactionDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.PaymentTransaction;

public class PaymentsController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getServletPath();

        if ("/manager/payments".equals(action)) {
            PaymentTransactionDAO dao = new PaymentTransactionDAO();
            List<PaymentTransaction> payments = dao.getAll();
            request.setAttribute("payments", payments);
            request.getRequestDispatcher("/views/manager/payments.jsp").forward(request, response);
        }
    }
}
