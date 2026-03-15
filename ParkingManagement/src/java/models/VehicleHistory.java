package models;

/**
 * Represents the VehicleHistory entity.
 */
public class VehicleHistory {

    private int historyID;
    private String vehicleID;
    private String ticketID;
    private String slotID;
    private String checkInTime;
    private String checkOutTime;

    public VehicleHistory() {
    }

    public VehicleHistory(int historyID, String vehicleID, String ticketID, String slotID, String checkInTime, String checkOutTime) {
        this.historyID = historyID;
        this.vehicleID = vehicleID;
        this.ticketID = ticketID;
        this.slotID = slotID;
        this.checkInTime = checkInTime;
        this.checkOutTime = checkOutTime;
    }

    public int getHistoryID() {
        return historyID;
    }

    public void setHistoryID(int historyID) {
        this.historyID = historyID;
    }

    public String getVehicleID() {
        return vehicleID;
    }

    public void setVehicleID(String vehicleID) {
        this.vehicleID = vehicleID;
    }

    public String getTicketID() {
        return ticketID;
    }

    public void setTicketID(String ticketID) {
        this.ticketID = ticketID;
    }

    public String getSlotID() {
        return slotID;
    }

    public void setSlotID(String slotID) {
        this.slotID = slotID;
    }

    public String getCheckInTime() {
        return checkInTime;
    }

    public void setCheckInTime(String checkInTime) {
        this.checkInTime = checkInTime;
    }

    public String getCheckOutTime() {
        return checkOutTime;
    }

    public void setCheckOutTime(String checkOutTime) {
        this.checkOutTime = checkOutTime;
    }

    @Override
    public String toString() {
        return "VehicleHistory{"
                + "historyID=" + historyID + ", "
                + "vehicleID=" + vehicleID + ", "
                + "ticketID=" + ticketID + ", "
                + "slotID=" + slotID + ", "
                + "checkInTime=" + checkInTime + ", "
                + "checkOutTime=" + checkOutTime
                + "}";
    }
}
