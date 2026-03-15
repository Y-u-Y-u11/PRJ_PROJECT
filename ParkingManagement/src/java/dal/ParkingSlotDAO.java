package dal;

import java.sql.*;
import java.util.ArrayList;
import models.ParkingSlot;

/**
 * Data Access Object for ParkingSlot.
 */
public class ParkingSlotDAO extends DBContext {

    private PreparedStatement stm;
    private ResultSet rs;

    public void createParkingSlot(ParkingSlot o) {
        String sql = "insert into ParkingSlot (slotCode, zoneID, status) values (?, ?, ?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getSlotCode());
            stm.setString(2, o.getZoneID());
            stm.setString(3, o.getStatus());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public ArrayList<ParkingSlot> readParkingSlots() {
        ArrayList<ParkingSlot> result = new ArrayList<>();
        String sql = "select * from ParkingSlot";
        try {
            stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                ParkingSlot o = new ParkingSlot();
                o.setSlotID(rs.getInt("slotID"));
                o.setSlotCode(rs.getString("slotCode"));
                o.setZoneID(rs.getString("zoneID"));
                o.setStatus(rs.getString("status"));
                result.add(o);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return result;
    }

    public void updateParkingSlot(ParkingSlot o) {
        String sql = "update ParkingSlot set slotCode = ?, zoneID = ?, status = ? where slotID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getSlotCode());
            stm.setString(2, o.getZoneID());
            stm.setString(3, o.getStatus());
            stm.setInt(4, o.getSlotID());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteParkingSlot(int id) {
        String sql = "delete from ParkingSlot where slotID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
