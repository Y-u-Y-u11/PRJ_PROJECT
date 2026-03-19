package dal;

import java.util.ArrayList;
import models.MonthlyCard;
import java.sql.*;

/**
 * Data Access Object for MonthlyCard.
 */
public class MonthlyCardDAO extends DBContext {

    private PreparedStatement stm;
    private ResultSet rs;

    public void createMonthlyCard(MonthlyCard o) {
        String sql = "insert into MonthlyCard (customerID, vehicleID, startDate, endDate, status) values (?, ?, ?, ?, ?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getCustomerID());
            stm.setString(2, o.getVehicleID());
            stm.setString(3, o.getStartDate());
            stm.setString(4, o.getEndDate());
            stm.setString(5, o.getStatus());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    // Đã cập nhật câu lệnh JOIN để lấy Tên Khách Hàng và Biển Số Xe thực tế
    public ArrayList<MonthlyCard> getCardsWithSearchAndSort(String search, String sort, String order) {
        ArrayList<MonthlyCard> result = new ArrayList<>();
        
        // 1. Validate and Sanitize Sort Column to prevent SQL Injection
        String safeSort = "m.cardID"; // Default
        if (sort != null) {
            switch (sort) {
                case "customerID": safeSort = "m.customerID"; break;
                case "customerName": safeSort = "c.fullName"; break;
                case "plateNumber": safeSort = "v.plateNumber"; break;
                case "startDate": safeSort = "m.startDate"; break;
                case "endDate": safeSort = "m.endDate"; break;
                case "status": safeSort = "m.status"; break;
                default: safeSort = "m.cardID"; break;
            }
        }
        
        // 2. Validate Order
        String safeOrder = "desc".equalsIgnoreCase(order) ? "DESC" : "ASC";
        
        // 3. Build SQL query with JOIN
        String sql = "SELECT m.cardID, m.customerID, c.fullName, m.vehicleID, v.plateNumber, m.startDate, m.endDate, m.status " +
                     "FROM MonthlyCard m " +
                     "LEFT JOIN Customer c ON m.customerID = c.customerID " +
                     "LEFT JOIN Vehicle v ON m.vehicleID = v.vehicleID " +
                     "WHERE c.fullName LIKE ? OR v.plateNumber LIKE ? OR CAST(m.customerID AS VARCHAR) LIKE ? " +
                     "ORDER BY " + safeSort + " " + safeOrder;
        
        try {
            stm = connection.prepareStatement(sql);
            String keyword = "%" + (search == null ? "" : search) + "%";
            stm.setString(1, keyword);
            stm.setString(2, keyword);
            stm.setString(3, keyword); // Cho phép tìm theo cả ID Khách hàng
            
            rs = stm.executeQuery();
            while (rs.next()) {
                MonthlyCard o = new MonthlyCard();
                o.setCardID(rs.getInt("cardID"));
                o.setCustomerID(rs.getString("customerID"));
                o.setCustomerName(rs.getString("fullName")); // Mapping tên từ JOIN
                o.setVehicleID(rs.getString("vehicleID"));
                o.setPlateNumber(rs.getString("plateNumber")); // Mapping biển số từ JOIN
                o.setStartDate(rs.getString("startDate"));
                o.setEndDate(rs.getString("endDate"));
                o.setStatus(rs.getString("status"));
                result.add(o);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return result;
    }

    public void updateMonthlyCard(MonthlyCard o) {
        String sql = "update MonthlyCard set customerID = ?, vehicleID = ?, startDate = ?, endDate = ?, status = ? where cardID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getCustomerID());
            stm.setString(2, o.getVehicleID());
            stm.setString(3, o.getStartDate());
            stm.setString(4, o.getEndDate());
            stm.setString(5, o.getStatus());
            stm.setInt(6, o.getCardID());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteMonthlyCard(int id) {
        String sql = "delete from MonthlyCard where cardID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}