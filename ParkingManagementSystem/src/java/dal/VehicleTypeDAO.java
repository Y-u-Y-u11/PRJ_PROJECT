package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.VehicleType;

public class VehicleTypeDAO extends DBContext {

    public List<VehicleType> getAll() {
        List<VehicleType> list = new ArrayList<>();
        String sql = "SELECT * FROM VehicleType";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new VehicleType(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getBigDecimal("currentPrice"),
                        rs.getBoolean("requiresPlate")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public VehicleType getById(int id) {
        String sql = "SELECT * FROM VehicleType WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new VehicleType(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getBigDecimal("currentPrice"),
                        rs.getBoolean("requiresPlate")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean create(VehicleType type) {
        String sql = "INSERT INTO VehicleType (name, currentPrice, requiresPlate) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, type.getName());
            ps.setBigDecimal(2, type.getCurrentPrice());
            ps.setBoolean(3, type.isRequiresPlate());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(VehicleType type) {
        String sql = "UPDATE VehicleType SET name = ?, currentPrice = ?, requiresPlate = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, type.getName());
            ps.setBigDecimal(2, type.getCurrentPrice());
            ps.setBoolean(3, type.isRequiresPlate());
            ps.setInt(4, type.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        // Check for active tickets/cards
        String checkSql = "SELECT 1 FROM ParkingTicket WHERE typeID = ? AND status = 'Parking'";
        String checkCardSql = "SELECT 1 FROM MonthlyCard WHERE vehicleTypeID = ? AND status = 'active'";
        
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

        // Nullify references (historical)
        String up1 = "UPDATE ParkingTicket SET typeID = NULL WHERE typeID = ?";
        String up2 = "UPDATE MonthlyCard SET vehicleTypeID = NULL WHERE vehicleTypeID = ?";
        String del = "DELETE FROM VehicleType WHERE id = ?";

        try {
            connection.setAutoCommit(false);
            try (PreparedStatement p1 = connection.prepareStatement(up1);
                 PreparedStatement p2 = connection.prepareStatement(up2);
                 PreparedStatement d = connection.prepareStatement(del)) {
                p1.setInt(1, id); p1.executeUpdate();
                p2.setInt(1, id); p2.executeUpdate();
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
