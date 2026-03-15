package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Users;

/**
 * Data Access Object for Users.
 */
public class UserDAO extends DBContext {
    private PreparedStatement stm; // For executing queries
    private ResultSet rs;          // For holding results

    /**
     * Authenticates a user.
     * @param username The username
     * @param password The password
     * @return Users object if successful, null otherwise
     */
    public Users login(String username, String password) {
        String sql = "SELECT * FROM Users WHERE username = ? AND password = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, username);
            stm.setString(2, password);
            rs = stm.executeQuery();
            if (rs.next()) {
                Users user = new Users();
                user.setUserID(rs.getInt("userID"));
                user.setFullName(rs.getString("fullName"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setPhone(rs.getString("phone"));
                user.setStatus(rs.getBoolean("status"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } 
        return null;
    }

    /**
     * Retrieves all staff users.
     * @return List of Users
     */
    public List<Users> getAllStaff() {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role = 'staff'";
        try {
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            while (rs.next()) {
                Users staff = new Users();
                staff.setUserID(rs.getInt("userID"));
                staff.setFullName(rs.getString("fullName"));
                staff.setUsername(rs.getString("username"));
                staff.setPassword(rs.getString("password"));
                staff.setRole(rs.getString("role"));
                staff.setPhone(rs.getString("phone"));
                staff.setStatus(rs.getBoolean("status"));
                list.add(staff);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } 
        return list;
    }
}
