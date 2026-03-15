package models;

/**
 * Represents the ParkingZone entity.
 */
public class ParkingZone {

    private int zoneID;
    private String zoneName;

    public ParkingZone() {
    }

    public ParkingZone(int zoneID, String zoneName) {
        this.zoneID = zoneID;
        this.zoneName = zoneName;
    }

    public int getZoneID() {
        return zoneID;
    }

    public void setZoneID(int zoneID) {
        this.zoneID = zoneID;
    }

    public String getZoneName() {
        return zoneName;
    }

    public void setZoneName(String zoneName) {
        this.zoneName = zoneName;
    }

    @Override
    public String toString() {
        return "ParkingZone{"
                + "zoneID=" + zoneID + ", "
                + "zoneName=" + zoneName
                + "}";
    }
}
