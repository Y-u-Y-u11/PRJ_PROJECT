package models;

import java.sql.Time;

/**
 * Represents the Shift entity.
 */
public class Shift {

    private int shiftID;
    private String shiftName;
    private String startTime;
    private Time endTime;

    public Shift() {
    }

    public Shift(int shiftID, String shiftName, String startTime, Time endTime) {
        this.shiftID = shiftID;
        this.shiftName = shiftName;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    public int getShiftID() {
        return shiftID;
    }

    public void setShiftID(int shiftID) {
        this.shiftID = shiftID;
    }

    public String getShiftName() {
        return shiftName;
    }

    public void setShiftName(String shiftName) {
        this.shiftName = shiftName;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public Time getEndTime() {
        return endTime;
    }

    public void setEndTime(Time endTime) {
        this.endTime = endTime;
    }

    @Override
    public String toString() {
        return "Shift{"
                + "shiftID=" + shiftID + ", "
                + "shiftName=" + shiftName + ", "
                + "startTime=" + startTime + ", "
                + "endTime=" + endTime
                + "}";
    }
}
