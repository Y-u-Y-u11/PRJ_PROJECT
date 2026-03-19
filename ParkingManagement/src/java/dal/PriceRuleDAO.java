package dal;

import java.sql.*;
import java.util.ArrayList;
import models.PriceRule;

/**
 * Data Access Object for PriceRule entities.
 */
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

    public void createPriceRule(PriceRule pr) {
        String sql = "insert into PriceRule (typeID, startHour, endHour, price) values (?, ?, ?, ?)";
        try {
            stm = connection.prepareStatement(sql);
            // Convert String from Controller to int to match Database
            stm.setInt(1, Integer.parseInt(pr.getTypeID()));
            stm.setInt(2, Integer.parseInt(pr.getStartHour()));
            stm.setInt(3, Integer.parseInt(pr.getEndHour()));
            stm.setDouble(4, pr.getPrice());
            stm.executeUpdate();
        } catch (SQLException | NumberFormatException e) {
            System.out.println("Error createPriceRule: " + e);
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
                o.setTypeID(rs.getString("typeID")); // Still set String for Object
                o.setStartHour(rs.getString("startHour"));
                o.setEndHour(rs.getString("endHour"));
                o.setPrice(rs.getDouble("price"));
                result.add(o);
            }
        } catch (SQLException e) {
            System.out.println("Error readPriceRules: " + e);
        }
        return result;
    }

    public PriceRule getPriceRuleById(int id) {
        String sql = "select * from PriceRule where ruleID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                PriceRule o = new PriceRule();
                o.setRuleID(rs.getInt("ruleID"));
                o.setTypeID(rs.getString("typeID"));
                o.setStartHour(rs.getString("startHour"));
                o.setEndHour(rs.getString("endHour"));
                o.setPrice(rs.getDouble("price"));
                return o;
            }
        } catch (SQLException e) {
            System.out.println("Error getPriceRuleById: " + e);
        }
        return null;
    }

    public void updatePriceRule(PriceRule o) {
        String sql = "update PriceRule set typeID = ?, startHour = ?, endHour = ?, price = ? where ruleID = ?";
        try {
            stm = connection.prepareStatement(sql);
            // Convert String from Controller to int to match Database
            stm.setInt(1, Integer.parseInt(o.getTypeID()));
            stm.setInt(2, Integer.parseInt(o.getStartHour()));
            stm.setInt(3, Integer.parseInt(o.getEndHour()));
            stm.setDouble(4, o.getPrice());
            stm.setInt(5, o.getRuleID());
            stm.executeUpdate();
        } catch (SQLException | NumberFormatException e) {
            System.out.println("Error updatePriceRule: " + e);
        }
    }

    /**
     * Checks if a new time range overlaps with any existing rule for the same type. Returns the overlapping rule if found, null otherwise.
     */
    public PriceRule getOverlapRule(String typeID, int start, int end, int excludeRuleID) {
        ArrayList<PriceRule> all = readPriceRules();
        for (PriceRule r : all) {
            if (r.getRuleID() == excludeRuleID) {
                continue;
            }
            if (r.getTypeID().equals(typeID)) {
                int rStart = Integer.parseInt(r.getStartHour());
                int rEnd = Integer.parseInt(r.getEndHour());

                // standard overlap check: (start1 < end2) AND (end1 > start2)
                if (start < rEnd && end > rStart) {
                    return r;
                }
            }
        }
        return null;
    }

    public void deletePriceRule(int id) {
        String sql = "delete from PriceRule where ruleID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error deletePriceRule: " + e);
        }
    }
}
