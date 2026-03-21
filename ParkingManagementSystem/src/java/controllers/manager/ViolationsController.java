package controllers.manager;

// For simplicity, Manager can just view a holistic list via ViolationDAO
import dal.ViolationDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Violation;

public class ViolationsController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getServletPath();
        ViolationDAO dao = new ViolationDAO();

        if ("/manager/violations".equals(action)) {
            String keyword = request.getParameter("keyword");
            List<Violation> list = dao.getAll(keyword);
            
            request.setAttribute("violations", list);
            request.setAttribute("keyword", keyword);
            request.getRequestDispatcher("/views/manager/violations.jsp").forward(request, response);
        } else if ("/manager/violations/view".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Violation v = dao.getById(id);
            request.setAttribute("violation", v);
            request.getRequestDispatcher("/views/manager/violations_view.jsp").forward(request, response);
        }
    }
}
