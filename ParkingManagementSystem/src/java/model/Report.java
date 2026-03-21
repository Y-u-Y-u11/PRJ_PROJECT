package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Report {
    private int id;
    private String reportType;
    private LocalDateTime generatedDate;
    private BigDecimal totalRevenue;
    private Integer totalSlots;
    private Integer occupiedSlots;

    public Report() {
    }

    public Report(int id, String reportType, LocalDateTime generatedDate, BigDecimal totalRevenue, Integer totalSlots, Integer occupiedSlots) {
        this.id = id;
        this.reportType = reportType;
        this.generatedDate = generatedDate;
        this.totalRevenue = totalRevenue;
        this.totalSlots = totalSlots;
        this.occupiedSlots = occupiedSlots;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getReportType() { return reportType; }
    public void setReportType(String reportType) { this.reportType = reportType; }
    public LocalDateTime getGeneratedDate() { return generatedDate; }
    public void setGeneratedDate(LocalDateTime generatedDate) { this.generatedDate = generatedDate; }
    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }
    public Integer getTotalSlots() { return totalSlots; }
    public void setTotalSlots(Integer totalSlots) { this.totalSlots = totalSlots; }
    public Integer getOccupiedSlots() { return occupiedSlots; }
    public void setOccupiedSlots(Integer occupiedSlots) { this.occupiedSlots = occupiedSlots; }
}
