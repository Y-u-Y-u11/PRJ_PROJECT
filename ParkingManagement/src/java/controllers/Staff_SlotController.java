package controllers;

import dal.ParkingSlotDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.ParkingSlot;

public class Staff_SlotController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        ParkingSlotDAO dao = new ParkingSlotDAO();

        if ("add".equals(action)) {
            String slotCode = request.getParameter("slotCode");
            String zoneID = request.getParameter("zoneID");
            ParkingSlot s = new ParkingSlot(0, slotCode, zoneID, "Empty");
            dao.createParkingSlot(s);
        } else if ("delete".equals(action)) {
            int slotID = Integer.parseInt(request.getParameter("slotID"));
            dao.deleteParkingSlot(slotID);
        }
        
        response.sendRedirect(request.getContextPath() + "/staff/dashboard");
    }
}