package controllers.staff;

import dal.MonthlyCardDAO;
import dal.VehicleTypeDAO;
import dal.PaymentTransactionDAO;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.MonthlyCard;
import model.VehicleType;
import model.PaymentTransaction;

public class MonthlyCardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String uri = request.getRequestURI(); 
        MonthlyCardDAO dao = new MonthlyCardDAO();
        VehicleTypeDAO vtDao = new VehicleTypeDAO();

        try {
            List<VehicleType> vehicleTypes = vtDao.getAll();
            request.setAttribute("vehicleTypes", vehicleTypes);

            if (uri.endsWith("/create")) {
                request.getRequestDispatcher("/views/staff/monthlycard_create.jsp").forward(request, response);
            } 
            else if (uri.endsWith("/update")) {
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isEmpty()) {
                    List<MonthlyCard> cards = dao.getCardsWithSearchAndSort(null, "cardID", "asc");
                    MonthlyCard cardToEdit = cards.stream()
                            .filter(c -> c.getCardID() == Integer.parseInt(idParam))
                            .findFirst().orElse(null);
                    
                    if (cardToEdit != null) {
                        request.setAttribute("card", cardToEdit);
                        request.getRequestDispatcher("/views/staff/monthlycard_update.jsp").forward(request, response);
                        return;
                    } else {
                        request.getSession().setAttribute("error", "Không tìm thấy thẻ cần sửa!");
                        response.sendRedirect(request.getContextPath() + "/staff/monthlycard");
                        return;
                    }
                }
                response.sendRedirect(request.getContextPath() + "/staff/monthlycard");
            } 
            else {
                String search = request.getParameter("search");
                String sort = request.getParameter("sort");
                String order = request.getParameter("order");

                if (sort == null || sort.isEmpty()) sort = "cardID";
                if (order == null || order.isEmpty()) order = "asc";
                String nextOrder = order.equals("asc") ? "desc" : "asc";

                List<MonthlyCard> cards = dao.getCardsWithSearchAndSort(search, sort, order);
                
                request.setAttribute("cards", cards);
                request.setAttribute("searchKeyword", search != null ? search : "");
                request.setAttribute("sort", sort);
                request.setAttribute("order", order);
                request.setAttribute("nextOrder", nextOrder);
                
                request.getRequestDispatcher("/views/staff/monthlycard.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Lỗi tải trang: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/staff/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        
        MonthlyCardDAO dao = new MonthlyCardDAO();
        VehicleTypeDAO vtDao = new VehicleTypeDAO();
        PaymentTransactionDAO ptDao = new PaymentTransactionDAO();

        try {
            if ("add".equals(action)) {
                MonthlyCard newCard = new MonthlyCard();
                
                int vehicleTypeID = parseIntSafe(request.getParameter("vehicleTypeID"), 1);
                int months = parseIntSafe(request.getParameter("months"), 1);
                String paymentMethod = request.getParameter("paymentMethod"); 
                if (paymentMethod == null || paymentMethod.isEmpty()) paymentMethod = "Cash";
                
                // --- KIỂM TRA BẢNG GIÁ CỦA LOẠI XE TRƯỚC ---
                VehicleType vt = vtDao.getById(vehicleTypeID);
                if (vt == null) {
                    session.setAttribute("error", "Lỗi: Không tìm thấy loại xe hợp lệ trong hệ thống.");
                    response.sendRedirect(request.getContextPath() + "/staff/monthlycard");
                    return;
                }
                if (vt.getCurrentPrice() == null) {
                    session.setAttribute("error", "Lỗi: Loại xe này chưa có Bảng Giá (Pricing). Vui lòng thiết lập giá cho loại xe mới trước khi đăng ký thẻ!");
                    response.sendRedirect(request.getContextPath() + "/staff/monthlycard");
                    return;
                }
                
                double calculatedPrice = vt.getCurrentPrice().doubleValue() * 20 * months;
                
                newCard.setCustomerID(parseIntSafe(request.getParameter("customerID"), 0));
                newCard.setVehicleTypeID(vehicleTypeID);
                newCard.setPlateNumber(request.getParameter("plateNumber"));
                newCard.setPrice(calculatedPrice); 
                
                String startDateStr = request.getParameter("startDate");
                String endDateStr = startDateStr;
                
                if (startDateStr != null && !startDateStr.isEmpty()) {
                    LocalDate stDate = LocalDate.parse(startDateStr);
                    endDateStr = stDate.plusMonths(months).toString();
                }

                newCard.setStartDate(startDateStr);
                newCard.setEndDate(endDateStr);
                newCard.setStatus("Active");

                // KIỂM TRA QUÁ TRÌNH LƯU DB TRƯỚC KHI THU TIỀN
                boolean isCreated = dao.createMonthlyCard(newCard);
                
                if (isCreated) {
                    PaymentTransaction pt = new PaymentTransaction(
                            0, null, 
                            BigDecimal.valueOf(calculatedPrice), 
                            paymentMethod, "Success", 
                            "MCARD-" + System.currentTimeMillis(), null
                    );
                    ptDao.create(pt);
                    session.setAttribute("message", "Thêm thẻ tháng và thu tiền thành công!");
                } else {
                    session.setAttribute("error", "Không thể lưu thẻ! Có thể ID Khách Hàng không tồn tại hoặc dữ liệu không hợp lệ.");
                }
            } 
            else if ("edit".equals(action)) {
                MonthlyCard card = new MonthlyCard();
                
                int vehicleTypeID = parseIntSafe(request.getParameter("vehicleTypeID"), 1);
                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");
                
                long months = 1;
                if (startDateStr != null && endDateStr != null && !startDateStr.isEmpty() && !endDateStr.isEmpty()) {
                    LocalDate stDate = LocalDate.parse(startDateStr);
                    LocalDate enDate = LocalDate.parse(endDateStr);
                    months = ChronoUnit.MONTHS.between(stDate, enDate);
                    if (months <= 0) months = 1;
                }
                
                // --- KIỂM TRA BẢNG GIÁ CỦA LOẠI XE TRƯỚC ---
                VehicleType vt = vtDao.getById(vehicleTypeID);
                if (vt == null) {
                    session.setAttribute("error", "Lỗi: Không tìm thấy loại xe hợp lệ trong hệ thống.");
                    response.sendRedirect(request.getContextPath() + "/staff/monthlycard");
                    return;
                }
                if (vt.getCurrentPrice() == null) {
                    session.setAttribute("error", "Lỗi: Loại xe này chưa có Bảng Giá (Pricing). Vui lòng thiết lập giá trước khi cập nhật thẻ!");
                    response.sendRedirect(request.getContextPath() + "/staff/monthlycard");
                    return;
                }
                
                double calculatedPrice = vt.getCurrentPrice().doubleValue() * 20 * months;

                card.setCardID(parseIntSafe(request.getParameter("cardID"), 0));
                card.setCustomerID(parseIntSafe(request.getParameter("customerID"), 0));
                card.setVehicleTypeID(vehicleTypeID);
                card.setPlateNumber(request.getParameter("plateNumber"));
                card.setStartDate(startDateStr);
                card.setEndDate(endDateStr);
                card.setPrice(calculatedPrice); 
                card.setStatus(request.getParameter("status"));
                
                boolean isUpdated = dao.updateMonthlyCard(card);
                if (isUpdated) {
                    session.setAttribute("message", "Cập nhật thẻ tháng thành công!");
                } else {
                    session.setAttribute("error", "Lỗi: Không thể cập nhật thẻ vào CSDL!");
                }
            } 
            else if ("delete".equals(action)) {
                int id = parseIntSafe(request.getParameter("cardID"), 0);
                if(id > 0) {
                    List<MonthlyCard> cards = dao.getCardsWithSearchAndSort(null, "cardID", "asc");
                    MonthlyCard cardToDelete = cards.stream()
                            .filter(c -> c.getCardID() == id)
                            .findFirst().orElse(null);
                            
                    if (cardToDelete != null) {
                        if ("Active".equalsIgnoreCase(cardToDelete.getStatus())) {
                            session.setAttribute("error", "Lỗi: Không thể xóa thẻ đang trong trạng thái Hoạt động!");
                        } else {
                            dao.deleteMonthlyCard(id);
                            session.setAttribute("message", "Xóa thẻ tháng thành công!");
                        }
                    } else {
                        session.setAttribute("error", "Không tìm thấy thẻ để xóa!");
                    }
                }
            }
        } catch (Exception e) {
            session.setAttribute("error", "Đã xảy ra lỗi khi xử lý dữ liệu đầu vào. Vui lòng kiểm tra lại.");
            System.out.println("Error details: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/staff/monthlycard");
    }

    private int parseIntSafe(String val, int defaultVal) {
        if (val == null || val.trim().isEmpty()) return defaultVal;
        try { return Integer.parseInt(val.trim()); } 
        catch (NumberFormatException e) { return defaultVal; }
    }

    private double parseDoubleSafe(String val, double defaultVal) {
        if (val == null || val.trim().isEmpty()) return defaultVal;
        try { return Double.parseDouble(val.trim()); } 
        catch (NumberFormatException e) { return defaultVal; }
    }
}