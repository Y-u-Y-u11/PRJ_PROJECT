package dal;

import java.util.ArrayList;
import models.VehicleHistory;
import java.sql.*;

/**
 * Data Access Object for VehicleHistory.
 */
public class VehicleHistoryDAO extends DBContext {

    private PreparedStatement stm;
    private ResultSet rs;

    public void createVehicleHistory(VehicleHistory o) {
        String sql = "insert into VehicleHistory (vehicleID, ticketID, slotID, checkInTime, checkOutTime) values (?, ?, ?, ?, ?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getVehicleID());
            stm.setString(2, o.getTicketID());
            stm.setString(3, o.getSlotID());
            stm.setString(4, o.getCheckInTime());
            stm.setString(5, o.getCheckOutTime());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public ArrayList<VehicleHistory> readVehicleHistorys() {
        ArrayList<VehicleHistory> result = new ArrayList<>();
        String sql = "select * from VehicleHistory";
        try {
            stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                VehicleHistory o = new VehicleHistory();
                o.setHistoryID(rs.getInt("historyID"));
                o.setVehicleID(rs.getString("vehicleID"));
                o.setTicketID(rs.getString("ticketID"));
                o.setSlotID(rs.getString("slotID"));
                o.setCheckInTime(rs.getString("checkInTime"));
                o.setCheckOutTime(rs.getString("checkOutTime"));
                result.add(o);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return result;
    }

    public void updateVehicleHistory(VehicleHistory o) {
        String sql = "update VehicleHistory set vehicleID = ?, ticketID = ?, slotID = ?, checkInTime = ?, checkOutTime = ? where historyID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getVehicleID());
            stm.setString(2, o.getTicketID());
            stm.setString(3, o.getSlotID());
            stm.setString(4, o.getCheckInTime());
            stm.setString(5, o.getCheckOutTime());
            stm.setInt(6, o.getHistoryID());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteVehicleHistory(int id) {
        String sql = "delete from VehicleHistory where historyID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
