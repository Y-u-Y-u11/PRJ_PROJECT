package dal;

import java.util.ArrayList;
import models.Shift;
import java.sql.*;

/**
 * Data Access Object for Shift.
 */
public class ShiftDAO extends DBContext {

    private PreparedStatement stm;
    private ResultSet rs;

    public void createShift(Shift o) {
        String sql = "insert into Shift (shiftName, startTime, endTime) values (?, ?, ?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getShiftName());
            stm.setString(2, o.getStartTime());
            stm.setTime(3, o.getEndTime());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public ArrayList<Shift> readShifts() {
        ArrayList<Shift> result = new ArrayList<>();
        String sql = "select * from Shift";
        try {
            stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Shift o = new Shift();
                o.setShiftID(rs.getInt("shiftID"));
                o.setShiftName(rs.getString("shiftName"));
                o.setStartTime(rs.getString("startTime"));
                o.setEndTime(rs.getTime("endTime"));
                result.add(o);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return result;
    }

    public void updateShift(Shift o) {
        String sql = "update Shift set shiftName = ?, startTime = ?, endTime = ? where shiftID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getShiftName());
            stm.setString(2, o.getStartTime());
            stm.setTime(3, o.getEndTime());
            stm.setInt(4, o.getShiftID());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteShift(int id) {
        String sql = "delete from Shift where shiftID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
