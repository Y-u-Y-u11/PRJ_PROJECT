package controllers;

import dal.ParkingZoneDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.ParkingZone;

public class Staff_ZoneController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        ParkingZoneDAO dao = new ParkingZoneDAO();

        if ("add".equals(action)) {
            String zoneName = request.getParameter("zoneName");
            ParkingZone z = new ParkingZone(0, zoneName);
            dao.createParkingZone(z);
        } else if ("delete".equals(action)) {
            int zoneID = Integer.parseInt(request.getParameter("zoneID"));
            dao.deleteParkingZone(zoneID);
        }
        
        // Redirect lại dashboard sau khi thao tác
        response.sendRedirect(request.getContextPath() + "/staff/dashboard");
    }
}