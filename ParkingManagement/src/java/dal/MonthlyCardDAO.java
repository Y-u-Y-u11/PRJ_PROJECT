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

    public ArrayList<MonthlyCard> readMonthlyCards() {
        ArrayList<MonthlyCard> result = new ArrayList<>();
        String sql = "select * from MonthlyCard";
        try {
            stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                MonthlyCard o = new MonthlyCard();
                o.setCardID(rs.getInt("cardID"));
                o.setCustomerID(rs.getString("customerID"));
                o.setVehicleID(rs.getString("vehicleID"));
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
