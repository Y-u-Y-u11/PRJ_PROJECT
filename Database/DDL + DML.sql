-- ======================================================
-- RESET & INITIALIZE PARKING DATABASE
-- ======================================================

USE master;
GO

-- Xóa database nếu đang tồn tại để làm mới hoàn toàn
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'Parking')
BEGIN
    ALTER DATABASE Parking SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Parking;
END
GO

CREATE DATABASE Parking;
GO

USE Parking;
GO

-- =========================
-- 1. USERS
-- =========================
CREATE TABLE Users (
    id INT IDENTITY PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    passwordHash VARCHAR(255) NOT NULL,
    fullName NVARCHAR(100),
    role VARCHAR(10) NOT NULL CHECK (role IN ('manager','staff')),
    status VARCHAR(10) DEFAULT 'active' CHECK (status IN ('active','inactive'))
);

-- =========================
-- 2. SHIFT
-- =========================
CREATE TABLE Shift (
    id INT IDENTITY PRIMARY KEY,
    shiftName NVARCHAR(50) NOT NULL,
    startTime TIME NOT NULL,
    endTime TIME NOT NULL,
    breakMinutes INT NOT NULL DEFAULT 0
);

-- =========================
-- 3. STAFF SHIFT ASSIGNMENT
-- =========================
CREATE TABLE StaffShiftAssignment (
    id INT IDENTITY PRIMARY KEY,
    staffID INT NOT NULL,
    shiftID INT NOT NULL,
    workDate DATE NOT NULL,
    note NVARCHAR(255),
    FOREIGN KEY (staffID) REFERENCES Users(id),
    FOREIGN KEY (shiftID) REFERENCES Shift(id),
    CONSTRAINT UQ_StaffShift UNIQUE (staffID, shiftID, workDate)
);

-- =========================
-- 4. CUSTOMER
-- =========================
CREATE TABLE Customer (
    id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(100),
    phone VARCHAR(20)
);

-- =========================
-- 5. VEHICLE TYPE
-- =========================
CREATE TABLE VehicleType (
    id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    currentPrice DECIMAL(10,2) NOT NULL,
    requiresPlate BIT DEFAULT 1
);

-- =========================
-- 6. MONTHLY CARD
-- =========================
CREATE TABLE MonthlyCard (
    cardID INT IDENTITY(1,1) PRIMARY KEY,
    customerID INT NOT NULL,
    vehicleTypeID INT NOT NULL,
    plateNumber VARCHAR(20) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    price DECIMAL(10,2),
    status VARCHAR(20) DEFAULT 'Active' 
        CHECK (status IN ('Active', 'Expired', 'Cancelled')),
    FOREIGN KEY (customerID) REFERENCES Customer(id),
    FOREIGN KEY (vehicleTypeID) REFERENCES VehicleType(id),
    CONSTRAINT CHK_CardDates CHECK (endDate >= startDate)
);

-- =========================
-- 7. PARKING SLOT
-- =========================
CREATE TABLE ParkingSlot (
    id INT IDENTITY PRIMARY KEY,
    code VARCHAR(10) UNIQUE NOT NULL
);

-- =========================
-- 8. PARKING TICKET
-- =========================
CREATE TABLE ParkingTicket (
    id INT IDENTITY PRIMARY KEY,
    ticketCode VARCHAR(50) UNIQUE NOT NULL,
    plateNumber VARCHAR(20) NULL,
    typeID INT NOT NULL,
    slotID INT NULL,
    customerID INT NULL,
    monthlyCardID INT NULL, 
    checkInTime DATETIME2 DEFAULT SYSDATETIME(),
    checkOutTime DATETIME2 NULL,
    checkInStaffID INT,
    checkOutStaffID INT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Parking'
        CHECK (status IN ('Parking','Completed','Lost_Ticket','Voided')),
    FOREIGN KEY (typeID) REFERENCES VehicleType(id),
    FOREIGN KEY (slotID) REFERENCES ParkingSlot(id),
    FOREIGN KEY (customerID) REFERENCES Customer(id),
    FOREIGN KEY (monthlyCardID) REFERENCES MonthlyCard(cardID),
    FOREIGN KEY (checkInStaffID) REFERENCES Users(id),
    FOREIGN KEY (checkOutStaffID) REFERENCES Users(id)
);

-- =========================
-- 9. PAYMENT TRANSACTION
-- =========================
CREATE TABLE PaymentTransaction (
    id INT IDENTITY PRIMARY KEY,
    ticketID INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    method VARCHAR(10) CHECK (method IN ('Cash','QR','Card')),
    status VARCHAR(10) NOT NULL CHECK (status IN ('Success','Failed','Reversed')),
    referenceCode VARCHAR(100),
    paidAt DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (ticketID) REFERENCES ParkingTicket(id)
);

-- =========================
-- 10. VIOLATION
-- =========================
CREATE TABLE Violation (
    id INT IDENTITY PRIMARY KEY,
    ticketID INT NULL,
    customerID INT NULL,
    reason NVARCHAR(200),
    fine DECIMAL(10,2) NOT NULL,
    status VARCHAR(10) DEFAULT 'Unpaid'
        CHECK (status IN ('Unpaid','Paid','Voided')),
    createdAt DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (ticketID) REFERENCES ParkingTicket(id),
    FOREIGN KEY (customerID) REFERENCES Customer(id),
    CONSTRAINT CHK_Violation_Target
    CHECK (ticketID IS NOT NULL OR customerID IS NOT NULL)
);

