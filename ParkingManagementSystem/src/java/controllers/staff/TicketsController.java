package controllers.staff;

import dal.MonthlyCardDAO;
import dal.ParkingSlotDAO;
import dal.ParkingTicketDAO;
import dal.VehicleTypeDAO;
import dal.PaymentTransactionDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ParkingSlot;
import model.ParkingTicket;
import model.PaymentTransaction;
import model.Users;
import model.VehicleType;

public class TicketsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getRequestURI().substring(request.getContextPath().length());

        ParkingSlotDAO sDao = new ParkingSlotDAO();
        VehicleTypeDAO vDao = new VehicleTypeDAO();
        ParkingTicketDAO tDao = new ParkingTicketDAO();
        PaymentTransactionDAO ptDao = new PaymentTransactionDAO();

        // DANH SÁCH TICKETS
        if ("/staff/tickets".equals(action) || "/staff/tickets/".equals(action)) {

            String keyword = request.getParameter("keyword");
            String status = request.getParameter("status");

            Users currentUser = (Users) request.getSession().getAttribute("LOGIN_USER");

            // Lấy toàn bộ vé từ DB dựa trên keyword và status
            List<ParkingTicket> list = tDao.getAll(keyword, status);

            request.setAttribute("tickets", list);
            request.setAttribute("keyword", keyword);
            request.setAttribute("statusFilter", status);
            // Forward sang tickets_list.jsp
            request.getRequestDispatcher("/views/staff/tickets_list.jsp").forward(request, response);

            // VIEW CHI TIẾT
        } else if ("/staff/tickets/view".equals(action)) {

            int id = Integer.parseInt(request.getParameter("id"));
            ParkingTicket ticket = tDao.getById(id);
            List<PaymentTransaction> payments = ptDao.getByTicketId(id);

            request.setAttribute("ticket", ticket);
            request.setAttribute("payments", payments);
            request.getRequestDispatcher("/views/staff/tickets_view.jsp").forward(request, response);

            // CHECK-IN
        } else if ("/staff/tickets/checkin".equals(action)) {

            List<ParkingSlot> availableSlots = sDao.getAvailableSlots();
            List<VehicleType> vehicleTypes = vDao.getAll();

            request.setAttribute("availableSlots", availableSlots);
            request.setAttribute("vehicleTypes", vehicleTypes);
            request.getRequestDispatcher("/views/staff/tickets_checkin.jsp").forward(request, response);

            // SEARCH (đang gửi xe)
        } else if ("/staff/tickets/search".equals(action)) {

            String keyword = request.getParameter("keyword");

            if (keyword != null && !keyword.trim().isEmpty()) {
                List<ParkingTicket> tickets = tDao.getAll(keyword, "Parking");
                request.setAttribute("tickets", tickets);
                request.setAttribute("keyword", keyword);
            }

            request.getRequestDispatcher("/views/staff/tickets_search.jsp").forward(request, response);

            // CHECK-OUT
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

        // Lấy URL 
        String action = request.getRequestURI().substring(request.getContextPath().length());

        ParkingTicketDAO tDao = new ParkingTicketDAO();
        Users currentUser = (Users) request.getSession().getAttribute("LOGIN_USER");

        if ("/staff/tickets/checkin".equals(action)) {
            String mode = request.getParameter("checkInMode");
            String isSubmit = request.getParameter("submitAction"); // From the submit button or hidden field
            
            // If it's just a mode change via radio button onchange="this.form.submit()"
            if (!"save".equals(isSubmit)) {
                request.setAttribute("checkInMode", mode);
                doGet(request, response);
                return;
            }

            String plateNumber = request.getParameter("plateNumber");
            int vehicleTypeId = 0;
            Integer monthlyCardID = null;
            Integer customerID = null;

            // Generate unique ticket code
            String ticketCode = "TK-" + System.currentTimeMillis();

            MonthlyCardDAO mcDao = new MonthlyCardDAO();

            if ("monthly".equals(mode)) {
                String cardIdStr = request.getParameter("cardId");
                if (cardIdStr == null || cardIdStr.trim().isEmpty()) {
                    request.setAttribute("error", "Error: Please enter Monthly Card ID.");
                    doGet(request, response);
                    return;
                }
                int cardId = Integer.parseInt(cardIdStr);
                // Validate against active monthly subscriptions
                model.MonthlyCard card = mcDao.getById(cardId);
                
                if (card == null || !"Active".equals(card.getStatus())) {
                    request.setAttribute("error", "Error: Monthly card not found or not active.");
                    doGet(request, response);
                    return;
                }
                
                // Prevent double-entry even for monthly card holders
                if (tDao.isPlateActive(card.getPlateNumber())) {
                    request.setAttribute("error", "Error: Vehicle with plate " + card.getPlateNumber() + " is already in the lot.");
                    doGet(request, response);
                    return;
                }

                plateNumber = card.getPlateNumber();
                vehicleTypeId = card.getVehicleTypeID();
                monthlyCardID = card.getCardID();
                customerID = card.getCustomerID();
            } else {
                // Standard Transient Ticket Mode
                if (plateNumber != null && !plateNumber.trim().isEmpty()) {
                    if (tDao.isPlateActive(plateNumber)) {
                        request.setAttribute("error", "Error: This vehicle is already checked in.");
                        doGet(request, response);
                        return;
                    }
                }
                vehicleTypeId = Integer.parseInt(request.getParameter("vehicleTypeId"));
                
                // Automatic detection of active monthly cards by plate number
                model.MonthlyCard autoCard = mcDao.getActiveCardByPlate(plateNumber);
                if (autoCard != null) {
                    monthlyCardID = autoCard.getCardID();
                    customerID = autoCard.getCustomerID();
                    vehicleTypeId = autoCard.getVehicleTypeID(); 
                }
            }

            // Handle parking slot assignment
            String slotIdStr = request.getParameter("slotId");
            Integer slotId = (slotIdStr != null && !slotIdStr.isEmpty()) ? Integer.parseInt(slotIdStr) : null;

            ParkingTicket ticket = new ParkingTicket(
                    0,
                    ticketCode,
                    plateNumber,
                    vehicleTypeId,
                    slotId,
                    customerID,
                    monthlyCardID,
                    new java.sql.Timestamp(System.currentTimeMillis()),
                    null,
                    currentUser != null ? currentUser.getId() : 2, // Default staff ID fallback
                    null,
                    "Parking"
            );

            // Persist the new ticket
            ParkingTicket createdTicket = tDao.create(ticket);

            if (createdTicket != null) {
                // In vé
                VehicleTypeDAO vDao = new VehicleTypeDAO();
                VehicleType vehicleType = vDao.getById(vehicleTypeId);

                request.setAttribute("ticket", createdTicket);
                request.setAttribute("vehicleType", vehicleType);
                request.getRequestDispatcher("/views/staff/ticket.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Lỗi tạo vé Check-in. Vui lòng thử lại.");
                doGet(request, response);
            }
        }
    }
}
