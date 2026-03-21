package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class PaymentTransaction {
    private int id;
    private int ticketID;
    private BigDecimal amount;
    private String method;
    private String status;
    private String referenceCode;
    private Timestamp paidAt;

    public PaymentTransaction() {}

    public PaymentTransaction(int id, int ticketID, BigDecimal amount, String method, String status, String referenceCode, Timestamp paidAt) {
        this.id = id;
        this.ticketID = ticketID;
        this.amount = amount;
        this.method = method;
        this.status = status;
        this.referenceCode = referenceCode;
        this.paidAt = paidAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getTicketID() { return ticketID; }
    public void setTicketID(int ticketID) { this.ticketID = ticketID; }
    
    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
    
    public String getMethod() { return method; }
    public void setMethod(String method) { this.method = method; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getReferenceCode() { return referenceCode; }
    public void setReferenceCode(String referenceCode) { this.referenceCode = referenceCode; }
    
    public Timestamp getPaidAt() { return paidAt; }
    public void setPaidAt(Timestamp paidAt) { this.paidAt = paidAt; }
}
