package dal;

import java.util.ArrayList;
import models.AuditLog;
import java.sql.*;

/**
 * Data Access Object for AuditLog.
 */
public class AuditLogDAO extends DBContext {

    private PreparedStatement stm;
    private ResultSet rs;

    public void createAuditLog(AuditLog o) {
        String sql = "insert into AuditLog (userID, action, actionTime) values (?, ?, ?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getUserID());
            stm.setString(2, o.getAction());
            stm.setTimestamp(3, o.getActionTime());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public ArrayList<AuditLog> readAuditLogs() {
        ArrayList<AuditLog> result = new ArrayList<>();
        String sql = "select * from AuditLog";
        try {
            stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                AuditLog o = new AuditLog();
                o.setLogID(rs.getInt("logID"));
                o.setUserID(rs.getString("userID"));
                o.setAction(rs.getString("action"));
                o.setActionTime(rs.getTimestamp("actionTime"));
                result.add(o);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return result;
    }

    public void updateAuditLog(AuditLog o) {
        String sql = "update AuditLog set userID = ?, action = ?, actionTime = ? where logID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getUserID());
            stm.setString(2, o.getAction());
            stm.setTimestamp(3, o.getActionTime());
            stm.setInt(4, o.getLogID());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteAuditLog(int id) {
        String sql = "delete from AuditLog where logID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
