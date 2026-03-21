package model;

import java.sql.Timestamp;

public class AuditLog {
    private int id;
    private int staffID;
    private String actionType;
    private String tableName;
    private int recordID;
    private String columnName; // Nullable
    private String oldValue;   // Nullable
    private String newValue;   // Nullable
    private String reason;     // Nullable
    private Timestamp createdAt;

    public AuditLog() {}

    public AuditLog(int id, int staffID, String actionType, String tableName, int recordID, String columnName, String oldValue, String newValue, String reason, Timestamp createdAt) {
        this.id = id;
        this.staffID = staffID;
        this.actionType = actionType;
        this.tableName = tableName;
        this.recordID = recordID;
        this.columnName = columnName;
        this.oldValue = oldValue;
        this.newValue = newValue;
        this.reason = reason;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getStaffID() { return staffID; }
    public void setStaffID(int staffID) { this.staffID = staffID; }
    
    public String getActionType() { return actionType; }
    public void setActionType(String actionType) { this.actionType = actionType; }
    
    public String getTableName() { return tableName; }
    public void setTableName(String tableName) { this.tableName = tableName; }
    
    public int getRecordID() { return recordID; }
    public void setRecordID(int recordID) { this.recordID = recordID; }
    
    public String getColumnName() { return columnName; }
    public void setColumnName(String columnName) { this.columnName = columnName; }
    
    public String getOldValue() { return oldValue; }
    public void setOldValue(String oldValue) { this.oldValue = oldValue; }
    
    public String getNewValue() { return newValue; }
    public void setNewValue(String newValue) { this.newValue = newValue; }
    
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
