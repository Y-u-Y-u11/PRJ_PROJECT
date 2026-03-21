package dal;

import java.util.ArrayList;
import model.MonthlyCard;
import java.sql.*;

/**
 * Data Access Object for MonthlyCard.
 */
public class MonthlyCardDAO extends DBContext {

    private PreparedStatement stm;
    private ResultSet rs;

    public void createMonthlyCard(MonthlyCard o) {
        // Cập nhật câu lệnh INSERT khớp với Database: thêm vehicleTypeID, plateNumber, price
        // Tạm thời set mặc định vehicleTypeID = 1 và price = 0 nếu model chưa có field này
        String sql = "INSERT INTO MonthlyCard (customerID, vehicleTypeID, plateNumber, startDate, endDate, price, status) VALUES (?, 1, ?, ?, ?, 0, ?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getCustomerID());
            stm.setString(2, o.getVehicleID()); // Dùng tạm getVehicleID() chứa dữ liệu plateNumber từ form
            stm.setString(3, o.getStartDate());
            stm.setString(4, o.getEndDate());
            stm.setString(5, o.getStatus());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error Insert: " + e.getMessage());
        }
    }

    public ArrayList<MonthlyCard> getCardsWithSearchAndSort(String search, String sort, String order) {
        ArrayList<MonthlyCard> result = new ArrayList<>();
        
        String safeSort = "m.cardID"; // Default
        if (sort != null) {
            switch (sort) {
                case "customerID": safeSort = "m.customerID"; break;
                case "customerName": safeSort = "c.fullName"; break;
                case "plateNumber": safeSort = "m.plateNumber"; break; // Sửa lại thành m.plateNumber
                case "startDate": safeSort = "m.startDate"; break;
                case "endDate": safeSort = "m.endDate"; break;
                case "status": safeSort = "m.status"; break;
                default: safeSort = "m.cardID"; break;
            }
        }
        
        String safeOrder = "desc".equalsIgnoreCase(order) ? "DESC" : "ASC";
        
        // Sửa lại câu lệnh SELECT: Lấy trực tiếp m.plateNumber, Bỏ JOIN với bảng Vehicle
        String sql = "SELECT m.cardID, m.customerID, c.fullName, m.plateNumber, m.startDate, m.endDate, m.status " +
                     "FROM MonthlyCard m " +
                     "LEFT JOIN Customer c ON m.customerID = c.customerID " +
                     "WHERE c.fullName LIKE ? OR m.plateNumber LIKE ? OR CAST(m.customerID AS VARCHAR) LIKE ? " +
                     "ORDER BY " + safeSort + " " + safeOrder;
        
        try {
            stm = connection.prepareStatement(sql);
            String keyword = "%" + (search == null ? "" : search) + "%";
            stm.setString(1, keyword);
            stm.setString(2, keyword);
            stm.setString(3, keyword);
            
            rs = stm.executeQuery();
            while (rs.next()) {
                MonthlyCard o = new MonthlyCard();
                o.setCardID(rs.getInt("cardID"));
                o.setCustomerID(rs.getString("customerID"));
                o.setCustomerName(rs.getString("fullName"));
                
                // Gán trực tiếp plateNumber từ bảng MonthlyCard
                String plate = rs.getString("plateNumber");
                o.setPlateNumber(plate); 
                o.setVehicleID(plate); // Gán luôn vào vehicleID để tương thích ngược với code cũ trên JSP
                
                o.setStartDate(rs.getString("startDate"));
                o.setEndDate(rs.getString("endDate"));
                o.setStatus(rs.getString("status"));
                result.add(o);
            }
        } catch (SQLException e) {
            System.out.println("Error SELECT: " + e.getMessage());
        }
        return result;
    }

    public void updateMonthlyCard(MonthlyCard o) {
        // Cập nhật câu lệnh UPDATE khớp với Database
        String sql = "UPDATE MonthlyCard SET customerID = ?, plateNumber = ?, startDate = ?, endDate = ?, status = ? WHERE cardID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getCustomerID());
            stm.setString(2, o.getVehicleID()); // Form gửi lên vehicleID nhưng thực chất là biển số
            stm.setString(3, o.getStartDate());
            stm.setString(4, o.getEndDate());
            stm.setString(5, o.getStatus());
            stm.setInt(6, o.getCardID());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error UPDATE: " + e.getMessage());
        }
    }

    public void deleteMonthlyCard(int id) {
        String sql = "DELETE FROM MonthlyCard WHERE cardID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error DELETE: " + e.getMessage());
        }
    }
}