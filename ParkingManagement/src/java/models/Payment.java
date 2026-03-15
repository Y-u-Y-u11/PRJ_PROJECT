package models;

import java.sql.Timestamp;

/**
 * Represents the Payment entity.
 */
public class Payment {

    private int paymentID;
    private String ticketID;
    private double amount;
    private String paymentMethod;
    private Timestamp paymentTime;

    public Payment() {
    }

    public Payment(int paymentID, String ticketID, double amount, String paymentMethod, Timestamp paymentTime) {
        this.paymentID = paymentID;
        this.ticketID = ticketID;
        this.amount = amount;
        this.paymentMethod = paymentMethod;
        this.paymentTime = paymentTime;
    }

    public int getPaymentID() {
        return paymentID;
    }

    public void setPaymentID(int paymentID) {
        this.paymentID = paymentID;
    }

    public String getTicketID() {
        return ticketID;
    }

    public void setTicketID(String ticketID) {
        this.ticketID = ticketID;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Timestamp getPaymentTime() {
        return paymentTime;
    }

    public void setPaymentTime(Timestamp paymentTime) {
        this.paymentTime = paymentTime;
    }

    @Override
    public String toString() {
        return "Payment{"
                + "paymentID=" + paymentID + ", "
                + "ticketID=" + ticketID + ", "
                + "amount=" + amount + ", "
                + "paymentMethod=" + paymentMethod + ", "
                + "paymentTime=" + paymentTime
                + "}";
    }
}
