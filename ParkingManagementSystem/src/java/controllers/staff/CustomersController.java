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

        if ("/staff/customers/create".equals(action)) {
            request.getRequestDispatcher("/views/common/customer_add.jsp").forward(request, response);
        } else if ("/staff/customers/edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Customer c = dao.getById(id);
            request.setAttribute("customer", c);
            request.getRequestDispatcher("/views/common/customer_edit.jsp").forward(request, response);
        } else if ("/staff/customers/delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Customer c = dao.getById(id);
            request.setAttribute("customer", c);
            request.getRequestDispatcher("/views/common/customer_delete_confirm.jsp").forward(request, response);
        } else if ("/staff/customers".equals(action)) {
            String keyword = request.getParameter("keyword");
            List<Customer> list = dao.getAll(keyword);
            
            request.setAttribute("customers", list);
            request.setAttribute("keyword", keyword);
            request.getRequestDispatcher("/views/staff/customers.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getServletPath();
        if ("/staff/customers/create".equals(action)) {
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            
            if (name == null || name.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin.");
                request.getRequestDispatcher("/views/common/customer_add.jsp").forward(request, response);
                return;
            }
            
            CustomerDAO dao = new CustomerDAO();
            Customer c = new Customer(0, name, phone);
            boolean success = dao.create(c);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/staff/customers?success=created");
            } else {
                request.setAttribute("error", "Không thể thêm khách hàng. Vui lòng kiểm tra lại thông tin hoặc số điện thoại.");
                request.getRequestDispatcher("/views/common/customer_add.jsp").forward(request, response);
            }
        } else if ("/staff/customers/edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            
            CustomerDAO dao = new CustomerDAO();
            Customer c = new Customer(id, name, phone);
            if (dao.update(c)) {
                response.sendRedirect(request.getContextPath() + "/staff/customers?success=updated");
            } else {
                request.setAttribute("error", "Lỗi cập nhật.");
                request.setAttribute("customer", c);
                request.getRequestDispatcher("/views/common/customer_edit.jsp").forward(request, response);
            }
        } else if ("/staff/customers/delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            CustomerDAO dao = new CustomerDAO();
            if (dao.delete(id)) {
                response.sendRedirect(request.getContextPath() + "/staff/customers?success=deleted");
            } else {
                Customer c = dao.getById(id);
                request.setAttribute("error", "Không thể xóa khách hàng. Khách hàng có thể đang có vé gửi xe hoặc thẻ tháng còn hoạt động.");
                request.setAttribute("customer", c);
                request.getRequestDispatcher("/views/common/customer_delete_confirm.jsp").forward(request, response);
            }
        }
    }
}
