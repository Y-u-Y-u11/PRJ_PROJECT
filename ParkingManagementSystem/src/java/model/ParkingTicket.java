package model;

import java.sql.Timestamp;

public class ParkingTicket {
    private int id;
    private String ticketCode;
    private String plateNumber;
    private int typeID;
    private Integer slotID;       // Nullable
    private Integer customerID;   // Nullable
    private Timestamp checkInTime;
    private Timestamp checkOutTime; // Nullable
    private int checkInStaffID;
    private Integer checkOutStaffID; // Nullable
    private String status;

    public ParkingTicket() {}

    public ParkingTicket(int id, String ticketCode, String plateNumber, int typeID, Integer slotID, Integer customerID, Timestamp checkInTime, Timestamp checkOutTime, int checkInStaffID, Integer checkOutStaffID, String status) {
        this.id = id;
        this.ticketCode = ticketCode;
        this.plateNumber = plateNumber;
        this.typeID = typeID;
        this.slotID = slotID;
        this.customerID = customerID;
        this.checkInTime = checkInTime;
        this.checkOutTime = checkOutTime;
        this.checkInStaffID = checkInStaffID;
        this.checkOutStaffID = checkOutStaffID;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getTicketCode() { return ticketCode; }
    public void setTicketCode(String ticketCode) { this.ticketCode = ticketCode; }
    
    public String getPlateNumber() { return plateNumber; }
    public void setPlateNumber(String plateNumber) { this.plateNumber = plateNumber; }
    
    public int getTypeID() { return typeID; }
    public void setTypeID(int typeID) { this.typeID = typeID; }
    
    public Integer getSlotID() { return slotID; }
    public void setSlotID(Integer slotID) { this.slotID = slotID; }
    
    public Integer getCustomerID() { return customerID; }
    public void setCustomerID(Integer customerID) { this.customerID = customerID; }
    
    public Timestamp getCheckInTime() { return checkInTime; }
    public void setCheckInTime(Timestamp checkInTime) { this.checkInTime = checkInTime; }
    
    public Timestamp getCheckOutTime() { return checkOutTime; }
    public void setCheckOutTime(Timestamp checkOutTime) { this.checkOutTime = checkOutTime; }
    
    public int getCheckInStaffID() { return checkInStaffID; }
    public void setCheckInStaffID(int checkInStaffID) { this.checkInStaffID = checkInStaffID; }
    
    public Integer getCheckOutStaffID() { return checkOutStaffID; }
    public void setCheckOutStaffID(Integer checkOutStaffID) { this.checkOutStaffID = checkOutStaffID; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
