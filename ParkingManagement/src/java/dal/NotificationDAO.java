package dal;

import java.util.ArrayList;
import models.Notification;
import java.sql.*;

/**
 * Data Access Object for Notification.
 */
public class NotificationDAO extends DBContext {
    private PreparedStatement stm;
    private ResultSet rs;


    public void createNotification(Notification o) {
        String sql = "insert into Notification (title, content, createdDate) values (?, ?, ?)";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getTitle());
            stm.setString(2, o.getContent());
            stm.setTimestamp(3, o.getCreatedDate());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public ArrayList<Notification> readNotifications() {
        ArrayList<Notification> result = new ArrayList<>();
        String sql = "select * from Notification";
        try {
            stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Notification o = new Notification();
                o.setNotificationID(rs.getInt("notificationID"));
                o.setTitle(rs.getString("title"));
                o.setContent(rs.getString("content"));
                o.setCreatedDate(rs.getTimestamp("createdDate"));
                result.add(o);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return result;
    }

    public void updateNotification(Notification o) {
        String sql = "update Notification set title = ?, content = ?, createdDate = ? where notificationID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setString(1, o.getTitle());
            stm.setString(2, o.getContent());
            stm.setTimestamp(3, o.getCreatedDate());
            stm.setInt(4, o.getNotificationID());
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteNotification(int id) {
        String sql = "delete from Notification where notificationID = ?";
        try {
            stm = connection.prepareStatement(sql);
            stm.setInt(1, id);
            stm.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
}
