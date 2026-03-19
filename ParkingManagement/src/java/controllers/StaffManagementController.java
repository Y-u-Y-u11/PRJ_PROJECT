package controllers;

import dal.UserDAO;
import models.User;
import java.io.IOException;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Controller for managing staff members.
 * Supports search by name/username/phone and column sorting.
 */
public class StaffManagementController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        // Check Admin role
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            UserDAO dao = new UserDAO();
            String searchQuery = request.getParameter("search");
            List<User> staffList;

            // Handle search
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                staffList = dao.searchStaff(searchQuery.trim());
                request.setAttribute("searchKeyword", searchQuery.trim());
            } else {
                staffList = dao.getAllStaff();
            }

            // ---- Sorting ----
            String sort = request.getParameter("sort");
            String order = request.getParameter("order");

            if (sort == null || sort.isEmpty()) {
                sort = "userID";
            }
            if (order == null || order.isEmpty()) {
                order = "asc";
            }

            Comparator<User> comparator;
            switch (sort) {
                case "fullName":
                    comparator = Comparator.comparing(User::getFullName, Comparator.nullsFirst(String::compareTo));
                    break;
                case "username":
                    comparator = Comparator.comparing(User::getUsername, Comparator.nullsFirst(String::compareTo));
                    break;
                case "phone":
                    comparator = Comparator.comparing(User::getPhone, Comparator.nullsFirst(String::compareTo));
                    break;
                case "status":
                    // Sort by status: active first (true > false)
                    comparator = Comparator.comparing(User::isStatus).reversed();
                    break;
                default: // userID
                    comparator = Comparator.comparingInt(User::getUserID);
                    break;
            }

            if ("desc".equalsIgnoreCase(order)) {
                // For status column desc means inactive first
                comparator = comparator.reversed();
            }
            staffList = staffList.stream().sorted(comparator).collect(Collectors.toList());

            request.setAttribute("staffList", staffList);
            request.setAttribute("sort", sort);
            request.setAttribute("order", order);
            request.setAttribute("nextOrder", "asc".equalsIgnoreCase(order) ? "desc" : "asc");

            request.getRequestDispatcher("/views/admin/staffManagement.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Error retrieving staff: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Fix encoding for Vietnamese characters
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        try {
            UserDAO dao = new UserDAO();

            if ("add".equals(action)) {
                User newStaff = new User();
                newStaff.setFullName(request.getParameter("fullName"));
                newStaff.setUsername(request.getParameter("username"));
                newStaff.setPassword(request.getParameter("password"));
                newStaff.setRole("staff");
                newStaff.setPhone(request.getParameter("phone"));
                newStaff.setStatus(true);

                dao.createUser(newStaff);
                session.setAttribute("message", "Thêm nhân viên thành công!");

            } else if ("update".equals(action)) {
                int staffId = Integer.parseInt(request.getParameter("id"));
                User existingStaff = dao.getUserById(staffId);

                if (existingStaff != null) {
                    User updatedStaff = new User();
                    updatedStaff.setUserID(staffId);
                    updatedStaff.setFullName(request.getParameter("fullName"));
                    updatedStaff.setUsername(request.getParameter("username"));
                    updatedStaff.setPhone(request.getParameter("phone"));
                    updatedStaff.setRole(existingStaff.getRole());
                    updatedStaff.setPassword(existingStaff.getPassword());
                    boolean status = "ACTIVE".equals(request.getParameter("status"));
                    updatedStaff.setStatus(status);

                    dao.updateUser(updatedStaff);
                    session.setAttribute("message", "Cập nhật thông tin nhân viên thành công!");
                }

            } else if ("delete".equals(action)) {
                int staffId = Integer.parseInt(request.getParameter("id"));
                dao.deleteUsers(staffId);
                session.setAttribute("message", "Nhân viên đã được vô hiệu hóa/xóa thành công!");
            }

            response.sendRedirect(request.getContextPath() + "/admin/staffManagement");

        } catch (Exception e) {
            session.setAttribute("error", "Lỗi thao tác: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/staffManagement");
        }
    }
}