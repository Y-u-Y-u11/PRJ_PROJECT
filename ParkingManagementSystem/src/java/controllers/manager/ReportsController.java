package controllers.manager;

import dal.ReportDAO;
import dal.ParkingSlotDAO;
import java.io.IOException;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Report;

public class ReportsController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getServletPath();

        if ("/manager/reports".equals(action)) {
            request.getRequestDispatcher("/views/manager/reports.jsp").forward(request, response);
        } else if ("/manager/reports/revenue".equals(action)) {
            ReportDAO reportDAO = new ReportDAO();
            BigDecimal totalRevenue = reportDAO.calculateTotalRevenue();
            
            // Optional: Save this generated report snapshot
            reportDAO.saveReport(new Report(0, "REVENUE", null, totalRevenue, null, null));
            
            request.setAttribute("totalRevenue", totalRevenue);
            request.getRequestDispatcher("/views/manager/reports_revenue.jsp").forward(request, response);
            
        } else if ("/manager/reports/parking".equals(action)) {
            ParkingSlotDAO slotDAO = new ParkingSlotDAO();
            int total = slotDAO.getAll().size();
            int available = slotDAO.getAvailableSlots().size();
            int occupied = slotDAO.getOccupiedSlots().size();
            
            // Save parking report snapshot
            ReportDAO reportDAO = new ReportDAO();
            reportDAO.saveReport(new Report(0, "PARKING_STATUS", null, null, total, occupied));
            
            request.setAttribute("total", total);
            request.setAttribute("occupied", occupied);
            request.setAttribute("available", available);
            request.getRequestDispatcher("/views/manager/reports_parking.jsp").forward(request, response);
        }
    }
}
