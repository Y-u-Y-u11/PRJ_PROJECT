package dal;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Report;

public class ReportDAO extends DBContext {

    // Example of purely fetching calculated revenue through DAO preserving MVC
    public BigDecimal calculateTotalRevenue() {
        BigDecimal total = BigDecimal.ZERO;
        String sql = "SELECT SUM(amount) FROM PaymentTransaction WHERE status = 'Success'";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                total = rs.getBigDecimal(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total != null ? total : BigDecimal.ZERO;
    }

    // Save a report snapshot to the database
    public boolean saveReport(Report report) {
        String sql = "INSERT INTO Report (reportType, totalRevenue, totalSlots, occupiedSlots) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, report.getReportType());
            if (report.getTotalRevenue() != null) {
                ps.setBigDecimal(2, report.getTotalRevenue());
            } else {
                ps.setNull(2, java.sql.Types.DECIMAL);
            }
            if (report.getTotalSlots() != null) {
                ps.setInt(3, report.getTotalSlots());
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            if (report.getOccupiedSlots() != null) {
                ps.setInt(4, report.getOccupiedSlots());
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Fetch all historical reports
    public List<Report> getAllReports() {
        List<Report> list = new ArrayList<>();
        String sql = "SELECT * FROM Report ORDER BY generatedDate DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                LocalDateTime genDate = rs.getTimestamp("generatedDate") != null ? rs.getTimestamp("generatedDate").toLocalDateTime() : null;
                BigDecimal rev = rs.getBigDecimal("totalRevenue");
                Integer ts = rs.getObject("totalSlots") != null ? rs.getInt("totalSlots") : null;
                Integer os = rs.getObject("occupiedSlots") != null ? rs.getInt("occupiedSlots") : null;
                
                list.add(new Report(
                    rs.getInt("id"),
                    rs.getString("reportType"),
                    genDate,
                    rev,
                    ts,
                    os
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
