package dal;

import java.util.ArrayList;
import model.MonthlyCard;
import java.sql.*;

public class MonthlyCardDAO extends DBContext {

    public boolean createMonthlyCard(MonthlyCard o) {
        String sql = "INSERT INTO MonthlyCard (customerID, vehicleTypeID, plateNumber, startDate, endDate, price, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, o.getCustomerID());
            stm.setInt(2, o.getVehicleTypeID());
            stm.setString(3, o.getPlateNumber());
            stm.setString(4, o.getStartDate());
            stm.setString(5, o.getEndDate());
            stm.setBigDecimal(6, o.getPrice());
            stm.setString(7, o.getStatus());
            return stm.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error Insert: " + e.getMessage());
            return false;
        }
    }

    public ArrayList<MonthlyCard> getCardsWithSearchAndSort(String search, String sort, String order) {
        ArrayList<MonthlyCard> result = new ArrayList<>();

        String safeSort = "m.cardID"; // Default
        if (sort != null) {
            switch (sort) {
                case "customerName":
                    safeSort = "c.name";
                    break;
                case "plateNumber":
                    safeSort = "m.plateNumber";
                    break;
                case "vehicleType":
                    safeSort = "v.name";
                    break;
                case "startDate":
                    safeSort = "m.startDate";
                    break;
                case "endDate":
                    safeSort = "m.endDate";
                    break;
                case "status":
                    safeSort = "m.status";
                    break;
                default:
                    safeSort = "m.cardID";
                    break;
            }
        }

        String safeOrder = "desc".equalsIgnoreCase(order) ? "DESC" : "ASC";

        String sql = "SELECT m.cardID, m.customerID, c.name AS customerName, m.vehicleTypeID, v.name AS vehicleTypeName, "
                + "m.plateNumber, m.startDate, m.endDate, m.price, m.status "
                + "FROM MonthlyCard m "
                + "LEFT JOIN Customer c ON m.customerID = c.id "
                + "LEFT JOIN VehicleType v ON m.vehicleTypeID = v.id "
                + "WHERE c.name LIKE ? OR m.plateNumber LIKE ? OR CAST(m.cardID AS VARCHAR) LIKE ? "
                + "ORDER BY " + safeSort + " " + safeOrder;

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            String keyword = "%" + (search == null ? "" : search) + "%";
            stm.setString(1, keyword);
            stm.setString(2, keyword);
            stm.setString(3, keyword);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    MonthlyCard o = new MonthlyCard();
                    o.setCardID(rs.getInt("cardID"));
                    o.setCustomerID(rs.getInt("customerID"));
                    o.setCustomerName(rs.getString("customerName"));
                    o.setVehicleTypeID(rs.getInt("vehicleTypeID"));
                    o.setVehicleTypeName(rs.getString("vehicleTypeName"));
                    o.setPlateNumber(rs.getString("plateNumber"));
                    o.setStartDate(rs.getString("startDate"));
                    o.setEndDate(rs.getString("endDate"));
                    o.setPrice(rs.getBigDecimal("price"));
                    o.setStatus(rs.getString("status"));
                    result.add(o);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error SELECT: " + e.getMessage());
        }
        return result;
    }

    public boolean updateMonthlyCard(MonthlyCard o) {
        String sql = "UPDATE MonthlyCard SET customerID = ?, vehicleTypeID = ?, plateNumber = ?, startDate = ?, endDate = ?, price = ?, status = ? WHERE cardID = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, o.getCustomerID());
            stm.setInt(2, o.getVehicleTypeID());
            stm.setString(3, o.getPlateNumber());
            stm.setString(4, o.getStartDate());
            stm.setString(5, o.getEndDate());
            stm.setBigDecimal(6, o.getPrice());
            stm.setString(7, o.getStatus());
            stm.setInt(8, o.getCardID());
            return stm.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error UPDATE: " + e.getMessage());
            return false;
        }
    }

    public MonthlyCard getById(int id) {
        String sql = "SELECT m.*, c.name AS customerName, v.name AS vehicleTypeName FROM MonthlyCard m " +
                     "LEFT JOIN Customer c ON m.customerID = c.id " +
                     "LEFT JOIN VehicleType v ON m.vehicleTypeID = v.id WHERE m.cardID = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    MonthlyCard o = new MonthlyCard();
                    o.setCardID(rs.getInt("cardID"));
                    o.setCustomerID(rs.getInt("customerID"));
                    o.setCustomerName(rs.getString("customerName"));
                    o.setVehicleTypeID(rs.getInt("vehicleTypeID"));
                    o.setVehicleTypeName(rs.getString("vehicleTypeName"));
                    o.setPlateNumber(rs.getString("plateNumber"));
                    o.setStartDate(rs.getString("startDate"));
                    o.setEndDate(rs.getString("endDate"));
                    o.setPrice(rs.getBigDecimal("price"));
                    o.setStatus(rs.getString("status"));
                    return o;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getById: " + e.getMessage());
        }
        return null;
    }

    public MonthlyCard getActiveCardByPlate(String plateNumber) {
        // Query only active cards that have not expired yet
        String sql = "SELECT * FROM MonthlyCard WHERE plateNumber = ? AND status = 'Active' AND endDate >= CAST(GETDATE() AS DATE)";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setString(1, plateNumber);
            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    MonthlyCard o = new MonthlyCard();
                    o.setCardID(rs.getInt("cardID"));
                    o.setCustomerID(rs.getInt("customerID"));
                    o.setVehicleTypeID(rs.getInt("vehicleTypeID"));
                    o.setPlateNumber(rs.getString("plateNumber"));
                    o.setStartDate(rs.getString("startDate"));
                    o.setEndDate(rs.getString("endDate"));
                    o.setPrice(rs.getBigDecimal("price"));
                    o.setStatus(rs.getString("status"));
                    return o;
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getActiveCard: " + e.getMessage());
        }
        return null;
    }

    public boolean deleteMonthlyCard(int id) {
        String updateTicketSql = "UPDATE ParkingTicket SET monthlyCardID = NULL WHERE monthlyCardID = ?";
        String deleteCardSql = "DELETE FROM MonthlyCard WHERE cardID = ?";
        boolean isDeleted = false;

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement stmUpdate = connection.prepareStatement(updateTicketSql)) {
                stmUpdate.setInt(1, id);
                stmUpdate.executeUpdate();
            }

            try (PreparedStatement stmDelete = connection.prepareStatement(deleteCardSql)) {
                stmDelete.setInt(1, id);
                isDeleted = stmDelete.executeUpdate() > 0;
            }

            connection.commit();
        } catch (SQLException e) {
            System.out.println("Error HARD DELETE: " + e.getMessage());
            try {
                connection.rollback();
            } catch (SQLException ex) {
                System.out.println("Error Rollback: " + ex.getMessage());
            }
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                System.out.println("Error Reset AutoCommit: " + ex.getMessage());
            }
        }

        return isDeleted;
    }
}
