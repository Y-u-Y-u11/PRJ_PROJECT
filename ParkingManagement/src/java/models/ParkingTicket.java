package models;

import java.sql.Timestamp;

/**
 * Represents the ParkingTicket entity.
 */
public class ParkingTicket {

    private int ticketID;
    private String vehicleID;
    private String slotID;
    private String createdBy;
    private Timestamp checkInTime;
    private Timestamp checkOutTime;
    private double totalFee;
    private String status;

    public ParkingTicket() {
    }

    public ParkingTicket(int ticketID, String vehicleID, String slotID, String createdBy, Timestamp checkInTime, Timestamp checkOutTime, double totalFee, String status) {
        this.ticketID = ticketID;
        this.vehicleID = vehicleID;
        this.slotID = slotID;
        this.createdBy = createdBy;
        this.checkInTime = checkInTime;
        this.checkOutTime = checkOutTime;
        this.totalFee = totalFee;
        this.status = status;
    }

    public int getTicketID() {
        return ticketID;
    }

    public void setTicketID(int ticketID) {
        this.ticketID = ticketID;
    }

    public String getVehicleID() {
        return vehicleID;
    }

    public void setVehicleID(String vehicleID) {
        this.vehicleID = vehicleID;
    }

    public String getSlotID() {
        return slotID;
    }

    public void setSlotID(String slotID) {
        this.slotID = slotID;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public Timestamp getCheckInTime() {
        return checkInTime;
    }

    public void setCheckInTime(Timestamp checkInTime) {
        this.checkInTime = checkInTime;
    }

    public Timestamp getCheckOutTime() {
        return checkOutTime;
    }

    public void setCheckOutTime(Timestamp checkOutTime) {
        this.checkOutTime = checkOutTime;
    }

    public double getTotalFee() {
        return totalFee;
    }

    public void setTotalFee(double totalFee) {
        this.totalFee = totalFee;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "ParkingTicket{"
                + "ticketID=" + ticketID + ", "
                + "vehicleID=" + vehicleID + ", "
                + "slotID=" + slotID + ", "
                + "createdBy=" + createdBy + ", "
                + "checkInTime=" + checkInTime + ", "
                + "checkOutTime=" + checkOutTime + ", "
                + "totalFee=" + totalFee + ", "
                + "status=" + status
                + "}";
    }
}
