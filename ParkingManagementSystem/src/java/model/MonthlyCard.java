package model;

/**
 * Represents the MonthlyCard entity.
 */
public class MonthlyCard {

    private int cardID;
    private String customerID;
    private String vehicleID;
    private String startDate;
    private String endDate;
    private String status;

    // Thuộc tính bổ sung để hiển thị
    private String customerName;
    private String plateNumber;

    public MonthlyCard() {
    }

    // Constructor đầy đủ (cũ)
    public MonthlyCard(int cardID, String customerID, String vehicleID,
                       String startDate, String endDate, String status) {
        this.cardID = cardID;
        this.customerID = customerID;
        this.vehicleID = vehicleID;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
    }

    // Constructor mở rộng (có thêm 2 field mới)
    public MonthlyCard(int cardID, String customerID, String vehicleID,
                       String startDate, String endDate, String status,
                       String customerName, String plateNumber) {
        this.cardID = cardID;
        this.customerID = customerID;
        this.vehicleID = vehicleID;
        this.startDate = startDate;
        this.endDate = endDate;
        this.status = status;
        this.customerName = customerName;
        this.plateNumber = plateNumber;
    }

    public int getCardID() {
        return cardID;
    }

    public void setCardID(int cardID) {
        this.cardID = cardID;
    }

    public String getCustomerID() {
        return customerID;
    }

    public void setCustomerID(String customerID) {
        this.customerID = customerID;
    }

    public String getVehicleID() {
        return vehicleID;
    }

    public void setVehicleID(String vehicleID) {
        this.vehicleID = vehicleID;
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

    public String getPlateNumber() {
        return plateNumber;
    }

    public void setPlateNumber(String plateNumber) {
        this.plateNumber = plateNumber;
    }

    @Override
    public String toString() {
        return "MonthlyCard{"
                + "cardID=" + cardID + ", "
                + "customerID='" + customerID + "', "
                + "vehicleID='" + vehicleID + "', "
                + "startDate='" + startDate + "', "
                + "endDate='" + endDate + "', "
                + "status='" + status + "', "
                + "customerName='" + customerName + "', "
                + "plateNumber='" + plateNumber + "'"
                + "}";
    }
}