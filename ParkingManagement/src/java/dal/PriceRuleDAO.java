package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.PriceRule;

/**
 * Data Access Object for PriceRule.
 */
public class PriceRuleDAO extends DBContext {
    private PreparedStatement stm;
    private ResultSet rs;

    /**
     * Gets the appropriate price based on vehicle type and duration.
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
}
