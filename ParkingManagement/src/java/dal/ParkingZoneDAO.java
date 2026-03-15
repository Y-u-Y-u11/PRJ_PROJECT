package dal;

import java.util.ArrayList;
import models.ParkingZone;
import java.sql.*;

/**
 * Data Access Object for ParkingZone.
 */
public class ParkingZoneDAO extends DBContext {

    private PreparedStatement stm;
    private ResultSet rs;

    public void createParkingZone(ParkingZone o) {
        String sql = "insert into ParkingZone (zoneName) values (?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getZoneName());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public ArrayList<ParkingZone> readParkingZones() {
        ArrayList<ParkingZone> result = new ArrayList<>();
        String sql = "select * from ParkingZone";
        try {
            stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                ParkingZone o = new ParkingZone();
                o.setZoneID(rs.getInt("zoneID"));
                o.setZoneName(rs.getString("zoneName"));
                result.add(o);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return result;
    }

    public void updateParkingZone(ParkingZone o) {
        String sql = "update ParkingZone set zoneName = ? where zoneID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getZoneName());
            stm.setInt(2, o.getZoneID());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteParkingZone(int id) {
        String sql = "delete from ParkingZone where zoneID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
