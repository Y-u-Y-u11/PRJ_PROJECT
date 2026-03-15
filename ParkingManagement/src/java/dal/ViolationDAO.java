package dal;

import java.util.ArrayList;
import models.Violation;
import java.sql.*;

/**
 * Data Access Object for Violation.
 */
public class ViolationDAO extends DBContext {

    private PreparedStatement stm;
    private ResultSet rs;

    public void createViolation(Violation o) {
        String sql = "insert into Violation (ticketID, reason, fineAmount) values (?, ?, ?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getTicketID());
            stm.setString(2, o.getReason());
            stm.setDouble(3, o.getFineAmount());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public ArrayList<Violation> readViolations() {
        ArrayList<Violation> result = new ArrayList<>();
        String sql = "select * from Violation";
        try {
            stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Violation o = new Violation();
                o.setViolationID(rs.getInt("violationID"));
                o.setTicketID(rs.getString("ticketID"));
                o.setReason(rs.getString("reason"));
                o.setFineAmount(rs.getDouble("fineAmount"));
                result.add(o);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return result;
    }

    public void updateViolation(Violation o) {
        String sql = "update Violation set ticketID = ?, reason = ?, fineAmount = ? where violationID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getTicketID());
            stm.setString(2, o.getReason());
            stm.setDouble(3, o.getFineAmount());
            stm.setInt(4, o.getViolationID());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteViolation(int id) {
        String sql = "delete from Violation where violationID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
