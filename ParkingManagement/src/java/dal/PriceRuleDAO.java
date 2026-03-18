package dal;

import java.sql.*;
import java.util.ArrayList;
import models.PriceRule;

public class PriceRuleDAO extends DBContext {

    private PreparedStatement stm;
    private ResultSet rs;

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
            // Chuyển đổi String từ Controller sang int để khớp với Database
            stm.setInt(1, Integer.parseInt(o.getTypeID()));
            stm.setInt(2, Integer.parseInt(o.getStartHour()));
            stm.setInt(3, Integer.parseInt(o.getEndHour()));
            stm.setDouble(4, o.getPrice());
            stm.executeUpdate();
        } catch (SQLException | NumberFormatException e) {
            System.out.println("Lỗi createPriceRule: " + e);
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
                o.setTypeID(rs.getString("typeID")); // Vẫn set String cho Object
                o.setStartHour(rs.getString("startHour")); 
                o.setEndHour(rs.getString("endHour"));
                o.setPrice(rs.getDouble("price"));
                result.add(o);
            }
        } catch (SQLException e) {
            System.out.println("Lỗi readPriceRules: " + e);
        }
        return result;
    }

    public void updatePriceRule(PriceRule o) {
        String sql = "update PriceRule set typeID = ?, startHour = ?, endHour = ?, price = ? where ruleID = ?";
        try {
            stm = connection.prepareStatement(sql);
            // Chuyển đổi String từ Controller sang int để khớp với Database
            stm.setInt(1, Integer.parseInt(o.getTypeID()));
            stm.setInt(2, Integer.parseInt(o.getStartHour()));
            stm.setInt(3, Integer.parseInt(o.getEndHour()));
            stm.setDouble(4, o.getPrice());
            stm.setInt(5, o.getRuleID());
            stm.executeUpdate();
        } catch (SQLException | NumberFormatException e) {
            System.out.println("Lỗi updatePriceRule: " + e);
        }
    }

    public void deletePriceRule(int id) {
        String sql = "delete from PriceRule where ruleID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Lỗi deletePriceRule: " + e);
        }
    }
}