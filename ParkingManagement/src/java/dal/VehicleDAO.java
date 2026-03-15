package dal;

import java.util.ArrayList;
import models.Vehicle;
import java.sql.*;

/**
 * Data Access Object for Vehicle.
 */
public class VehicleDAO extends DBContext {

    private PreparedStatement stm;
    private ResultSet rs;

    public void createVehicle(Vehicle o) {
        String sql = "insert into Vehicle (plateNumber, customerID, typeID, brand, color) values (?, ?, ?, ?, ?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getPlateNumber());
            stm.setString(2, o.getCustomerID());
            stm.setString(3, o.getTypeID());
            stm.setString(4, o.getBrand());
            stm.setString(5, o.getColor());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public ArrayList<Vehicle> readVehicles() {
        ArrayList<Vehicle> result = new ArrayList<>();
        String sql = "select * from Vehicle";
        try {
            stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Vehicle o = new Vehicle();
                o.setVehicleID(rs.getInt("vehicleID"));
                o.setPlateNumber(rs.getString("plateNumber"));
                o.setCustomerID(rs.getString("customerID"));
                o.setTypeID(rs.getString("typeID"));
                o.setBrand(rs.getString("brand"));
                o.setColor(rs.getString("color"));
                result.add(o);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return result;
    }

    public void updateVehicle(Vehicle o) {
        String sql = "update Vehicle set plateNumber = ?, customerID = ?, typeID = ?, brand = ?, color = ? where vehicleID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getPlateNumber());
            stm.setString(2, o.getCustomerID());
            stm.setString(3, o.getTypeID());
            stm.setString(4, o.getBrand());
            stm.setString(5, o.getColor());
            stm.setInt(6, o.getVehicleID());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteVehicle(int id) {
        String sql = "delete from Vehicle where vehicleID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
