package controllers;

import dal.UserDAO;
import models.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "StaffManagementController", urlPatterns = {"/admin/staffManagement"})
public class StaffManagementController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");
        
        // Kiểm tra quyền Admin
        if (currentUser == null || !"admin".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            UserDAO dao = new UserDAO();
            String searchQuery = request.getParameter("search");
            List<User> staffList;
            
            // TÍNH NĂNG MỚI: Xử lý tìm kiếm
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                staffList = dao.searchStaff(searchQuery.trim());
                request.setAttribute("searchKeyword", searchQuery); // Giữ lại keyword trên ô tìm kiếm
            } else {
                staffList = dao.getAllStaff(); 
            }
            
            request.setAttribute("staffList", staffList);
            request.getRequestDispatcher("/views/admin/staffManagement.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Error retrieving staff: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Fix lỗi hiển thị tiếng Việt khi submit form
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
                newStaff.setPassword(request.getParameter("password")); // Hash this in production
                newStaff.setRole("staff");
                newStaff.setPhone(request.getParameter("phone")); // Đồng bộ field name
                newStaff.setStatus(true); // Mặc định là active khi tạo mới
                
                dao.createUser(newStaff);
                session.setAttribute("message", "Thêm nhân viên thành công!");
                
            } else if ("update".equals(action)) {
                // TÍNH NĂNG MỚI: Xử lý cập nhật
                int staffId = Integer.parseInt(request.getParameter("id"));
                User existingStaff = dao.getUserById(staffId);
                
                if (existingStaff != null) {
                    User updatedStaff = new User();
                    updatedStaff.setUserID(staffId);
                    updatedStaff.setFullName(request.getParameter("fullName"));
                    updatedStaff.setUsername(request.getParameter("username"));
                    updatedStaff.setPhone(request.getParameter("phone")); // Đồng bộ field name
                    updatedStaff.setRole(existingStaff.getRole());
                    
                    // Giữ lại password cũ vì ở form update ta không nhập password
                    updatedStaff.setPassword(existingStaff.getPassword());
                    
                    boolean status = "ACTIVE".equals(request.getParameter("status"));
                    updatedStaff.setStatus(status);
                    
                    dao.updateUser(updatedStaff);
                    session.setAttribute("message", "Cập nhật nhân viên thành công!");
                }
                
            } else if ("delete".equals(action)) {
                int staffId = Integer.parseInt(request.getParameter("id"));
                dao.deleteUsers(staffId);
                session.setAttribute("message", "Xóa/Khóa nhân viên thành công!");
            }
            
            // Áp dụng PRG Pattern
            response.sendRedirect(request.getContextPath() + "/admin/staffManagement");
            
        } catch (Exception e) {
            session.setAttribute("error", "Thao tác thất bại: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/staffManagement");
        }
    }
}