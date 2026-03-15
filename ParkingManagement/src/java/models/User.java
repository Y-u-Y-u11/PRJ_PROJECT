package models;

/**
 * Model class representing a User.
 */
public class User {

    private int userID;
    private String fullName;
    private String username;
    private String password;
    private String role;
    private String phone;
    private boolean status;

    /**
     * No-args constructor
     */
    public User() {
    }

    /**
     * All-args constructor
     */
    public User(int userID, String fullName, String username, String password, String role, String phone, boolean status) {
        this.userID = userID;
        this.fullName = fullName;
        this.username = username;
        this.password = password;
        this.role = role;
        this.phone = phone;
        this.status = status;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public boolean getStatus() {
        return status;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "User{"
                + "userID=" + userID + ", "
                + "fullName=" + fullName + ", "
                + "username=" + username + ", "
                + "password=" + password + ", "
                + "role=" + role + ", "
                + "phone=" + phone + ", "
                + "status=" + status + "}";
    }
}
