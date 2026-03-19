package controllers;

import dal.ParkingTicketDAO;
import dal.ViolationDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.ParkingTicket;
import models.User;
import models.Violation;

/**
 * Controller for editing an existing parking violation.
 * Loads available parking tickets for the ticket ID dropdown.
 */
public class ViolationEditController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            session.setAttribute("error", "Missing violation ID.");
            response.sendRedirect(request.getContextPath() + "/admin/violations");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            ViolationDAO dao = new ViolationDAO();

            // Find violation by ID
            List<Violation> list = dao.readViolations();
            Violation targetViolation = null;
            for (Violation v : list) {
                if (v.getViolationID() == id) {
                    targetViolation = v;
                    break;
                }
            }

            if (targetViolation == null) {
                session.setAttribute("error", "Violation not found: ID " + id);
                response.sendRedirect(request.getContextPath() + "/admin/violations");
                return;
            }

            // Load tickets for dropdown
            ParkingTicketDAO ticketDAO = new ParkingTicketDAO();
            List<ParkingTicket> tickets = ticketDAO.readParkingTickets();

            request.setAttribute("violation", targetViolation);
            request.setAttribute("tickets", tickets);
            request.getRequestDispatcher("/views/admin/editViolation.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid violation ID.");
            response.sendRedirect(request.getContextPath() + "/admin/violations");
        } catch (Exception e) {
            session.setAttribute("error", "Error loading violation: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/violations");
        }
    }
}
