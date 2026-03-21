package controllers.staff;

import dal.ParkingSlotDAO;
import dal.ParkingTicketDAO;
import dal.VehicleTypeDAO;
import dal.PaymentTransactionDAO;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

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

        String action = request.getServletPath();

        ParkingSlotDAO sDao = new ParkingSlotDAO();
        VehicleTypeDAO vDao = new VehicleTypeDAO();
        ParkingTicketDAO tDao = new ParkingTicketDAO();
        PaymentTransactionDAO ptDao = new PaymentTransactionDAO();

        // =========================
        // DANH SÁCH TICKETS
        // =========================
        if ("/staff/tickets".equals(action)) {

            String keyword = request.getParameter("keyword");
            String status = request.getParameter("status");

            Users currentUser = (Users) request.getSession().getAttribute("LOGIN_USER");

            List<ParkingTicket> list = tDao.getAll(keyword, status);

            // Filter theo nhân viên
            if (currentUser != null) {
                list = list.stream()
                        .filter(t
                                -> t.getCheckInStaffID() == currentUser.getId()
                        || (t.getCheckOutStaffID() != null
                        && t.getCheckOutStaffID() == currentUser.getId()))
                        .collect(Collectors.toList());
            }

            request.setAttribute("tickets", list);
            request.setAttribute("keyword", keyword);
            request.setAttribute("statusFilter", status);
            request.getRequestDispatcher("/views/staff/tickets.jsp").forward(request, response);

            // =========================
            // VIEW CHI TIẾT
            // =========================
        } else if ("/staff/tickets/view".equals(action)) {

            int id = Integer.parseInt(request.getParameter("id"));
            ParkingTicket ticket = tDao.getById(id);
            List<PaymentTransaction> payments = ptDao.getByTicketId(id);

            request.setAttribute("ticket", ticket);
            request.setAttribute("payments", payments);
            request.getRequestDispatcher("/views/staff/tickets_view.jsp").forward(request, response);

            // =========================
            // CHECK-IN
            // =========================
        } else if ("/staff/tickets/checkin".equals(action)) {

            List<ParkingSlot> availableSlots = sDao.getAvailableSlots();
            List<VehicleType> vehicleTypes = vDao.getAll();

            request.setAttribute("availableSlots", availableSlots);
            request.setAttribute("vehicleTypes", vehicleTypes);
            request.getRequestDispatcher("/views/staff/tickets_checkin.jsp").forward(request, response);

            // =========================
            // SEARCH (đang gửi xe)
            // =========================
        } else if ("/staff/tickets/search".equals(action)) {

            String keyword = request.getParameter("keyword");

            if (keyword != null && !keyword.trim().isEmpty()) {
                List<ParkingTicket> tickets = tDao.getAll(keyword, "Parking");
                request.setAttribute("tickets", tickets);
                request.setAttribute("keyword", keyword);
            }

            request.getRequestDispatcher("/views/staff/tickets_search.jsp").forward(request, response);

            // =========================
            // CHECK-OUT
            // =========================
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
