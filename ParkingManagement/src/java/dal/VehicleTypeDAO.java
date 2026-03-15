package dal;

import java.util.ArrayList;
import models.VehicleType;
import java.sql.*;

/**
 * Data Access Object for VehicleType.
 */
public class VehicleTypeDAO extends DBContext {
    private PreparedStatement stm;
    private ResultSet rs;


    public void createVehicleType(VehicleType o) {
        String sql = "insert into VehicleType (typeName, basePrice) values (?, ?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getTypeName());
            stm.setDouble(2, o.getBasePrice());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public ArrayList<VehicleType> readVehicleTypes() {
        ArrayList<VehicleType> result = new ArrayList<>();
        String sql = "select * from VehicleType";
        try {
            stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                VehicleType o = new VehicleType();
                o.setTypeID(rs.getInt("typeID"));
                o.setTypeName(rs.getString("typeName"));
                o.setBasePrice(rs.getDouble("basePrice"));
                result.add(o);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return result;
    }

    public void updateVehicleType(VehicleType o) {
        String sql = "update VehicleType set typeName = ?, basePrice = ? where typeID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getTypeName());
            stm.setDouble(2, o.getBasePrice());
            stm.setInt(3, o.getTypeID());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteVehicleType(int id) {
        String sql = "delete from VehicleType where typeID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
