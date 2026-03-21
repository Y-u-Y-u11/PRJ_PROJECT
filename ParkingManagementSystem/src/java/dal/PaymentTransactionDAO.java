package dal;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.PaymentTransaction;

public class PaymentTransactionDAO extends DBContext {

    public List<PaymentTransaction> getByTicketId(int ticketID) {
        List<PaymentTransaction> list = new ArrayList<>();
        String sql = "SELECT * FROM PaymentTransaction WHERE ticketID = ? ORDER BY paidAt DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, ticketID);
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
    
    public List<PaymentTransaction> getAll() {
        List<PaymentTransaction> list = new ArrayList<>();
        String sql = "SELECT * FROM PaymentTransaction ORDER BY paidAt DESC";
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
    
    public BigDecimal getTotalAmount(int ticketID) {
        String sql = "SELECT SUM(amount) FROM PaymentTransaction WHERE ticketID = ? AND status = 'Success'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, ticketID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BigDecimal total = rs.getBigDecimal(1);
                    return total != null ? total : BigDecimal.ZERO;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public boolean create(PaymentTransaction pt) {
        String sql = "INSERT INTO PaymentTransaction (ticketID, amount, method, status, referenceCode) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            // Xử lý an toàn cho trường hợp ticketID bị null
            if (pt.getTicketID() != null) {
                ps.setInt(1, pt.getTicketID());
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            
            ps.setBigDecimal(2, pt.getAmount());
            ps.setString(3, pt.getMethod());
            ps.setString(4, pt.getStatus());
            ps.setString(5, pt.getReferenceCode());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int id, String status) {
        String sql = "UPDATE PaymentTransaction SET status = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private PaymentTransaction mapRow(ResultSet rs) throws SQLException {
        int tId = rs.getInt("ticketID");
        Integer ticketID = rs.wasNull() ? null : tId; // Ánh xạ an toàn Integer null
        
        return new PaymentTransaction(
            rs.getInt("id"),
            ticketID,
            rs.getBigDecimal("amount"),
            rs.getString("method"),
            rs.getString("status"),
            rs.getString("referenceCode"),
            rs.getTimestamp("paidAt")
        );
    }
}