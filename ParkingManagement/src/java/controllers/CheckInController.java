package controllers;

import dal.ParkingTicketDAO;
import dal.ParkingSlotDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;

/**
 * Handles vehicle check-in process. Accessible by Staff.
 */
public class CheckInController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !"staff".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // UI đã được chuyển lên Dashboard, không còn trang check-in.jsp rời
        response.sendRedirect(request.getContextPath() + "/staff/dashboard");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !"staff".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String vehicleID = request.getParameter("vehicleID");
            String slotID = request.getParameter("slotID");

            // Xử lý tạo ticket check-in trong DB
            ParkingTicketDAO ticketDao = new ParkingTicketDAO();
            ticketDao.checkIn(Integer.parseInt(vehicleID), Integer.parseInt(slotID), currentUser.getUserID());

            // PRG pattern - Trở về trang Dashboard với thông báo thành công
            response.sendRedirect(request.getContextPath() + "/staff/dashboard?success=checkin");

        } catch (Exception e) {
            request.setAttribute("error", "Lỗi xử lý check-in: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}