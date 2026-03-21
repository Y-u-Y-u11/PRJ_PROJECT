package controllers.staff;

import dal.ParkingSlotDAO;
import dal.ParkingTicketDAO;
import dal.VehicleTypeDAO;
import dal.CustomerDAO;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ParkingSlot;
import model.ParkingTicket;
import model.VehicleType;
import model.Users;

public class TicketsController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getServletPath();
        ParkingSlotDAO sDao = new ParkingSlotDAO();
        VehicleTypeDAO vDao = new VehicleTypeDAO();
        ParkingTicketDAO tDao = new ParkingTicketDAO();

        if ("/staff/tickets/checkin".equals(action)) {
            List<ParkingSlot> availableSlots = sDao.getAvailableSlots();
            List<VehicleType> vehicleTypes = vDao.getAll();
            
            request.setAttribute("availableSlots", availableSlots);
            request.setAttribute("vehicleTypes", vehicleTypes);
            request.getRequestDispatcher("/views/staff/tickets_checkin.jsp").forward(request, response);
            
        } else if ("/staff/tickets/search".equals(action)) {
            String keyword = request.getParameter("keyword");
            if (keyword != null && !keyword.trim().isEmpty()) {
                List<ParkingTicket> tickets = tDao.getAll(keyword, "Parking");
                request.setAttribute("tickets", tickets);
                request.setAttribute("keyword", keyword);
            }
            request.getRequestDispatcher("/views/staff/tickets_search.jsp").forward(request, response);
            
        } else if ("/staff/tickets/checkout".equals(action)) {
            String ticketCode = request.getParameter("ticketCode");
            ParkingTicket ticket = null;
            if (ticketCode != null && !ticketCode.trim().isEmpty()) {
                ticket = tDao.getByTicketCode(ticketCode);
            }
            request.setAttribute("ticket", ticket);
            request.setAttribute("ticketCode", ticketCode);
            request.getRequestDispatcher("/views/staff/tickets_checkout.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        String action = request.getServletPath();
        ParkingTicketDAO tDao = new ParkingTicketDAO();
        Users currentUser = (Users) request.getSession().getAttribute("LOGIN_USER");

        if ("/staff/tickets/checkin".equals(action)) {
            String plateNumber = request.getParameter("plateNumber");
            
            if (plateNumber != null && !plateNumber.trim().isEmpty()) {
                if (tDao.isPlateActive(plateNumber)) {
                    request.setAttribute("error", "Lỗi: Biển số xe này đang trong bãi (Chưa Check-out).");
                    doGet(request, response);
                    return;
                }
            }
            
            int vehicleTypeId = Integer.parseInt(request.getParameter("vehicleTypeId"));
            int slotId = Integer.parseInt(request.getParameter("slotId"));
            
            // Generate ticket code: T + timestamp
            String ticketCode = "T" + System.currentTimeMillis();
            
            ParkingTicket ticket = new ParkingTicket(
                0, 
                ticketCode, 
                plateNumber, 
                vehicleTypeId, 
                slotId, 
                null, 
                new java.sql.Timestamp(System.currentTimeMillis()), 
                null, 
                currentUser.getId(), 
                null, 
                "Parking"
            );
            
            if (tDao.create(ticket) != null) {
                // Update slot status to occupied
                ParkingSlotDAO sDao = new ParkingSlotDAO();
                model.ParkingSlot slot = sDao.getById(slotId);
                // The PRD doesn't explicitly mention slot status column, it assumes occupied if ticket refers to it.
                // Our DAO logic uses checking tickets to find available slots, so no need to update slot table.
                
                response.sendRedirect(request.getContextPath() + "/staff/dashboard?msg=checkin_success");
            } else {
                request.setAttribute("error", "Lỗi tạo vé Check-in.");
                doGet(request, response);
            }
        }
    }
}
