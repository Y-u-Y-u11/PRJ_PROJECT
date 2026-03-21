package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ParkingSlot;

public class ParkingSlotDAO extends DBContext {

    public List<ParkingSlot> getAll() {
        List<ParkingSlot> list = new ArrayList<>();
        String sql = "SELECT * FROM ParkingSlot";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new ParkingSlot(rs.getInt("id"), rs.getString("code")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public ParkingSlot getById(int id) {
        String sql = "SELECT * FROM ParkingSlot WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new ParkingSlot(rs.getInt("id"), rs.getString("code"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Thống kê slot khả dụng (không có vé Parking nào đang dùng slot này)
    public List<ParkingSlot> getAvailableSlots() {
        List<ParkingSlot> list = new ArrayList<>();
        String sql = "SELECT * FROM ParkingSlot ps WHERE NOT EXISTS ("
                   + "  SELECT 1 FROM ParkingTicket pt WHERE pt.slotID = ps.id AND pt.status = 'Parking'"
                   + ")";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new ParkingSlot(rs.getInt("id"), rs.getString("code")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Thống kê slot đang bị chiếm
    public List<ParkingSlot> getOccupiedSlots() {
        List<ParkingSlot> list = new ArrayList<>();
        String sql = "SELECT * FROM ParkingSlot ps WHERE EXISTS ("
                   + "  SELECT 1 FROM ParkingTicket pt WHERE pt.slotID = ps.id AND pt.status = 'Parking'"
                   + ")";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new ParkingSlot(rs.getInt("id"), rs.getString("code")));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean create(ParkingSlot slot) {
        String sql = "INSERT INTO ParkingSlot (code) VALUES (?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, slot.getCode());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(ParkingSlot slot) {
        String sql = "UPDATE ParkingSlot SET code = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, slot.getCode());
            ps.setInt(2, slot.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        // Check if occupied
        String checkSql = "SELECT 1 FROM ParkingTicket WHERE slotID = ? AND status = 'Parking'";
        try (PreparedStatement psCheck = connection.prepareStatement(checkSql)) {
            psCheck.setInt(1, id);
            try (ResultSet rs = psCheck.executeQuery()) {
                if (rs.next()) {
                    return false; // Slot is occupied, cannot delete
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        // Nullify references in ParkingTicket (historical tickets)
        String updateSql = "UPDATE ParkingTicket SET slotID = NULL WHERE slotID = ?";
        // Delete from ParkingSlot
        String deleteSql = "DELETE FROM ParkingSlot WHERE id = ?";
        
        try {
            connection.setAutoCommit(false);
            try (PreparedStatement psUpdate = connection.prepareStatement(updateSql)) {
                psUpdate.setInt(1, id);
                psUpdate.executeUpdate();
            }
            try (PreparedStatement psDelete = connection.prepareStatement(deleteSql)) {
                psDelete.setInt(1, id);
                int affectedRows = psDelete.executeUpdate();
                connection.commit();
                return affectedRows > 0;
            }
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }
}
