package controllers;

import dal.ParkingTicketDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.ParkingTicket;
import models.User;

/**
 * Controller for rendering the form to add a new violation.
 * Loads available parking tickets for the ticket ID dropdown.
 */
public class ViolationAddController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Load all tickets so the form can show a dropdown
        try {
            ParkingTicketDAO ticketDAO = new ParkingTicketDAO();
            List<ParkingTicket> tickets = ticketDAO.readParkingTickets();
            request.setAttribute("tickets", tickets);
        } catch (Exception e) {
            // If tickets can't be loaded, still show the form (free-text fallback)
            request.setAttribute("ticketLoadError", e.getMessage());
        }

        request.getRequestDispatcher("/views/admin/addViolation.jsp").forward(request, response);
    }
}
