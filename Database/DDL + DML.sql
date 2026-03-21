-- ======================================================
-- PARKING MANAGEMENT SYSTEM
-- ======================================================

CREATE DATABASE ParkingMS;
GO
USE ParkingMS;
GO

-- =========================
-- USERS
-- =========================
CREATE TABLE Users (
    id INT IDENTITY PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    passwordHash VARCHAR(255) NOT NULL,
    fullName NVARCHAR(100),
    role VARCHAR(10) NOT NULL CHECK (role IN ('manager','staff')),
    status VARCHAR(10) DEFAULT 'active' CHECK (status IN ('active','inactive'))
);

INSERT INTO Users VALUES
('manager01','123',N'Nguyễn Văn Quản','manager','active'),
('manager02','123',N'Lê Thị Điều Hành','manager','active'),
('staff01','123',N'Trần Văn A','staff','active'),
('staff02','123',N'Phạm Thị B','staff','active'),
('staff03','123',N'Nguyễn Văn C','staff','inactive'),
('staff04','123',N'Lê Văn D','staff','active');


-- =========================
-- CUSTOMER
-- =========================
CREATE TABLE Customer (
    id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(100),
    phone VARCHAR(20)
);

INSERT INTO Customer VALUES
(N'Nguyễn Văn An','0901111111'),
(N'Trần Thị Bình','0902222222'),
(N'Lê Văn Cường','0903333333'),
(N'Phạm Thị Dung','0904444444'),
(N'Hoàng Văn Em','0905555555'),
(N'Vũ Thị Giang','0906666666'),
(N'Đặng Văn Hùng','0907777777'),
(N'Bùi Thị Lan','0908888888');


-- =========================
-- VEHICLE TYPE
-- =========================
CREATE TABLE VehicleType (
    id INT IDENTITY PRIMARY KEY,
    name NVARCHAR(50) NOT NULL,
    currentPrice DECIMAL(10,2) NOT NULL,
    requiresPlate BIT DEFAULT 1
);

INSERT INTO VehicleType VALUES
(N'Xe máy',5000,1),
(N'Ô tô con',20000,1),
(N'Xe tải',50000,1),
(N'Xe đạp',2000,0);


-- =========================
-- PARKING SLOT
-- =========================
CREATE TABLE ParkingSlot (
    id INT IDENTITY PRIMARY KEY,
    code VARCHAR(10) UNIQUE NOT NULL
);

INSERT INTO ParkingSlot (code) VALUES
('A01'),('A02'),('A03'),('A04'),('A05'),
('B01'),('B02'),('B03'),('B04'),
('C01'),('C02'),('C03');


-- =========================
-- PARKING TICKET
-- =========================
CREATE TABLE ParkingTicket (
    id INT IDENTITY PRIMARY KEY,
    ticketCode VARCHAR(50) UNIQUE NOT NULL,
    plateNumber VARCHAR(20) NULL,
    typeID INT NOT NULL,
    slotID INT NULL,
    customerID INT NULL,
    checkInTime DATETIME2 DEFAULT SYSDATETIME(),
    checkOutTime DATETIME2 NULL,
    checkInStaffID INT,
    checkOutStaffID INT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Parking'
        CHECK (status IN ('Parking','Completed','Lost_Ticket','Voided')),
    FOREIGN KEY (typeID) REFERENCES VehicleType(id),
    FOREIGN KEY (slotID) REFERENCES ParkingSlot(id),
    FOREIGN KEY (customerID) REFERENCES Customer(id),
    FOREIGN KEY (checkInStaffID) REFERENCES Users(id),
    FOREIGN KEY (checkOutStaffID) REFERENCES Users(id)
);

INSERT INTO ParkingTicket 
(ticketCode,plateNumber,typeID,slotID,customerID,checkInTime,checkOutTime,checkInStaffID,checkOutStaffID,status)
VALUES
('TK001','51A-11111',1,1,1, DATEADD(HOUR,-2,SYSDATETIME()),NULL,3,NULL,'Parking'),
('TK002','51A-22222',1,2,2, DATEADD(HOUR,-1,SYSDATETIME()),NULL,3,NULL,'Parking'),
('TK003','30A-33333',2,6,3, DATEADD(HOUR,-3,SYSDATETIME()),NULL,4,NULL,'Parking'),
('TK004',NULL,4,NULL,4, DATEADD(MINUTE,-30,SYSDATETIME()),NULL,4,NULL,'Parking'),

('TK005','51B-55555',1,3,1, DATEADD(HOUR,-5,SYSDATETIME()),DATEADD(HOUR,-2,SYSDATETIME()),3,4,'Completed'),
('TK006','51C-66666',2,7,2, DATEADD(DAY,-1,SYSDATETIME()),DATEADD(HOUR,-10,SYSDATETIME()),4,3,'Completed'),
('TK007','30A-77777',2,8,3, DATEADD(HOUR,-8,SYSDATETIME()),DATEADD(HOUR,-1,SYSDATETIME()),3,4,'Completed'),

('TK008','59A-88888',1,4,5, DATEADD(HOUR,-6,SYSDATETIME()),DATEADD(HOUR,-1,SYSDATETIME()),3,4,'Lost_Ticket'),
('TK009','51D-99999',1,5,6, DATEADD(HOUR,-2,SYSDATETIME()),NULL,4,NULL,'Voided');


-- =========================
-- PAYMENT
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

INSERT INTO PaymentTransaction VALUES
(5,15000,'Cash','Success',NULL,DEFAULT),
(6,40000,'QR','Success','QR001',DEFAULT),
(7,60000,'Card','Success','CARD001',DEFAULT),
(8,20000,'Cash','Success',NULL,DEFAULT),
(8,10000,'QR','Success','QR002',DEFAULT),
(7,60000,'QR','Failed','QR_FAIL',DEFAULT),
(7,60000,'QR','Reversed','QR_REV',DEFAULT);


-- =========================
-- VIOLATION
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

INSERT INTO Violation VALUES
(8,NULL,N'Mất vé',20000,'Paid',DEFAULT),
(3,NULL,N'Đỗ sai vị trí',10000,'Unpaid',DEFAULT),
(NULL,1,N'Nợ phí nhiều lần',50000,'Unpaid',DEFAULT),
(NULL,2,N'Gây mất trật tự',30000,'Paid',DEFAULT),
(2,2,N'Đỗ quá thời gian',15000,'Unpaid',DEFAULT);


-- =========================
-- AUDIT LOG
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

INSERT INTO AuditLog VALUES
(3,'CREATE','ParkingTicket',1,NULL,NULL,'New ticket',N'Check-in xe',DEFAULT),
(4,'UPDATE','ParkingTicket',5,'status','Parking','Completed',N'Check-out',DEFAULT),
(3,'UPDATE','Violation',2,'status','Unpaid','Paid',N'Đã thanh toán',DEFAULT),
(4,'VOID','ParkingTicket',9,'status','Parking','Voided',N'Hủy vé',DEFAULT),
(3,'OVERRIDE','PaymentTransaction',7,'status','Failed','Success',N'Sửa lỗi',DEFAULT);


-- =========================
-- REPORT
-- =========================
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


GO