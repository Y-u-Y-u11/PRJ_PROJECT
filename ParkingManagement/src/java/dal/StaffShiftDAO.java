package dal;

import java.util.ArrayList;
import models.StaffShift;
import java.sql.*;

/**
 * Data Access Object for StaffShift.
 */
public class StaffShiftDAO extends DBContext {

    private PreparedStatement stm;
    private ResultSet rs;

    public void createStaffShift(StaffShift o) {
        String sql = "insert into StaffShift (userID, shiftID, workDate) values (?, ?, ?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getUserID());
            stm.setString(2, o.getShiftID());
            stm.setString(3, o.getWorkDate());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public ArrayList<StaffShift> readStaffShifts() {
        ArrayList<StaffShift> result = new ArrayList<>();
        String sql = "select * from StaffShift";
        try {
            stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                StaffShift o = new StaffShift();
                o.setId(rs.getInt("id"));
                o.setUserID(rs.getString("userID"));
                o.setShiftID(rs.getString("shiftID"));
                o.setWorkDate(rs.getString("workDate"));
                result.add(o);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return result;
    }

    public void updateStaffShift(StaffShift o) {
        String sql = "update StaffShift set userID = ?, shiftID = ?, workDate = ? where id = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getUserID());
            stm.setString(2, o.getShiftID());
            stm.setString(3, o.getWorkDate());
            stm.setInt(4, o.getId());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteStaffShift(int id) {
        String sql = "delete from StaffShift where id = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
