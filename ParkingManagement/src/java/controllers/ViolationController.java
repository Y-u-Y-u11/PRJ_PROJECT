package controllers;

import dal.ViolationDAO;
import java.io.IOException;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;
import models.Violation;

/**
 * Controller for managing parking violations.
 * Supports sorting by column and searching by ticketID or reason.
 */
public class ViolationController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // Must be logged in and must be an admin
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        ViolationDAO dao = new ViolationDAO();
        List<Violation> violationsList = dao.readViolations();

        // ---- Search/filter ----
        String search = request.getParameter("search");
        if (search != null && !search.trim().isEmpty()) {
            String kw = search.trim().toLowerCase();
            violationsList = violationsList.stream()
                    .filter(v -> (v.getTicketID() != null && v.getTicketID().toLowerCase().contains(kw))
                            || (v.getReason() != null && v.getReason().toLowerCase().contains(kw)))
                    .collect(Collectors.toList());
            request.setAttribute("search", search.trim());
        }

        // ---- Sorting ----
        String sort = request.getParameter("sort");
        String order = request.getParameter("order");

        // Default sort
        if (sort == null || sort.isEmpty()) {
            sort = "violationID";
        }
        if (order == null || order.isEmpty()) {
            order = "asc";
        }

        Comparator<Violation> comparator;
        switch (sort) {
            case "ticketID":
                comparator = Comparator.comparing(Violation::getTicketID, Comparator.nullsFirst(String::compareTo));
                break;
            case "reason":
                comparator = Comparator.comparing(Violation::getReason, Comparator.nullsFirst(String::compareTo));
                break;
            case "fineAmount":
                comparator = Comparator.comparingDouble(Violation::getFineAmount);
                break;
            default: // violationID
                comparator = Comparator.comparingInt(Violation::getViolationID);
                break;
        }

        if ("desc".equalsIgnoreCase(order)) {
            comparator = comparator.reversed();
        }
        violationsList = violationsList.stream().sorted(comparator).collect(Collectors.toList());

        // Pass data to JSP
        request.setAttribute("violations", violationsList);
        request.setAttribute("sort", sort);
        request.setAttribute("order", order);
        // Pre-compute next order for toggle links
        request.setAttribute("nextOrder", "asc".equalsIgnoreCase(order) ? "desc" : "asc");

        request.getRequestDispatcher("/views/admin/violations.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // Must be logged in and must be an admin
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        ViolationDAO dao = new ViolationDAO();

        try {
            if ("add".equals(action)) {
                String ticketID = request.getParameter("ticketID");
                String reason = request.getParameter("reason");
                double fineAmount = Double.parseDouble(request.getParameter("fineAmount"));

                Violation v = new Violation(0, ticketID, reason, fineAmount);
                dao.createViolation(v);
                session.setAttribute("message", "Thêm vi phạm thành công!");

            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("violationID"));
                String ticketID = request.getParameter("ticketID");
                String reason = request.getParameter("reason");
                double fineAmount = Double.parseDouble(request.getParameter("fineAmount"));

                Violation v = new Violation(id, ticketID, reason, fineAmount);
                dao.updateViolation(v);
                session.setAttribute("message", "Cập nhật vi phạm thành công!");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("violationID"));
                dao.deleteViolation(id);
                session.setAttribute("message", "Xóa vi phạm thành công!");
            }
        } catch (Exception e) {
            session.setAttribute("error", "Lỗi thao tác: " + e.getMessage());
        }

        // Post-Redirect-Get
        response.sendRedirect(request.getContextPath() + "/admin/violations");
    }
}
