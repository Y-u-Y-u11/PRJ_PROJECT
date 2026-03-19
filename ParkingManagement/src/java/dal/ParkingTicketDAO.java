package dal;

import java.sql.*;
import java.util.ArrayList;
import models.ParkingTicket;

/**
 * Data Access Object for ParkingTicket.
 */
public class ParkingTicketDAO extends DBContext {

    private PreparedStatement stm;
    private ResultSet rs;

    
    public ParkingTicket getActiveTicketBySlotCode(String slotCode) {
        String sql = "SELECT pt.* FROM ParkingTicket pt " +
                     "JOIN ParkingSlot ps ON pt.slotID = ps.slotID " +
                     "WHERE ps.slotCode = ? AND pt.status = 'Parking'";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, slotCode);
            rs = stm.executeQuery();
            if (rs.next()) {
                ParkingTicket t = new ParkingTicket();
                t.setTicketID(rs.getInt("ticketID"));
                t.setVehicleID(rs.getString("vehicleID"));
                t.setSlotID(rs.getString("slotID"));
                t.setCheckInTime(rs.getTimestamp("checkInTime"));
                return t;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }
    
    /**
     * Checks in a vehicle, creating a new ticket and updating slot status.
     *
     * @param vehicleID The ID of the vehicle
     * @param slotID The ID of the slot
     * @param createdBy The ID of the user creating the ticket
     */
    public void checkIn(int vehicleID, int slotID, int createdBy) {
        String insertTicket = "INSERT INTO ParkingTicket (vehicleID, slotID, createdBy, checkInTime, status) VALUES (?, ?, ?, GETDATE(), 'Parking')";
        String updateSlot = "UPDATE ParkingSlot SET status = 'Occupied' WHERE slotID = ?";
        try {
            connection.setAutoCommit(false);

            stm = connection.prepareStatement(insertTicket);
            stm.setInt(1, vehicleID);
            stm.setInt(2, slotID);
            stm.setInt(3, createdBy);
            stm.executeUpdate();
            stm.close();

            stm = connection.prepareStatement(updateSlot);
            stm.setInt(1, slotID);
            stm.executeUpdate();

            connection.commit();
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
                if (stm != null) {
                    stm.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Checks out a vehicle, calculates fixed fee, updates checkout time and slot status.
     *
     * @param ticketID The ID of the ticket to checkout
     */
    public void checkOut(int ticketID) {
        // Dùng LEFT JOIN để tránh lỗi nếu không tìm thấy vehicle tương ứng
        String getTicketSql = "SELECT pt.checkInTime, pt.slotID, v.typeID FROM ParkingTicket pt LEFT JOIN Vehicle v ON pt.vehicleID = v.vehicleID WHERE pt.ticketID = ?";
        try {
            connection.setAutoCommit(false);

            stm = connection.prepareStatement(getTicketSql);
            stm.setInt(1, ticketID);
            rs = stm.executeQuery();
            
            if (rs.next()) {
                Timestamp checkInTime = rs.getTimestamp("checkInTime");
                int slotID = rs.getInt("slotID");
                int typeID = rs.getInt("typeID");
                if (rs.wasNull()) {
                    typeID = 1; // Mặc định là xe máy nếu thiếu dữ liệu
                }

                rs.close();
                stm.close();

                // Logic tính tiền cố định
                double baseFee = 5000; // Mặc định giá xe máy
                if (typeID == 2) baseFee = 20000; // Giá ô tô
                else if (typeID == 3) baseFee = 3000; // Giá xe đạp

                // Tính số ngày chênh lệch để cộng thêm tiền (sang ngày mới)
                java.time.LocalDate inDate = checkInTime.toLocalDateTime().toLocalDate();
                java.time.LocalDate outDate = java.time.LocalDate.now();
                long extraDays = java.time.temporal.ChronoUnit.DAYS.between(inDate, outDate);
                if (extraDays < 0) extraDays = 0;

                double totalFee = baseFee + (extraDays * baseFee);

                // Cập nhật trạng thái Vé
                String updateTicket = "UPDATE ParkingTicket SET checkOutTime = GETDATE(), status = 'Completed', totalFee = ? WHERE ticketID = ?";
                stm = connection.prepareStatement(updateTicket);
                stm.setDouble(1, totalFee);
                stm.setInt(2, ticketID);
                int ticketUpdated = stm.executeUpdate();
                stm.close();

                // Cập nhật trạng thái Slot (Chỉ khi cập nhật vé thành công)
                if (ticketUpdated > 0) {
                    String updateSlot = "UPDATE ParkingSlot SET status = 'Empty' WHERE slotID = ?";
                    stm = connection.prepareStatement(updateSlot);
                    stm.setInt(1, slotID);
                    stm.executeUpdate();
                }
            }
            connection.commit();
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true);
                if (rs != null) rs.close();
                if (stm != null) stm.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public void createParkingTicket(ParkingTicket o) {
        String sql = "insert into ParkingTicket (vehicleID, slotID, createdBy, checkInTime, checkOutTime, totalFee, status) values (?, ?, ?, ?, ?, ?, ?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getVehicleID());
            stm.setString(2, o.getSlotID());
            stm.setString(3, o.getCreatedBy());
            stm.setTimestamp(4, o.getCheckInTime());
            stm.setTimestamp(5, o.getCheckOutTime());
            stm.setDouble(6, o.getTotalFee());
            stm.setString(7, o.getStatus());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public ArrayList<ParkingTicket> readParkingTickets() {
        ArrayList<ParkingTicket> result = new ArrayList<>();
        // Cập nhật SQL JOIN để lấy biển số xe
        String sql = "SELECT pt.*, v.plateNumber FROM ParkingTicket pt " +
                     "LEFT JOIN Vehicle v ON pt.vehicleID = v.vehicleID " +
                     "ORDER BY pt.checkInTime DESC";
        try {
            stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                ParkingTicket o = new ParkingTicket();
                o.setTicketID(rs.getInt("ticketID"));
                o.setVehicleID(rs.getString("vehicleID"));
                o.setSlotID(rs.getString("slotID"));
                o.setCreatedBy(rs.getString("createdBy"));
                o.setCheckInTime(rs.getTimestamp("checkInTime"));
                o.setCheckOutTime(rs.getTimestamp("checkOutTime"));
                o.setTotalFee(rs.getDouble("totalFee"));
                o.setStatus(rs.getString("status"));
                
                // Hứng dữ liệu biển số xe từ JOIN
                try {
                    o.setPlateNumber(rs.getString("plateNumber"));
                } catch (SQLException ignore) {}
                
                result.add(o);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return result;
    }

    public void updateParkingTicket(ParkingTicket o) {
        String sql = "update ParkingTicket set vehicleID = ?, slotID = ?, createdBy = ?, checkInTime = ?, checkOutTime = ?, totalFee = ?, status = ? where ticketID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getVehicleID());
            stm.setString(2, o.getSlotID());
            stm.setString(3, o.getCreatedBy());
            stm.setTimestamp(4, o.getCheckInTime());
            stm.setTimestamp(5, o.getCheckOutTime());
            stm.setDouble(6, o.getTotalFee());
            stm.setString(7, o.getStatus());
            stm.setInt(8, o.getTicketID());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteParkingTicket(int id) {
        String sql = "delete from ParkingTicket where ticketID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
