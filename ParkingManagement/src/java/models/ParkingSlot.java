package models;

/**
 * Represents the ParkingSlot entity.
 */
public class ParkingSlot {

    private int slotID;
    private String slotCode;
    private String zoneID;
    private String status;

    public ParkingSlot() {
    }

    public ParkingSlot(int slotID, String slotCode, String zoneID, String status) {
        this.slotID = slotID;
        this.slotCode = slotCode;
        this.zoneID = zoneID;
        this.status = status;
    }

    public int getSlotID() {
        return slotID;
    }

    public void setSlotID(int slotID) {
        this.slotID = slotID;
    }

    public String getSlotCode() {
        return slotCode;
    }

    public void setSlotCode(String slotCode) {
        this.slotCode = slotCode;
    }

    public String getZoneID() {
        return zoneID;
    }

    public void setZoneID(String zoneID) {
        this.zoneID = zoneID;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "ParkingSlot{"
                + "slotID=" + slotID + ", "
                + "slotCode=" + slotCode + ", "
                + "zoneID=" + zoneID + ", "
                + "status=" + status
                + "}";
    }
}
