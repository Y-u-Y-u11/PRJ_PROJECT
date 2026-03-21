package model;

import java.math.BigDecimal;

public class VehicleType {
    private int id;
    private String name;
    private BigDecimal currentPrice;
    private boolean requiresPlate;

    public VehicleType() {}

    public VehicleType(int id, String name, BigDecimal currentPrice, boolean requiresPlate) {
        this.id = id;
        this.name = name;
        this.currentPrice = currentPrice;
        this.requiresPlate = requiresPlate;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public BigDecimal getCurrentPrice() { return currentPrice; }
    public void setCurrentPrice(BigDecimal currentPrice) { this.currentPrice = currentPrice; }
    
    public boolean isRequiresPlate() { return requiresPlate; }
    public void setRequiresPlate(boolean requiresPlate) { this.requiresPlate = requiresPlate; }
}
