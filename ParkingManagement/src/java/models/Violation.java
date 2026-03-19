package models;

/**
 * Represents the Violation entity.
 */
public class Violation {

    private int violationID;
    private String ticketID;
    private String reason;
    private double fineAmount;

    // Thuộc tính bổ sung để hiển thị
    private String customerName;
    private String plateNumber;

    public Violation() {
    }

    // Constructor cũ
    public Violation(int violationID, String ticketID, String reason, double fineAmount) {
        this.violationID = violationID;
        this.ticketID = ticketID;
        this.reason = reason;
        this.fineAmount = fineAmount;
    }

    // Constructor mở rộng (có thêm field hiển thị)
    public Violation(int violationID, String ticketID, String reason, double fineAmount,
                     String customerName, String plateNumber) {
        this.violationID = violationID;
        this.ticketID = ticketID;
        this.reason = reason;
        this.fineAmount = fineAmount;
        this.customerName = customerName;
        this.plateNumber = plateNumber;
    }

    public int getViolationID() {
        return violationID;
    }

    public void setViolationID(int violationID) {
        this.violationID = violationID;
    }

    public String getTicketID() {
        return ticketID;
    }

    public void setTicketID(String ticketID) {
        this.ticketID = ticketID;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public double getFineAmount() {
        return fineAmount;
    }

    public void setFineAmount(double fineAmount) {
        this.fineAmount = fineAmount;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getPlateNumber() {
        return plateNumber;
    }

    public void setPlateNumber(String plateNumber) {
        this.plateNumber = plateNumber;
    }

    @Override
    public String toString() {
        return "Violation{"
                + "violationID=" + violationID + ", "
                + "ticketID='" + ticketID + "', "
                + "reason='" + reason + "', "
                + "fineAmount=" + fineAmount + ", "
                + "customerName='" + customerName + "', "
                + "plateNumber='" + plateNumber + "'"
                + "}";
    }
}