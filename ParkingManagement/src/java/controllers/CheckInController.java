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
import models.ParkingSlot;
import java.util.List;

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

        try {
            // Check for available slots before rendering
            ParkingSlotDAO slotDao = new ParkingSlotDAO();
            List<ParkingSlot> availableSlots = slotDao.readParkingSlots(); // Could be filtered by 'Empty' status
            boolean isFull = true;
            for (ParkingSlot s : availableSlots) {
                if ("Empty".equalsIgnoreCase(s.getStatus())) {
                    isFull = false;
                    break;
                }
            }

            request.setAttribute("availableSlots", availableSlots);
            request.setAttribute("isFullCapacity", isFull);
            request.getRequestDispatcher("/views/staff/check-in.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Failed to load check-in page.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
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

            // Note: In real scenarios, "Duplicate Plate" must be checked before creating ticket
            // For brevity, we pass directly to DAO
            ParkingTicketDAO ticketDao = new ParkingTicketDAO();
            ticketDao.checkIn(Integer.parseInt(vehicleID), Integer.parseInt(slotID), currentUser.getUserID());

            // PRG pattern
            response.sendRedirect(request.getContextPath() + "/views/staff/parking-slots?success=checkin");

        } catch (Exception e) {
            request.setAttribute("error", "Error processing check-in: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}
