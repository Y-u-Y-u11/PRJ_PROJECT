package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Customer;

public class CustomerDAO extends DBContext {

    public List<Customer> getAll(String keyword) {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM Customer";
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        if (hasKeyword) {
            sql += " WHERE name LIKE ? OR phone LIKE ?";
        }
        
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            if (hasKeyword) {
                ps.setString(1, "%" + keyword + "%");
                ps.setString(2, "%" + keyword + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Customer(rs.getInt("id"), rs.getString("name"), rs.getString("phone")));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Customer getById(int id) {
        String sql = "SELECT * FROM Customer WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Customer(rs.getInt("id"), rs.getString("name"), rs.getString("phone"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean create(Customer customer) {
        String sql = "INSERT INTO Customer (name, phone) VALUES (?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, customer.getName());
            ps.setString(2, customer.getPhone());
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        customer.setId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Error in CustomerDAO.create: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Customer customer) {
        String sql = "UPDATE Customer SET name = ?, phone = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, customer.getName());
            ps.setString(2, customer.getPhone());
            ps.setInt(3, customer.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean delete(int id) {
        // Check for active tickets/cards
        String checkSql = "SELECT 1 FROM ParkingTicket WHERE customerID = ? AND status = 'Parking'";
        String checkCardSql = "SELECT 1 FROM MonthlyCard WHERE customerID = ? AND status = 'active'";
        
        try (PreparedStatement ps1 = connection.prepareStatement(checkSql);
             PreparedStatement ps2 = connection.prepareStatement(checkCardSql)) {
            ps1.setInt(1, id);
            ps2.setInt(1, id);
            try (ResultSet rs1 = ps1.executeQuery();
                 ResultSet rs2 = ps2.executeQuery()) {
                if (rs1.next() || rs2.next()) {
                    return false; // Active references exist
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        // Nullify references
        String up1 = "UPDATE ParkingTicket SET customerID = NULL WHERE customerID = ?";
        String up2 = "UPDATE MonthlyCard SET customerID = NULL WHERE customerID = ?";
        String up3 = "UPDATE Violation SET customerID = NULL WHERE customerID = ?";
        String del = "DELETE FROM Customer WHERE id = ?";

        try {
            connection.setAutoCommit(false);
            try (PreparedStatement p1 = connection.prepareStatement(up1);
                 PreparedStatement p2 = connection.prepareStatement(up2);
                 PreparedStatement p3 = connection.prepareStatement(up3);
                 PreparedStatement d = connection.prepareStatement(del)) {
                p1.setInt(1, id); p1.executeUpdate();
                p2.setInt(1, id); p2.executeUpdate();
                p3.setInt(1, id); p3.executeUpdate();
                d.setInt(1, id);
                int affected = d.executeUpdate();
                connection.commit();
                return affected > 0;
            }
        } catch (SQLException e) {
            try { connection.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }
}
