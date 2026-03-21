package controllers.staff;

import dal.MonthlyCardDAO;
import dal.VehicleTypeDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.MonthlyCard;
import model.VehicleType;

@WebServlet(name = "MonthlyCardController", urlPatterns = {"/staff/monthlycard", "/staff/monthlycard/create", "/staff/monthlycard/update"})
public class MonthlyCardController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        MonthlyCardDAO dao = new MonthlyCardDAO();
        VehicleTypeDAO vtDao = new VehicleTypeDAO();

        try {
            // Lấy danh sách loại xe để truyền vào form Create/Update
            List<VehicleType> vehicleTypes = vtDao.getAll();
            request.setAttribute("vehicleTypes", vehicleTypes);

            if ("/staff/monthlycard/create".equals(path)) {
                request.getRequestDispatcher("/views/staff/monthlycard_create.jsp").forward(request, response);
            } 
            else if ("/staff/monthlycard/update".equals(path)) {
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isEmpty()) {
                    List<MonthlyCard> cards = dao.getCardsWithSearchAndSort(null, "cardID", "asc");
                    MonthlyCard cardToEdit = cards.stream()
                            .filter(c -> c.getCardID() == Integer.parseInt(idParam))
                            .findFirst().orElse(null);
                    request.setAttribute("card", cardToEdit);
                }
                request.getRequestDispatcher("/views/staff/monthlycard_update.jsp").forward(request, response);
            } 
            else {
                // TRANG DANH SÁCH
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

        try {
            if ("add".equals(action)) {
                MonthlyCard newCard = new MonthlyCard();
                
                int vehicleTypeID = parseIntSafe(request.getParameter("vehicleTypeID"), 1);
                int months = parseIntSafe(request.getParameter("months"), 1);
                
                // Tính toán ngầm giá tiền: (Giá mặc định của loại xe) * 20 * (số tháng)
                double calculatedPrice = 0.0;
                VehicleType vt = vtDao.getById(vehicleTypeID);
                if (vt != null && vt.getCurrentPrice() != null) {
                    calculatedPrice = vt.getCurrentPrice().doubleValue() * 20 * months;
                }
                
                newCard.setCustomerID(parseIntSafe(request.getParameter("customerID"), 0));
                newCard.setVehicleTypeID(vehicleTypeID);
                newCard.setPlateNumber(request.getParameter("plateNumber"));
                newCard.setPrice(calculatedPrice); // Gán giá đã được tính ngầm
                
                String startDateStr = request.getParameter("startDate");
                String endDateStr = startDateStr;
                
                if (startDateStr != null && !startDateStr.isEmpty()) {
                    LocalDate stDate = LocalDate.parse(startDateStr);
                    endDateStr = stDate.plusMonths(months).toString();
                }

                newCard.setStartDate(startDateStr);
                newCard.setEndDate(endDateStr);
                newCard.setStatus("Active");

                dao.createMonthlyCard(newCard);
                session.setAttribute("message", "Thêm thẻ tháng thành công!");
            } 
            else if ("edit".equals(action)) {
                MonthlyCard card = new MonthlyCard();
                
                int vehicleTypeID = parseIntSafe(request.getParameter("vehicleTypeID"), 1);
                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");
                
                // Tính toán lại số tháng nếu admin thay đổi ngày hết hạn
                long months = 1;
                if (startDateStr != null && endDateStr != null && !startDateStr.isEmpty() && !endDateStr.isEmpty()) {
                    LocalDate stDate = LocalDate.parse(startDateStr);
                    LocalDate enDate = LocalDate.parse(endDateStr);
                    months = ChronoUnit.MONTHS.between(stDate, enDate);
                    if (months <= 0) months = 1; // Đảm bảo tối thiểu là 1 tháng
                }
                
                // Tính toán ngầm giá tiền cập nhật
                double calculatedPrice = 0.0;
                VehicleType vt = vtDao.getById(vehicleTypeID);
                if (vt != null && vt.getCurrentPrice() != null) {
                    calculatedPrice = vt.getCurrentPrice().doubleValue() * 20 * months;
                }

                card.setCardID(parseIntSafe(request.getParameter("cardID"), 0));
                card.setCustomerID(parseIntSafe(request.getParameter("customerID"), 0));
                card.setVehicleTypeID(vehicleTypeID);
                card.setPlateNumber(request.getParameter("plateNumber"));
                card.setStartDate(startDateStr);
                card.setEndDate(endDateStr);
                card.setPrice(calculatedPrice); // Gán giá đã được tính ngầm lại
                card.setStatus(request.getParameter("status"));
                
                dao.updateMonthlyCard(card);
                session.setAttribute("message", "Cập nhật thẻ tháng thành công!");
            } 
            else if ("delete".equals(action)) {
                int id = parseIntSafe(request.getParameter("cardID"), 0);
                if(id > 0) {
                    dao.deleteMonthlyCard(id);
                    session.setAttribute("message", "Xóa thẻ tháng thành công!");
                }
            }
        } catch (Exception e) {
            session.setAttribute("error", "Đã xảy ra lỗi khi lưu: Vui lòng kiểm tra lại dữ liệu đầu vào.");
            System.out.println("Error details: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/staff/monthlycard");
    }

    // Các hàm Helper để xử lý an toàn Null/Empty String
    private int parseIntSafe(String val, int defaultVal) {
        if (val == null || val.trim().isEmpty()) return defaultVal;
        try {
            return Integer.parseInt(val.trim());
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }

    private double parseDoubleSafe(String val, double defaultVal) {
        if (val == null || val.trim().isEmpty()) return defaultVal;
        try {
            return Double.parseDouble(val.trim());
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }
}