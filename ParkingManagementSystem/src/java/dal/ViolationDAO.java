package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Violation;

public class ViolationDAO extends DBContext {

    public List<Violation> getAll(String keyword) {
        List<Violation> list = new ArrayList<>();
        String sql = "SELECT * FROM Violation v";
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        
        if (hasKeyword) {
            sql += " WHERE v.reason LIKE ?";
        }
        sql += " ORDER BY v.createdAt DESC";
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (hasKeyword) {
                ps.setString(1, "%" + keyword + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<Violation> getByCustomerOrTicket(Integer customerID, Integer ticketID) {
        List<Violation> list = new ArrayList<>();
        String sql = "SELECT * FROM Violation WHERE (customerID = ? OR ticketID = ?) ORDER BY createdAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (customerID != null) ps.setInt(1, customerID); else ps.setNull(1, java.sql.Types.INTEGER);
            if (ticketID != null) ps.setInt(2, ticketID); else ps.setNull(2, java.sql.Types.INTEGER);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Violation getById(int id) {
        String sql = "SELECT * FROM Violation WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean create(Violation v) {
        String sql = "INSERT INTO Violation (ticketID, customerID, reason, fine, status) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (v.getTicketID() != null) ps.setInt(1, v.getTicketID());
            else ps.setNull(1, java.sql.Types.INTEGER);
            
            if (v.getCustomerID() != null) ps.setInt(2, v.getCustomerID());
            else ps.setNull(2, java.sql.Types.INTEGER);
            
            ps.setString(3, v.getReason());
            ps.setBigDecimal(4, v.getFine());
            ps.setString(5, v.getStatus() != null ? v.getStatus() : "Unpaid");
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE Violation SET status = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Violation mapRow(ResultSet rs) throws SQLException {
        Violation v = new Violation();
        v.setId(rs.getInt("id"));
        
        int ticketID = rs.getInt("ticketID");
        if (!rs.wasNull()) v.setTicketID(ticketID);
        
        int customerID = rs.getInt("customerID");
        if (!rs.wasNull()) v.setCustomerID(customerID);
        
        v.setReason(rs.getString("reason"));
        v.setFine(rs.getBigDecimal("fine"));
        v.setStatus(rs.getString("status"));
        v.setCreatedAt(rs.getTimestamp("createdAt"));
        return v;
    }
}
