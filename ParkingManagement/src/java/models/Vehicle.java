package models;

/**
 * Represents the Vehicle entity.
 */
public class Vehicle {

    private int vehicleID;
    private String plateNumber;
    private String customerID;
    private String typeID;
    private String brand;
    private String color;

    public Vehicle() {
    }

    public Vehicle(int vehicleID, String plateNumber, String customerID, String typeID, String brand, String color) {
        this.vehicleID = vehicleID;
        this.plateNumber = plateNumber;
        this.customerID = customerID;
        this.typeID = typeID;
        this.brand = brand;
        this.color = color;
    }

    public int getVehicleID() {
        return vehicleID;
    }

    public void setVehicleID(int vehicleID) {
        this.vehicleID = vehicleID;
    }

    public String getPlateNumber() {
        return plateNumber;
    }

    public void setPlateNumber(String plateNumber) {
        this.plateNumber = plateNumber;
    }

    public String getCustomerID() {
        return customerID;
    }

    public void setCustomerID(String customerID) {
        this.customerID = customerID;
    }

    public String getTypeID() {
        return typeID;
    }

    public void setTypeID(String typeID) {
        this.typeID = typeID;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    @Override
    public String toString() {
        return "Vehicle{"
                + "vehicleID=" + vehicleID + ", "
                + "plateNumber=" + plateNumber + ", "
                + "customerID=" + customerID + ", "
                + "typeID=" + typeID + ", "
                + "brand=" + brand + ", "
                + "color=" + color
                + "}";
    }
}
