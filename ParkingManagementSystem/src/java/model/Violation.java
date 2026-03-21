package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Violation {
    private int id;
    private Integer ticketID; // Nullable
    private Integer customerID; // Nullable
    private String reason;
    private BigDecimal fine;
    private String status;
    private Timestamp createdAt;

    public Violation() {}

    public Violation(int id, Integer ticketID, Integer customerID, String reason, BigDecimal fine, String status, Timestamp createdAt) {
        this.id = id;
        this.ticketID = ticketID;
        this.customerID = customerID;
        this.reason = reason;
        this.fine = fine;
        this.status = status;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public Integer getTicketID() { return ticketID; }
    public void setTicketID(Integer ticketID) { this.ticketID = ticketID; }
    
    public Integer getCustomerID() { return customerID; }
    public void setCustomerID(Integer customerID) { this.customerID = customerID; }
    
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    
    public BigDecimal getFine() { return fine; }
    public void setFine(BigDecimal fine) { this.fine = fine; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
