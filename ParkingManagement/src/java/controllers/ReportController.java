package controllers;

import dal.ParkingTicketDAO;
import dal.ViolationDAO;
import models.ParkingTicket;
import models.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ReportController", urlPatterns = {"/admin/reports"})
public class ReportController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            ParkingTicketDAO ptDao = new ParkingTicketDAO();
            ViolationDAO vDao = new ViolationDAO();
            
            // SỬA LỖI: Lấy danh sách toàn bộ vé gửi xe để in ra bảng ở file reports.jsp
            List<ParkingTicket> reportData = ptDao.readParkingTickets();
            request.setAttribute("reportData", reportData);
            
            // Thống kê tổng hợp
            request.setAttribute("totalRevenue", 0); 
            request.setAttribute("totalTickets", reportData.size());
            request.setAttribute("totalViolations", vDao.readViolations().size());
            
            request.getRequestDispatcher("/views/admin/reports.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error loading reports: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}