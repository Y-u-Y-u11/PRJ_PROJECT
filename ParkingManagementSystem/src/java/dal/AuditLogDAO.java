package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.AuditLog;

public class AuditLogDAO extends DBContext {

    public List<AuditLog> getAll() {
        List<AuditLog> list = new ArrayList<>();
        String sql = "SELECT * FROM AuditLog ORDER BY createdAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean create(AuditLog log) {
        String sql = "INSERT INTO AuditLog (staffID, actionType, tableName, recordID, columnName, oldValue, newValue, reason) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, log.getStaffID());
            ps.setString(2, log.getActionType());
            ps.setString(3, log.getTableName());
            ps.setInt(4, log.getRecordID());
            ps.setString(5, log.getColumnName());
            ps.setString(6, log.getOldValue());
            ps.setString(7, log.getNewValue());
            ps.setString(8, log.getReason());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private AuditLog mapRow(ResultSet rs) throws SQLException {
        AuditLog al = new AuditLog();
        al.setId(rs.getInt("id"));
        al.setStaffID(rs.getInt("staffID"));
        al.setActionType(rs.getString("actionType"));
        al.setTableName(rs.getString("tableName"));
        al.setRecordID(rs.getInt("recordID"));
        al.setColumnName(rs.getString("columnName"));
        al.setOldValue(rs.getString("oldValue"));
        al.setNewValue(rs.getString("newValue"));
        al.setReason(rs.getString("reason"));
        al.setCreatedAt(rs.getTimestamp("createdAt"));
        return al;
    }
}
