package dal;

import java.util.ArrayList;
import models.Payment;
import java.sql.*;

/**
 * Data Access Object for Payment.
 */
public class PaymentDAO extends DBContext {

    private PreparedStatement stm;
    private ResultSet rs;

    public void createPayment(Payment o) {
        String sql = "insert into Payment (ticketID, amount, paymentMethod, paymentTime) values (?, ?, ?, ?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getTicketID());
            stm.setDouble(2, o.getAmount());
            stm.setString(3, o.getPaymentMethod());
            stm.setTimestamp(4, o.getPaymentTime());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public ArrayList<Payment> readPayments() {
        ArrayList<Payment> result = new ArrayList<>();
        String sql = "select * from Payment";
        try {
            stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Payment o = new Payment();
                o.setPaymentID(rs.getInt("paymentID"));
                o.setTicketID(rs.getString("ticketID"));
                o.setAmount(rs.getDouble("amount"));
                o.setPaymentMethod(rs.getString("paymentMethod"));
                o.setPaymentTime(rs.getTimestamp("paymentTime"));
                result.add(o);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return result;
    }

    public void updatePayment(Payment o) {
        String sql = "update Payment set ticketID = ?, amount = ?, paymentMethod = ?, paymentTime = ? where paymentID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getTicketID());
            stm.setDouble(2, o.getAmount());
            stm.setString(3, o.getPaymentMethod());
            stm.setTimestamp(4, o.getPaymentTime());
            stm.setInt(5, o.getPaymentID());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deletePayment(int id) {
        String sql = "delete from Payment where paymentID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
