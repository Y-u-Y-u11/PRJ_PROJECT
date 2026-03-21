package controllers.staff;

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
        
        int totalSlots = slotDAO.getAll().size();
        int availableSlots = slotDAO.getAvailableSlots().size();
        int occupiedSlots = slotDAO.getOccupiedSlots().size();
        int activeTickets = ticketDAO.getAll(null, "Parking").size();
        
        request.setAttribute("totalSlots", totalSlots);
        request.setAttribute("availableSlots", availableSlots);
        request.setAttribute("occupiedSlots", occupiedSlots);
        request.setAttribute("activeTickets", activeTickets);
        
        request.getRequestDispatcher("/views/staff/dashboard.jsp").forward(request, response);
    }
}
