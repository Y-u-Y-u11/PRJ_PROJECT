package dal;

import java.sql.*;
import java.util.ArrayList;
import models.PriceRule;

/**
 * Data Access Object for PriceRule.
 */
public class PriceRuleDAO extends DBContext {

    private PreparedStatement stm;
    private ResultSet rs;

    /**
     * Gets the appropriate price based on vehicle type and duration.
     *
     * @param vehicleTypeID The ID of the vehicle type
     * @param hour The number of hours parked
     * @return The price per interval according to rule
     */
    public double getPrice(int vehicleTypeID, int hour) {
        double price = 0;
        String sql = "SELECT price FROM PriceRule WHERE typeID = ? AND ? BETWEEN startHour AND endHour";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, vehicleTypeID);
            stm.setInt(2, hour);
            rs = stm.executeQuery();
            if (rs.next()) {
                price = rs.getDouble("price");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return price;
    }

    public void createPriceRule(PriceRule o) {
        String sql = "insert into PriceRule (typeID, startHour, endHour, price) values (?, ?, ?, ?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getTypeID());
            stm.setString(2, o.getStartHour());
            stm.setString(3, o.getEndHour());
            stm.setDouble(4, o.getPrice());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public ArrayList<PriceRule> readPriceRules() {
        ArrayList<PriceRule> result = new ArrayList<>();
        String sql = "select * from PriceRule";
        try {
            stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                PriceRule o = new PriceRule();
                o.setRuleID(rs.getInt("ruleID"));
                o.setTypeID(rs.getString("typeID"));
                o.setStartHour(rs.getString("startHour"));
                o.setEndHour(rs.getString("endHour"));
                o.setPrice(rs.getDouble("price"));
                result.add(o);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return result;
    }

    public void updatePriceRule(PriceRule o) {
        String sql = "update PriceRule set typeID = ?, startHour = ?, endHour = ?, price = ? where ruleID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getTypeID());
            stm.setString(2, o.getStartHour());
            stm.setString(3, o.getEndHour());
            stm.setDouble(4, o.getPrice());
            stm.setInt(5, o.getRuleID());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deletePriceRule(int id) {
        String sql = "delete from PriceRule where ruleID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
