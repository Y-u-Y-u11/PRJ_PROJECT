package controllers.staff;

import dal.MonthlyCardDAO;
import dal.VehicleTypeDAO;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.MonthlyCard;
import model.VehicleType;

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
                if (idParam != null) {
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

        try {
            if ("add".equals(action)) {
                MonthlyCard newCard = new MonthlyCard();
                newCard.setCustomerID(Integer.parseInt(request.getParameter("customerID")));
                newCard.setVehicleTypeID(Integer.parseInt(request.getParameter("vehicleTypeID")));
                newCard.setPlateNumber(request.getParameter("plateNumber"));
                newCard.setPrice(Double.parseDouble(request.getParameter("price")));
                
                String startDateStr = request.getParameter("startDate");
                String monthsStr = request.getParameter("months");
                
                String endDateStr = startDateStr;
                if (startDateStr != null && !startDateStr.isEmpty()) {
                    LocalDate stDate = LocalDate.parse(startDateStr);
                    int months = (monthsStr != null && !monthsStr.isEmpty()) ? Integer.parseInt(monthsStr) : 1;
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
                card.setCardID(Integer.parseInt(request.getParameter("cardID")));
                card.setCustomerID(Integer.parseInt(request.getParameter("customerID")));
                card.setVehicleTypeID(Integer.parseInt(request.getParameter("vehicleTypeID")));
                card.setPlateNumber(request.getParameter("plateNumber"));
                card.setStartDate(request.getParameter("startDate"));
                card.setEndDate(request.getParameter("endDate"));
                card.setPrice(Double.parseDouble(request.getParameter("price")));
                card.setStatus(request.getParameter("status"));
                
                dao.updateMonthlyCard(card);
                session.setAttribute("message", "Cập nhật thẻ tháng thành công!");
            } 
            else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("cardID"));
                dao.deleteMonthlyCard(id);
                session.setAttribute("message", "Xóa thẻ tháng thành công!");
            }
        } catch (Exception e) {
            session.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/staff/monthlycard");
    }
}