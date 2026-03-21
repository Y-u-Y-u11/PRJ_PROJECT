package controllers.manager;

import dal.CustomerDAO;
import dal.ViolationDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Customer;
import model.Violation;

public class CustomersController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();
        CustomerDAO dao = new CustomerDAO();
        ViolationDAO vDao = new ViolationDAO();

        if ("/manager/customers".equals(action)) {
            String keyword = request.getParameter("keyword");
            List<Customer> list = dao.getAll(keyword);
            request.setAttribute("customers", list);
            request.setAttribute("keyword", keyword);
            request.getRequestDispatcher("/views/manager/customers.jsp").forward(request, response);
        } else if ("/manager/customers/view".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Customer c = dao.getById(id);
            List<Violation> violations = vDao.getByCustomerOrTicket(id, null);
            
            request.setAttribute("customer", c);
            request.setAttribute("violations", violations);
            request.getRequestDispatcher("/views/manager/customers_view.jsp").forward(request, response);
        }
    }
}
