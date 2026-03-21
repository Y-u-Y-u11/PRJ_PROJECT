package controllers.staff;

import dal.CustomerDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;

public class CustomersController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getServletPath();
        CustomerDAO dao = new CustomerDAO();

        if ("/staff/customers".equals(action)) {
            String keyword = request.getParameter("keyword");
            List<Customer> list = dao.getAll(keyword);
            
            request.setAttribute("customers", list);
            request.setAttribute("keyword", keyword);
            request.getRequestDispatcher("/views/staff/customers.jsp").forward(request, response);
        }
    }
}
