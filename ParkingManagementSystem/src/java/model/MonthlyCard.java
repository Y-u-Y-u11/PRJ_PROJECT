package model;

import java.math.BigDecimal;

public class MonthlyCard {

    private int cardID;
    private int customerID; // Đổi thành int theo DB
    private int vehicleTypeID; // Thêm mới
    private String plateNumber;
    private String startDate;
    private String endDate;
    private BigDecimal price;
    private String status;

    // Thuộc tính bổ sung để hiển thị (Join từ bảng khác)
    private String customerName;
    private String vehicleTypeName;

    public MonthlyCard() {
    }

    public MonthlyCard(int cardID, int customerID, int vehicleTypeID, String plateNumber, String startDate, String endDate, BigDecimal price, String status) {
        this.cardID = cardID;
        this.customerID = customerID;
        this.vehicleTypeID = vehicleTypeID;
        this.plateNumber = plateNumber;
        this.startDate = startDate;
        this.endDate = endDate;
        this.price = price;
        this.status = status;
    }

    // Getters and Setters
    public int getCardID() {
        return cardID;
    }

    public void setCardID(int cardID) {
        this.cardID = cardID;
    }

    public int getCustomerID() {
        return customerID;
    }

    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public int getVehicleTypeID() {
        return vehicleTypeID;
    }

    public void setVehicleTypeID(int vehicleTypeID) {
        this.vehicleTypeID = vehicleTypeID;
    }

    public String getPlateNumber() {
        return plateNumber;
    }

    public void setPlateNumber(String plateNumber) {
        this.plateNumber = plateNumber;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getVehicleTypeName() {
        return vehicleTypeName;
    }

    public void setVehicleTypeName(String vehicleTypeName) {
        this.vehicleTypeName = vehicleTypeName;
    }
}
