package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ParkingTicket;

public class ParkingTicketDAO extends DBContext {

    public List<ParkingTicket> getAll(String keyword, String statusFilter) {
        List<ParkingTicket> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM ParkingTicket WHERE 1=1 ");
        
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus = statusFilter != null && !statusFilter.trim().isEmpty();
        
        if (hasKeyword) {
            sql.append(" AND (ticketCode LIKE ? OR plateNumber LIKE ?) ");
        }
        if (hasStatus) {
            sql.append(" AND status = ? ");
        }
        
        sql.append(" ORDER BY checkInTime DESC");

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (hasKeyword) {
                ps.setString(paramIndex++, "%" + keyword + "%");
                ps.setString(paramIndex++, "%" + keyword + "%");
            }
            if (hasStatus) {
                ps.setString(paramIndex++, statusFilter);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public ParkingTicket getById(int id) {
        String sql = "SELECT * FROM ParkingTicket WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public ParkingTicket getByTicketCode(String ticketCode) {
        String sql = "SELECT * FROM ParkingTicket WHERE ticketCode = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, ticketCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean isPlateActive(String plateNumber) {
        String sql = "SELECT 1 FROM ParkingTicket WHERE plateNumber = ? AND status = 'Parking'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, plateNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public ParkingTicket create(ParkingTicket ticket) {
        String sql = "INSERT INTO ParkingTicket (ticketCode, plateNumber, typeID, slotID, customerID, monthlyCardID, checkInStaffID, status) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, ticket.getTicketCode());
            ps.setString(2, ticket.getPlateNumber());
            ps.setInt(3, ticket.getTypeID());
            
            if (ticket.getSlotID() != null) ps.setInt(4, ticket.getSlotID());
            else ps.setNull(4, java.sql.Types.INTEGER);
            
            if (ticket.getCustomerID() != null) ps.setInt(5, ticket.getCustomerID());
            else ps.setNull(5, java.sql.Types.INTEGER);
            
            if (ticket.getMonthlyCardID() != null) ps.setInt(6, ticket.getMonthlyCardID());
            else ps.setNull(6, java.sql.Types.INTEGER);
            
            ps.setInt(7, ticket.getCheckInStaffID());
            ps.setString(8, ticket.getStatus());
            
            if (ps.executeUpdate() > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        ticket.setId(rs.getInt(1));
                        return ticket;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // indicates failure
    }

    public boolean update(ParkingTicket ticket) {
        String sql = "UPDATE ParkingTicket SET status = ?, checkOutTime = ?, checkOutStaffID = ?, customerID = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, ticket.getStatus());
            
            if (ticket.getCheckOutTime() != null) ps.setTimestamp(2, ticket.getCheckOutTime());
            else ps.setNull(2, java.sql.Types.TIMESTAMP);
            
            if (ticket.getCheckOutStaffID() != null) ps.setInt(3, ticket.getCheckOutStaffID());
            else ps.setNull(3, java.sql.Types.INTEGER);
            
            if (ticket.getCustomerID() != null) ps.setInt(4, ticket.getCustomerID());
            else ps.setNull(4, java.sql.Types.INTEGER);
            
            ps.setInt(5, ticket.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private ParkingTicket mapRow(ResultSet rs) throws SQLException {
        ParkingTicket t = new ParkingTicket();
        t.setId(rs.getInt("id"));
        t.setTicketCode(rs.getString("ticketCode"));
        t.setPlateNumber(rs.getString("plateNumber"));
        t.setTypeID(rs.getInt("typeID"));
        
        int slotID = rs.getInt("slotID");
        if (!rs.wasNull()) t.setSlotID(slotID);
        
        int customerID = rs.getInt("customerID");
        if (!rs.wasNull()) t.setCustomerID(customerID);
        
        int monthlyCardID = rs.getInt("monthlyCardID");
        if (!rs.wasNull()) t.setMonthlyCardID(monthlyCardID);
        
        // Map remaining standard ticket fields
        t.setCheckInTime(rs.getTimestamp("checkInTime"));
        t.setCheckOutTime(rs.getTimestamp("checkOutTime"));
        t.setCheckInStaffID(rs.getInt("checkInStaffID"));
        
        int checkOutStaffID = rs.getInt("checkOutStaffID");
        if (!rs.wasNull()) t.setCheckOutStaffID(checkOutStaffID);
        
        t.setStatus(rs.getString("status"));
        return t;
    }
}
