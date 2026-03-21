package controllers.staff;

import dal.MonthlyCardDAO;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;
import model.MonthlyCard;

/**
 * Handles monthly subscriptions. Accessible by Staff.
 */
public class MonthlyCardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null || !"staff".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get search and sort parameters
            String search = request.getParameter("search");
            String sort = request.getParameter("sort");
            String order = request.getParameter("order");

            // Default values
            if (sort == null || sort.isEmpty()) sort = "cardID";
            if (order == null || order.isEmpty()) order = "asc";
            
            String nextOrder = order.equals("asc") ? "desc" : "asc";

            MonthlyCardDAO dao = new MonthlyCardDAO();
            List<MonthlyCard> cards = dao.getCardsWithSearchAndSort(search, sort, order);
            
            // Set attributes for JSP
            request.setAttribute("cards", cards);
            request.setAttribute("searchKeyword", search != null ? search : "");
            request.setAttribute("sort", sort);
            request.setAttribute("order", order);
            request.setAttribute("nextOrder", nextOrder);
            
            request.getRequestDispatcher("/views/staff/subscriptions.jsp").forward(request, response);
        } catch (Exception e) {
            session.setAttribute("error", "Error loading subscriptions: " + e.getMessage());
            request.getRequestDispatcher("/views/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null || !"staff".equalsIgnoreCase(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            request.setCharacterEncoding("UTF-8");
            String action = request.getParameter("action");
            MonthlyCardDAO dao = new MonthlyCardDAO();

            if ("add".equals(action)) {
                // Đọc linh hoạt tên biến tránh NULL
                String customerInput = request.getParameter("customerName");
                if (customerInput == null || customerInput.isEmpty()) customerInput = request.getParameter("customerID");

                String plateInput = request.getParameter("licensePlate");
                if (plateInput == null || plateInput.isEmpty()) plateInput = request.getParameter("vehicleID");

                String vehicleType = request.getParameter("vehicleType");
                String startDateStr = request.getParameter("startDate");
                String monthsStr = request.getParameter("months");

                // 1. Tự động tính ngày hết hạn dựa trên số tháng
                String endDateStr = startDateStr;
                if (startDateStr != null && !startDateStr.isEmpty()) {
                    try {
                        LocalDate stDate = LocalDate.parse(startDateStr);
                        int months = (monthsStr != null && !monthsStr.isEmpty()) ? Integer.parseInt(monthsStr) : 1;
                        endDateStr = stDate.plusMonths(months).toString();
                    } catch (Exception ex) {
                        System.out.println("Lỗi tính ngày: " + ex.getMessage());
                    }
                }

                // 2. Class Helper dùng kết nối JDBC hiện có để tự động thêm mới Customer và Vehicle nếu chưa tồn tại
                class LocalHelper extends dal.DBContext {
                    public String[] processNewSubscription(String cInput, String plate, String vType) throws Exception {
                        int cId = -1, vId = -1;
                        PreparedStatement ps = null;
                        ResultSet rs = null;

                        try {
                            // Xử lý Customer (Nếu nhập số => Tìm theo ID, nếu nhập chữ => Insert Tên mới)
                            if (cInput != null && cInput.matches("\\d+")) {
                                ps = connection.prepareStatement("SELECT customerID FROM Customer WHERE customerID = ?");
                                ps.setInt(1, Integer.parseInt(cInput));
                                rs = ps.executeQuery();
                                if (rs.next()) cId = rs.getInt(1);
                            }
                            if (cId == -1 && cInput != null && !cInput.trim().isEmpty()) {
                                ps = connection.prepareStatement("INSERT INTO Customer (fullName) VALUES (?)", Statement.RETURN_GENERATED_KEYS);
                                ps.setString(1, cInput.trim());
                                ps.executeUpdate();
                                rs = ps.getGeneratedKeys();
                                if (rs.next()) cId = rs.getInt(1);
                            }

                            // Xử lý Vehicle (Tìm theo Biển số, nếu chưa có thì Insert theo Loại và CustomerID)
                            if (plate != null && !plate.trim().isEmpty()) {
                                String cleanPlate = plate.trim().toUpperCase();
                                ps = connection.prepareStatement("SELECT vehicleID FROM Vehicle WHERE plateNumber = ?");
                                ps.setString(1, cleanPlate);
                                rs = ps.executeQuery();
                                if (rs.next()) {
                                    vId = rs.getInt(1);
                                } else {
                                    int typeId = (vType != null && !vType.isEmpty()) ? Integer.parseInt(vType) : 1;
                                    ps = connection.prepareStatement("INSERT INTO Vehicle (plateNumber, customerID, typeID) VALUES (?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
                                    ps.setString(1, cleanPlate);
                                    if (cId != -1) ps.setInt(2, cId);
                                    else ps.setNull(2, java.sql.Types.INTEGER);
                                    ps.setInt(3, typeId);
                                    ps.executeUpdate();
                                    rs = ps.getGeneratedKeys();
                                    if (rs.next()) vId = rs.getInt(1);
                                }
                            }
                        } catch (Exception e) {
                            System.out.println("Lỗi Insert liên kết: " + e.getMessage());
                        }
                        return new String[]{cId != -1 ? String.valueOf(cId) : null, vId != -1 ? String.valueOf(vId) : null};
                    }
                }

                // Chạy Helper để lấy ID chuẩn
                LocalHelper helper = new LocalHelper();
                String[] ids = helper.processNewSubscription(customerInput, plateInput, vehicleType);
                
                // 3. Tạo thẻ tháng với Data sạch
                MonthlyCard newCard = new MonthlyCard();
                newCard.setCustomerID(ids[0] != null ? ids[0] : customerInput);
                newCard.setVehicleID(ids[1] != null ? ids[1] : plateInput);
                newCard.setStartDate(startDateStr);
                newCard.setEndDate(endDateStr);
                newCard.setStatus("Active"); // Trạng thái mặc định

                dao.createMonthlyCard(newCard);
                session.setAttribute("message", "Thêm thẻ tháng thành công!");
                
            } else if ("edit".equals(action)) {
                MonthlyCard card = new MonthlyCard();
                card.setCardID(Integer.parseInt(request.getParameter("cardID")));
                card.setCustomerID(request.getParameter("customerID"));
                card.setVehicleID(request.getParameter("vehicleID"));
                card.setStartDate(request.getParameter("startDate"));
                card.setEndDate(request.getParameter("endDate"));
                card.setStatus(request.getParameter("status"));
                dao.updateMonthlyCard(card);
                session.setAttribute("message", "Cập nhật thẻ tháng thành công!");
                
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("cardID"));
                dao.deleteMonthlyCard(id);
                session.setAttribute("message", "Xóa thẻ tháng thành công!");
            }
            
            // PRG pattern
            response.sendRedirect(request.getContextPath() + "/staff/subscriptions");
            
        } catch (Exception e) {
            session.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/staff/subscriptions");
        }
    }
}