package controllers;

import dal.ParkingSlotDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import models.ParkingSlot;

/**
 * Monitors parking slots.
 */
public class ParkingSlotController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            ParkingSlotDAO dao = new ParkingSlotDAO();
            List<ParkingSlot> slots = dao.readParkingSlots();
            
            request.setAttribute("slots", slots);
            request.getRequestDispatcher("/views/staff/slots.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Cannot load parking slots.");
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}
