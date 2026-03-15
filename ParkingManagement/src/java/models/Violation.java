package models;

/**
 * Represents the Violation entity.
 */
public class Violation {

    private int violationID;
    private String ticketID;
    private String reason;
    private double fineAmount;

    public Violation() {
    }

    public Violation(int violationID, String ticketID, String reason, double fineAmount) {
        this.violationID = violationID;
        this.ticketID = ticketID;
        this.reason = reason;
        this.fineAmount = fineAmount;
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

    @Override
    public String toString() {
        return "Violation{"
                + "violationID=" + violationID + ", "
                + "ticketID=" + ticketID + ", "
                + "reason=" + reason + ", "
                + "fineAmount=" + fineAmount
                + "}";
    }
}
