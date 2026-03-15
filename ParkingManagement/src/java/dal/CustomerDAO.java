package dal;

import java.util.ArrayList;
import models.Customer;
import java.sql.*;

/**
 * Data Access Object for Customer.
 */
public class CustomerDAO extends DBContext {

    private PreparedStatement stm;
    private ResultSet rs;

    public void createCustomer(Customer o) {
        String sql = "insert into Customer (fullName, phone, email) values (?, ?, ?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getFullName());
            stm.setString(2, o.getPhone());
            stm.setString(3, o.getEmail());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public ArrayList<Customer> readCustomers() {
        ArrayList<Customer> result = new ArrayList<>();
        String sql = "select * from Customer";
        try {
            stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Customer o = new Customer();
                o.setCustomerID(rs.getInt("customerID"));
                o.setFullName(rs.getString("fullName"));
                o.setPhone(rs.getString("phone"));
                o.setEmail(rs.getString("email"));
                result.add(o);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return result;
    }

    public void updateCustomer(Customer o) {
        String sql = "update Customer set fullName = ?, phone = ?, email = ? where customerID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getFullName());
            stm.setString(2, o.getPhone());
            stm.setString(3, o.getEmail());
            stm.setInt(4, o.getCustomerID());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteCustomer(int id) {
        String sql = "delete from Customer where customerID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
