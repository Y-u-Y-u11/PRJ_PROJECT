package models;

/**
 * Represents the VehicleType entity.
 */
public class VehicleType {

    private int typeID;
    private String typeName;
    private double basePrice;

    public VehicleType() {
    }

    public VehicleType(int typeID, String typeName, double basePrice) {
        this.typeID = typeID;
        this.typeName = typeName;
        this.basePrice = basePrice;
    }

    public int getTypeID() {
        return typeID;
    }

    public void setTypeID(int typeID) {
        this.typeID = typeID;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public double getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(double basePrice) {
        this.basePrice = basePrice;
    }

    @Override
    public String toString() {
        return "VehicleType{"
                + "typeID=" + typeID + ", "
                + "typeName=" + typeName + ", "
                + "basePrice=" + basePrice
                + "}";
    }
}
