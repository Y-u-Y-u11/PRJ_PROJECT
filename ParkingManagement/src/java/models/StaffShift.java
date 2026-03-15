package models;

/**
 * Represents the StaffShift entity.
 */
public class StaffShift {

    private int id;
    private String userID;
    private String shiftID;
    private String workDate;

    public StaffShift() {
    }

    public StaffShift(int id, String userID, String shiftID, String workDate) {
        this.id = id;
        this.userID = userID;
        this.shiftID = shiftID;
        this.workDate = workDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getShiftID() {
        return shiftID;
    }

    public void setShiftID(String shiftID) {
        this.shiftID = shiftID;
    }

    public String getWorkDate() {
        return workDate;
    }

    public void setWorkDate(String workDate) {
        this.workDate = workDate;
    }

    @Override
    public String toString() {
        return "StaffShift{"
                + "id=" + id + ", "
                + "userID=" + userID + ", "
                + "shiftID=" + shiftID + ", "
                + "workDate=" + workDate
                + "}";
    }
}
