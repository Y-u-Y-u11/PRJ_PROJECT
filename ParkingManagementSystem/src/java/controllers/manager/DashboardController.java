package controllers.manager;

import dal.ParkingSlotDAO;
import dal.ParkingTicketDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class DashboardController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        ParkingSlotDAO slotDAO = new ParkingSlotDAO();
        ParkingTicketDAO ticketDAO = new ParkingTicketDAO();
        
        // Basic stats for dashboard
        int totalSlots = slotDAO.getAll().size();
        int occupiedSlots = slotDAO.getOccupiedSlots().size();
        int availableSlots = slotDAO.getAvailableSlots().size();
        
        // Count active tickets
        int activeTickets = ticketDAO.getAll(null, "Parking").size();
        
        request.setAttribute("totalSlots", totalSlots);
        request.setAttribute("occupiedSlots", occupiedSlots);
        request.setAttribute("availableSlots", availableSlots);
        request.setAttribute("activeTickets", activeTickets);
        
        request.getRequestDispatcher("/views/manager/dashboard.jsp").forward(request, response);
    }
}
