package controllers.staff;

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
            String plateNumber = request.getParameter("plateNumber");

            if (plateNumber != null && !plateNumber.trim().isEmpty()) {
                if (tDao.isPlateActive(plateNumber)) {
                    request.setAttribute("error", "Lỗi: Biển số xe này đang trong bãi (Chưa Check-out).");
                    doGet(request, response);
                    return;
                }
            }

            int vehicleTypeId = Integer.parseInt(request.getParameter("vehicleTypeId"));

            // Xử lý cho slotId
            String slotIdStr = request.getParameter("slotId");
            Integer slotId = (slotIdStr != null && !slotIdStr.isEmpty()) ? Integer.parseInt(slotIdStr) : null;

            // Generate ticket code: TK- + timestamp
            String ticketCode = "TK-" + System.currentTimeMillis();

            ParkingTicket ticket = new ParkingTicket(
                    0,
                    ticketCode,
                    plateNumber,
                    vehicleTypeId,
                    slotId,
                    null,
                    new java.sql.Timestamp(System.currentTimeMillis()),
                    null,
                    currentUser != null ? currentUser.getId() : 2, // Mặc định là 2 nếu session null
                    null,
                    "Parking"
            );

            // Gọi DAO tạo vé vào CSDL
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
