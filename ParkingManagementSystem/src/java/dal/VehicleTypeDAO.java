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
}