-- =========================
-- 11. AUDIT LOG
-- =========================
CREATE TABLE AuditLog (
    id INT IDENTITY PRIMARY KEY,
    staffID INT,
    actionType VARCHAR(20)
        CHECK (actionType IN ('CREATE','UPDATE','VOID','OVERRIDE')),
    tableName VARCHAR(50),
    recordID INT,
    columnName VARCHAR(50),
    oldValue NVARCHAR(255),
    newValue NVARCHAR(255),
    reason NVARCHAR(255),
    createdAt DATETIME2 DEFAULT SYSDATETIME(),
    FOREIGN KEY (staffID) REFERENCES Users(id)
);

-- ======================================================
-- DATA INSERTION
-- ======================================================

-- 1. Users
INSERT INTO Users (username, passwordHash, fullName, role, status) VALUES
('admin', '123', N'Nguyễn Quản Lý', 'manager', 'active'),
('staff1', '123', N'Trần Văn Tú', 'staff', 'active'),
('staff2', '123', N'Lê Thị Lan', 'staff', 'active'),
('staff3', '123', N'Phạm Việt Hùng', 'staff', 'active'),
('staff4', '123', N'Đỗ Văn Nghỉ', 'staff', 'inactive');

-- 2. Shift
INSERT INTO Shift (shiftName, startTime, endTime, breakMinutes) VALUES
(N'Ca Sáng', '06:00:00', '14:00:00', 30),
(N'Ca Chiều', '14:00:00', '22:00:00', 30),
(N'Ca Đêm', '22:00:00', '06:00:00', 60);

-- 3. StaffShiftAssignment
INSERT INTO StaffShiftAssignment (staffID, shiftID, workDate, note) VALUES
(2, 1, CAST(GETDATE() AS DATE), N'Trực cổng A'),
(3, 2, CAST(GETDATE() AS DATE), N'Trực cổng B'),
(4, 3, CAST(GETDATE() AS DATE), N'Tuần tra bãi xe');

-- 4. VehicleType
INSERT INTO VehicleType (name, currentPrice, requiresPlate) VALUES 
(N'Xe đạp', 2000, 0),
(N'Xe máy', 5000, 1),
(N'Ô tô con', 20000, 1),
(N'Xe tải nhẹ', 50000, 1);

-- 5. Customer
INSERT INTO Customer (name, phone) VALUES 
(N'Nguyễn Văn An', '0901234567'),
(N'Trần Thị Bình', '0912345678'),
(N'Lê Văn Cường', '0987654321'),
(N'Phạm Minh Đức', '0933445566'),
(N'Hoàng Diệu Linh', '0977889900');

-- 6. MonthlyCard
INSERT INTO MonthlyCard (customerID, vehicleTypeID, plateNumber, startDate, endDate, price, status) VALUES
(1, 2, '29-A1 12345', '2024-01-01', '2024-12-31', 150000, 'Active'),
(2, 3, '30-H 555.66', '2024-03-01', '2024-04-01', 1200000, 'Expired'),
(3, 2, '51-F1 999.99', '2024-03-15', '2024-04-15', 150000, 'Active');

-- 7. ParkingSlot
INSERT INTO ParkingSlot (code) VALUES 
('A01'), ('A02'), ('A03'), ('A04'), ('A05'),
('B01'), ('B02'), ('B03'), ('B04'), ('B05'),
('C01'), ('C02');

-- 8. ParkingTicket
-- IDs: 1, 2, 3
INSERT INTO ParkingTicket (ticketCode, plateNumber, typeID, slotID, customerID, monthlyCardID, checkInTime, checkInStaffID, status) VALUES
('TK-001', '29-A1 12345', 2, 1, 1, 1, DATEADD(HOUR, -5, SYSDATETIME()), 2, 'Parking'),
('TK-002', '30-L 112.23', 3, 6, NULL, NULL, DATEADD(HOUR, -3, SYSDATETIME()), 3, 'Parking'),
('TK-003', NULL, 1, NULL, NULL, NULL, DATEADD(MINUTE, -45, SYSDATETIME()), 2, 'Parking');

-- IDs: 4, 5
INSERT INTO ParkingTicket (ticketCode, plateNumber, typeID, slotID, customerID, checkInTime, checkOutTime, checkInStaffID, checkOutStaffID, status) VALUES
('TK-004', '51-G 888.88', 3, 7, 4, DATEADD(DAY, -1, SYSDATETIME()), DATEADD(HOUR, -2, SYSDATETIME()), 2, 3, 'Completed'),
('TK-005', '19-K1 444.55', 2, 2, NULL, DATEADD(HOUR, -10, SYSDATETIME()), DATEADD(HOUR, -1, SYSDATETIME()), 4, 3, 'Completed');

-- 9. PaymentTransaction (Sử dụng ticketID từ 1-5)
INSERT INTO PaymentTransaction (ticketID, amount, method, status, referenceCode, paidAt) VALUES
(4, 40000, 'QR', 'Success', 'QR001', DEFAULT),
(5, 5000, 'Cash', 'Success', NULL, DEFAULT),
(4, 40000, 'QR', 'Failed', 'QR_FAIL', DEFAULT);

-- 10. Violation (Sử dụng ticketID từ 1-5)
INSERT INTO Violation (ticketID, customerID, reason, fine, status, createdAt) VALUES
(4, NULL, N'Mất vé', 20000, 'Paid', DEFAULT),
(1, NULL, N'Đỗ sai vị trí', 10000, 'Unpaid', DEFAULT),
(NULL, 1, N'Nợ phí nhiều lần', 50000, 'Unpaid', DEFAULT);

-- 11. AuditLog
INSERT INTO AuditLog (staffID, actionType, tableName, recordID, columnName, oldValue, newValue, reason) VALUES
(1, 'CREATE', 'MonthlyCard', 1, NULL, NULL, 'New Card', N'Đăng ký thẻ tháng mới'),
(3, 'UPDATE', 'ParkingTicket', 4, 'status', 'Parking', 'Completed', N'Khách ra bãi');

GO