CREATE TABLE Report (
    id INT IDENTITY(1,1) PRIMARY KEY,
    reportType VARCHAR(50) NOT NULL, 
    generatedDate DATETIME DEFAULT GETDATE(),
    totalRevenue DECIMAL(18,2) NULL,
    totalSlots INT NULL,
    occupiedSlots INT NULL
);

INSERT INTO Report (reportType, totalRevenue) VALUES ('REVENUE', 0);
INSERT INTO Report (reportType, totalSlots, occupiedSlots) VALUES ('PARKING_STATUS', 0, 0);
