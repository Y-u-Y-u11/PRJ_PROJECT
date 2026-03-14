CREATE DATABASE ParkingManagementSystem;
GO

USE ParkingManagementSystem;
GO

-- =========================
-- USERS
-- =========================
CREATE TABLE Users (
    userID INT PRIMARY KEY IDENTITY(1,1),
    fullName NVARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL, -- admin, staff
    phone VARCHAR(15),
    status BIT DEFAULT 1
);

-- =========================
-- CUSTOMER
-- =========================
CREATE TABLE Customer (
    customerID INT PRIMARY KEY IDENTITY(1,1),
    fullName NVARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100)
);

-- =========================
-- VEHICLE TYPE
-- =========================
CREATE TABLE VehicleType (
    typeID INT PRIMARY KEY IDENTITY(1,1),
    typeName NVARCHAR(50) NOT NULL,
    basePrice DECIMAL(10,2) NOT NULL
);

-- =========================
-- VEHICLE
-- =========================
CREATE TABLE Vehicle (
    vehicleID INT PRIMARY KEY IDENTITY(1,1),
    plateNumber VARCHAR(20) UNIQUE NOT NULL,
    customerID INT,
    typeID INT,
    brand NVARCHAR(50),
    color NVARCHAR(30),
    FOREIGN KEY (customerID) REFERENCES Customer(customerID),
    FOREIGN KEY (typeID) REFERENCES VehicleType(typeID)
);

-- =========================
-- PARKING ZONE
-- =========================
CREATE TABLE ParkingZone (
    zoneID INT PRIMARY KEY IDENTITY(1,1),
    zoneName NVARCHAR(50) NOT NULL
);

-- =========================
-- PARKING SLOT
-- =========================
CREATE TABLE ParkingSlot (
    slotID INT PRIMARY KEY IDENTITY(1,1),
    slotCode VARCHAR(20) UNIQUE NOT NULL,
    zoneID INT,
    status VARCHAR(20) DEFAULT 'Empty', -- Empty / Occupied
    FOREIGN KEY (zoneID) REFERENCES ParkingZone(zoneID)
);

-- =========================
-- SHIFT
-- =========================
CREATE TABLE Shift (
    shiftID INT PRIMARY KEY IDENTITY(1,1),
    shiftName NVARCHAR(50),
    startTime TIME,
    endTime TIME
);

-- =========================
-- STAFF SHIFT
-- =========================
CREATE TABLE StaffShift (
    id INT PRIMARY KEY IDENTITY(1,1),
    userID INT,
    shiftID INT,
    workDate DATE,
    FOREIGN KEY (userID) REFERENCES Users(userID),
    FOREIGN KEY (shiftID) REFERENCES Shift(shiftID)
);

-- =========================
-- PRICE RULE
-- =========================
CREATE TABLE PriceRule (
    ruleID INT PRIMARY KEY IDENTITY(1,1),
    typeID INT,
    startHour INT,
    endHour INT,
    price DECIMAL(10,2),
    FOREIGN KEY (typeID) REFERENCES VehicleType(typeID)
);

-- =========================
-- PARKING TICKET
-- =========================
CREATE TABLE ParkingTicket (
    ticketID INT PRIMARY KEY IDENTITY(1,1),
    vehicleID INT,
    slotID INT,
    createdBy INT,
    checkInTime DATETIME NOT NULL,
    checkOutTime DATETIME NULL,
    totalFee DECIMAL(10,2) NULL,
    status VARCHAR(20) DEFAULT 'Parking', -- Parking / Completed
    FOREIGN KEY (vehicleID) REFERENCES Vehicle(vehicleID),
    FOREIGN KEY (slotID) REFERENCES ParkingSlot(slotID),
    FOREIGN KEY (createdBy) REFERENCES Users(userID)
);

-- =========================
-- PAYMENT
-- =========================
CREATE TABLE Payment (
    paymentID INT PRIMARY KEY IDENTITY(1,1),
    ticketID INT,
    amount DECIMAL(10,2),
    paymentMethod VARCHAR(20),
    paymentTime DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ticketID) REFERENCES ParkingTicket(ticketID)
);

-- =========================
-- VEHICLE HISTORY
-- =========================
CREATE TABLE VehicleHistory (
    historyID INT PRIMARY KEY IDENTITY(1,1),
    vehicleID INT,
    ticketID INT,
    slotID INT,
    checkInTime DATETIME,
    checkOutTime DATETIME,
    FOREIGN KEY (vehicleID) REFERENCES Vehicle(vehicleID),
    FOREIGN KEY (ticketID) REFERENCES ParkingTicket(ticketID),
    FOREIGN KEY (slotID) REFERENCES ParkingSlot(slotID)
);

-- =========================
-- MONTHLY CARD
-- =========================
CREATE TABLE MonthlyCard (
    cardID INT PRIMARY KEY IDENTITY(1,1),
    customerID INT,
    vehicleID INT,
    startDate DATE,
    endDate DATE,
    status VARCHAR(20),
    FOREIGN KEY (customerID) REFERENCES Customer(customerID),
    FOREIGN KEY (vehicleID) REFERENCES Vehicle(vehicleID)
);

-- =========================
-- VIOLATION
-- =========================
CREATE TABLE Violation (
    violationID INT PRIMARY KEY IDENTITY(1,1),
    ticketID INT,
    reason NVARCHAR(200),
    fineAmount DECIMAL(10,2),
    FOREIGN KEY (ticketID) REFERENCES ParkingTicket(ticketID)
);

-- =========================
-- AUDIT LOG
-- =========================
CREATE TABLE AuditLog (
    logID INT PRIMARY KEY IDENTITY(1,1),
    userID INT,
    action NVARCHAR(200),
    actionTime DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (userID) REFERENCES Users(userID)
);

-- =========================
-- NOTIFICATION
-- =========================
CREATE TABLE Notification (
    notificationID INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(100),
    content NVARCHAR(300),
    createdDate DATETIME DEFAULT GETDATE()
);
