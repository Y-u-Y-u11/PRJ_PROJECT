package models;

/**
 * Represents the PriceRule entity.
 */
public class PriceRule {

    private int ruleID;
    private String typeID;
    private String startHour;
    private String endHour;
    private double price;

    public PriceRule() {
    }

    public PriceRule(int ruleID, String typeID, String startHour, String endHour, double price) {
        this.ruleID = ruleID;
        this.typeID = typeID;
        this.startHour = startHour;
        this.endHour = endHour;
        this.price = price;
    }

    public int getRuleID() {
        return ruleID;
    }

    public void setRuleID(int ruleID) {
        this.ruleID = ruleID;
    }

    public String getTypeID() {
        return typeID;
    }

    public void setTypeID(String typeID) {
        this.typeID = typeID;
    }

    public String getStartHour() {
        return startHour;
    }

    public void setStartHour(String startHour) {
        this.startHour = startHour;
    }

    public String getEndHour() {
        return endHour;
    }

    public void setEndHour(String endHour) {
        this.endHour = endHour;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    @Override
    public String toString() {
        return "PriceRule{"
                + "ruleID=" + ruleID + ", "
                + "typeID=" + typeID + ", "
                + "startHour=" + startHour + ", "
                + "endHour=" + endHour + ", "
                + "price=" + price
                + "}";
    }
}
