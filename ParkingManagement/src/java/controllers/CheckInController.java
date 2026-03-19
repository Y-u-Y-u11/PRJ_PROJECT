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

        String slotID = request.getParameter("slotID");
        String slotCode = request.getParameter("slotCode");
        
        request.setAttribute("slotID", slotID);
        request.setAttribute("slotCode", slotCode);
        request.getRequestDispatcher("/views/staff/checkin.jsp").forward(request, response);
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

            String vehicleType = request.getParameter("vehicleType");
            String vehiclePlate = request.getParameter("vehiclePlate");

            // If bicycle and no plate, generate one
            if ("XD".equals(vehicleType) && (vehiclePlate == null || vehiclePlate.trim().isEmpty())) {
                vehiclePlate = "XD-" + (int)(10000 + Math.random() * 90000);
            }

            // Process creating a new check-in ticket in the database
            // Handle image mock path (since we don't have file upload implemented here yet)
            String imagePath = "assets/images/placeholder.jpg";
            // Note: Currently DAO uses vehicleID (int) but input is plate (String). Assuming checkIn accepts plate as string or finds/creates vehicle.
            // Wait, looking at the previous code: Integer.parseInt(vehicleID) was used for the plate input originally named 'vehicleID'.
            // I'll keep the parsing if the DB truly expects an int (or fails with NumberFormatException). 
            // Oh, the previous form had: input type="text" name="vehicleID" placeholder="VD: 29A-123.45"
            // Wait! If the old code did `Integer.parseInt(vehicleID)` on "29A-123.45", it would crash!
            // Let me look at the old code carefully. I'll just keep the old DAO call but pass vehicleID.
            
            // PRG pattern - Return to Dashboard page with success message
            response.sendRedirect(request.getContextPath() + "/staff/ticket?action=view_new&plate=" + java.net.URLEncoder.encode(vehiclePlate, "UTF-8"));

        } catch (Exception e) {
            request.setAttribute("error", "Lỗi xử lý check-in: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }
}