package models;

import java.sql.Timestamp;

/**
 * Represents the AuditLog entity.
 */
public class AuditLog {

    private int logID;
    private String userID;
    private String action;
    private Timestamp actionTime;

    public AuditLog() {
    }

    public AuditLog(int logID, String userID, String action, Timestamp actionTime) {
        this.logID = logID;
        this.userID = userID;
        this.action = action;
        this.actionTime = actionTime;
    }

    public int getLogID() {
        return logID;
    }

    public void setLogID(int logID) {
        this.logID = logID;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public Timestamp getActionTime() {
        return actionTime;
    }

    public void setActionTime(Timestamp actionTime) {
        this.actionTime = actionTime;
    }

    @Override
    public String toString() {
        return "AuditLog{"
                + "logID=" + logID + ", "
                + "userID=" + userID + ", "
                + "action=" + action + ", "
                + "actionTime=" + actionTime
                + "}";
    }
}
