package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.*;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import models.ParkingTicket;

/**
 * Data Access Object for ParkingTicket.
 */
public class ParkingTicketDAO extends DBContext {
    private PreparedStatement stm;
    private ResultSet rs;

    /**
     * Checks in a vehicle, creating a new ticket and updating slot status.
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
                if (stm != null) stm.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Checks out a vehicle, calculates fee using PriceRuleDAO, updates checkout time and slot status.
     * @param ticketID The ID of the ticket to checkout
     */
    public void checkOut(int ticketID) {
        String getTicketSql = "SELECT pt.checkInTime, pt.slotID, v.typeID FROM ParkingTicket pt JOIN Vehicle v ON pt.vehicleID = v.vehicleID WHERE pt.ticketID = ?";
        try {
            connection.setAutoCommit(false);
            
            stm = connection.prepareStatement(getTicketSql);
            stm.setInt(1, ticketID);
            rs = stm.executeQuery();
            if (rs.next()) {
                Timestamp checkInTime = rs.getTimestamp("checkInTime");
                int slotID = rs.getInt("slotID");
                int typeID = rs.getInt("typeID");
                
                long diff = System.currentTimeMillis() - checkInTime.getTime();
                int hours = (int) Math.ceil(diff / (1000.0 * 60 * 60));
                if (hours == 0) hours = 1;
                
                rs.close();
                stm.close();
                
                PriceRuleDAO priceRuleDAO = new PriceRuleDAO();
                double fee = priceRuleDAO.getPrice(typeID, hours);
                
                String updateTicket = "UPDATE ParkingTicket SET checkOutTime = GETDATE(), status = 'Completed', totalFee = ? WHERE ticketID = ?";
                stm = connection.prepareStatement(updateTicket);
                stm.setDouble(1, fee);
                stm.setInt(2, ticketID);
                stm.executeUpdate();
                stm.close();
                
                String updateSlot = "UPDATE ParkingSlot SET status = 'Empty' WHERE slotID = ?";
                stm = connection.prepareStatement(updateSlot);
                stm.setInt(1, slotID);
                stm.executeUpdate();
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
}
