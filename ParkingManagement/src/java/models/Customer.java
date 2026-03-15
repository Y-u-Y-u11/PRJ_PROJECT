package models;

/**
 * Represents the Customer entity.
 */
public class Customer {

    private int customerID;
    private String fullName;
    private String phone;
    private String email;

    public Customer() {
    }

    public Customer(int customerID, String fullName, String phone, String email) {
        this.customerID = customerID;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public String toString() {
        return "Customer{"
                + "customerID=" + customerID + ", "
                + "fullName=" + fullName + ", "
                + "phone=" + phone + ", "
                + "email=" + email
                + "}";
    }
}
