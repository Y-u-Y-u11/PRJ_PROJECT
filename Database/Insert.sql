USE ParkingManagementSystem;
GO

-- =========================
-- USERS
-- =========================
INSERT INTO Users (fullName, username, password, role, phone)
VALUES
(N'Nguyễn Văn Admin', 'admin', '123', 'admin', '0900000001'),
(N'Trần Văn Staff 1', 'staff1', '123', 'staff', '0900000002'),
(N'Lê Văn Staff 2', 'staff2', '123', 'staff', '0900000003');

-- =========================
-- CUSTOMER
-- =========================
INSERT INTO Customer (fullName, phone, email)
VALUES
(N'Phạm Minh Anh', '0911111111', 'anh@gmail.com'),
(N'Hoàng Quốc Bảo', '0922222222', 'bao@gmail.com'),
(N'Nguyễn Thị Lan', '0933333333', 'lan@gmail.com');

-- =========================
-- VEHICLE TYPE
-- =========================
INSERT INTO VehicleType (typeName, basePrice)
VALUES
(N'Xe máy', 5000),
(N'Ô tô', 20000);

-- =========================
-- VEHICLE
-- =========================
INSERT INTO Vehicle (plateNumber, customerID, typeID, brand, color)
VALUES
('29A-12345', 1, 1, N'Honda', N'Đỏ'),
('30B-67890', 2, 1, N'Yamaha', N'Đen'),
('51C-99999', 3, 2, N'Toyota', N'Trắng');

-- =========================
-- PARKING ZONE
-- =========================
INSERT INTO ParkingZone (zoneName)
VALUES
(N'Khu A'),
(N'Khu B');

-- =========================
-- PARKING SLOT
-- =========================
INSERT INTO ParkingSlot (slotCode, zoneID, status)
VALUES
('A01', 1, 'Occupied'),
('A02', 1, 'Empty'),
('A03', 1, 'Empty'),
('A04', 1, 'Empty'),
('A05', 1, 'Empty'),
('B01', 2, 'Occupied'),
('B02', 2, 'Empty'),
('B03', 2, 'Empty'),
('B04', 2, 'Empty'),
('B05', 2, 'Empty');

-- =========================
-- SHIFT
-- =========================
INSERT INTO Shift (shiftName, startTime, endTime)
VALUES
(N'Ca sáng', '06:00', '14:00'),
(N'Ca chiều', '14:00', '22:00'),
(N'Ca đêm', '22:00', '06:00');

-- =========================
-- STAFF SHIFT
-- =========================
INSERT INTO StaffShift (userID, shiftID, workDate)
VALUES
(2, 1, '2026-03-15'),
(3, 2, '2026-03-15');

-- =========================
-- PRICE RULE
-- =========================
INSERT INTO PriceRule (typeID, startHour, endHour, price)
VALUES
(1, 0, 24, 5000),
(2, 0, 24, 20000);

-- =========================
-- PARKING TICKET
-- =========================
INSERT INTO ParkingTicket (vehicleID, slotID, createdBy, checkInTime, checkOutTime, totalFee, status)
VALUES
(1, 1, 2, GETDATE()-1, NULL, NULL, 'Parking'),
(3, 6, 3, GETDATE()-2, GETDATE(), 40000, 'Completed');

-- =========================
-- PAYMENT
-- =========================
INSERT INTO Payment (ticketID, amount, paymentMethod)
VALUES
(2, 40000, 'Cash');

-- =========================
-- VEHICLE HISTORY
-- =========================
INSERT INTO VehicleHistory (vehicleID, ticketID, slotID, checkInTime, checkOutTime)
VALUES
(3, 2, 6, GETDATE()-2, GETDATE());

-- =========================
-- MONTHLY CARD
-- =========================
INSERT INTO MonthlyCard (customerID, vehicleID, startDate, endDate, status)
VALUES
(1, 1, '2026-03-01', '2026-03-31', 'Active');

-- =========================
-- VIOLATION
-- =========================
INSERT INTO Violation (ticketID, reason, fineAmount)
VALUES
(2, N'Mất vé xe', 50000);

-- =========================
-- AUDIT LOG
-- =========================
INSERT INTO AuditLog (userID, action)
VALUES
(1, N'Tạo tài khoản staff1'),
(2, N'Tạo vé gửi xe');

-- =========================
-- NOTIFICATION
-- =========================
INSERT INTO Notification (title, content)
VALUES
(N'Thông báo hệ thống', N'Hệ thống hoạt động bình thường');
