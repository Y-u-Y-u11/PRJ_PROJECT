package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.User;

/**
 * Data Access Object for User.
 */
public class UserDAO extends DBContext {

    private PreparedStatement stm;
    private ResultSet rs;

    public User login(String username, String password) {
        String sql = "select * from Users where username = ? and password = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, username);
            stm.setString(2, password);
            rs = stm.executeQuery();
            if (rs.next()) {
                User user = new User();
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

    public List<User> getAllStaff() {
        List<User> list = new ArrayList<>();
        String sql = "select * from Users where role = 'staff'";
        try {
            stm = connection.prepareStatement(sql);
            rs = stm.executeQuery();
            while (rs.next()) {
                User staff = new User();
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

    // NEW FEATURE: Search staff
    public List<User> searchStaff(String keyword) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role = 'staff' AND (fullName LIKE ? OR username LIKE ? OR phone LIKE ?)";
        try {
            stm = connection.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            stm.setString(1, searchPattern);
            stm.setString(2, searchPattern);
            stm.setString(3, searchPattern);
            rs = stm.executeQuery();
            while (rs.next()) {
                User staff = new User();
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

    // NEW FEATURE: Get 1 user info (used for update to keep old password)
    public User getUserById(int id) {
        String sql = "select * from Users where userID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            rs = stm.executeQuery();
            if (rs.next()) {
                User user = new User();
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
            System.out.println(e);
        }
        return null;
    }

    public void createUser(User user) {
        String sql = "insert into Users (fullName, username, password, role, phone, status) values (?, ?, ?, ?, ?, ?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, user.getFullName());
            stm.setString(2, user.getUsername());
            stm.setString(3, user.getPassword());
            stm.setString(4, user.getRole());
            stm.setString(5, user.getPhone());
            stm.setBoolean(6, user.isStatus());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public List<User> readUsers() {
        List<User> result = new ArrayList<>();
        String sql = "select * from Users";
        try {
            stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUserID(rs.getInt("userID"));
                user.setFullName(rs.getString("fullName"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setPhone(rs.getString("phone"));
                user.setStatus(rs.getBoolean("status"));
                result.add(user);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return result;
    }

    public void updateUser(User user) {
        String sql = """
                     update Users 
                     set 
                        fullName = ?, 
                        username = ?, 
                        password = ?, 
                        role = ?, 
                        phone = ?, 
                        status = ? 
                        where userID = ?
                     """;
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, user.getFullName());
            stm.setString(2, user.getUsername());
            stm.setString(3, user.getPassword());
            stm.setString(4, user.getRole());
            stm.setString(5, user.getPhone());
            stm.setBoolean(6, user.isStatus());
            stm.setInt(7, user.getUserID());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteUsers(int id) {
        String sql = "delete from Users where userID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}