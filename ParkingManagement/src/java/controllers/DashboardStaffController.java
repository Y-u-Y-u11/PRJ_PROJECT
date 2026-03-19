package controllers;

import dal.ParkingSlotDAO;
import dal.ParkingZoneDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import models.ParkingSlot;
import models.ParkingZone;

/**
 * Loads real-time data for Staff Dashboard
 */
public class DashboardStaffController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !"staff".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            ParkingZoneDAO zoneDao = new ParkingZoneDAO();
            List<ParkingZone> zones = zoneDao.readParkingZones();
            request.setAttribute("zones", zones);
            // Get real data from DB
            ParkingSlotDAO slotDao = new ParkingSlotDAO();
            List<ParkingSlot> slots = slotDao.readParkingSlots();

            request.setAttribute("slots", slots);
            request.getRequestDispatcher("/views/staff/dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Không thể tải dữ liệu bãi đỗ xe: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}
