-- 1. Tạo và chọn cơ sở dữ liệu
CREATE DATABASE IF NOT EXISTS autoride_db;
USE autoride_db;

-- Xóa các bảng cũ nếu tồn tại để chạy lại kịch bản sạch sẽ
DROP TABLE IF EXISTS Inspections;
DROP TABLE IF EXISTS Rentals;
DROP TABLE IF EXISTS Cars;

-- 2. Tạo bảng Cars
CREATE TABLE Cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20) UNIQUE NOT NULL
);

-- 3. Tạo bảng Rentals (Đã khắc phục lỗi trạng thái và bổ sung các cột tài chính chuẩn DECIMAL)
CREATE TABLE Rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    car_id INT,
    customer_name VARCHAR(100) NOT NULL,
    rent_date DATETIME NOT NULL,
    return_date DATETIME,
    
    -- Sử dụng ENUM để khóa chặt các trạng thái vòng đời hợp đồng
    status ENUM('BOOKED', 'ACTIVE', 'COMPLETED', 'CANCELLED') DEFAULT 'BOOKED',
    
    -- Các cột tài chính sử dụng DECIMAL(10, 2) để tránh sai số tính toán tiền tệ
    security_deposit DECIMAL(10, 2) DEFAULT 0.00,
    late_fee DECIMAL(10, 2) DEFAULT 0.00,
    damage_fee DECIMAL(10, 2) DEFAULT 0.00,
    
    FOREIGN KEY (car_id) REFERENCES Cars(car_id)
);

-- 4. Tạo bảng Inspections (Biên bản kiểm tra xe khi trả)
CREATE TABLE Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    inspection_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    damage_description TEXT NOT NULL,
    inspector_name VARCHAR(100) NOT NULL,
    
    -- Liên kết khóa ngoại chặt chẽ với bảng Rentals
    FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id) ON DELETE RESTRICT
);

-- ==========================================
-- VẬN HÀNH VÀ CHÉP LIỆU THỰC TẾ (DML)
-- ==========================================

-- Thêm xe mẫu vào hệ thống
INSERT INTO Cars (model_name, license_plate) VALUES ('VinFast VF8', '30E-123.45');

-- Kịch bản: Khách hàng "Nguyen Van A" thuê xe, đóng cọc 10.000.000 VNĐ. Trạng thái ACTIVE.
INSERT INTO Rentals (car_id, customer_name, rent_date, status, security_deposit) 
VALUES (1, 'Nguyen Van A', '2026-10-20 08:00:00', 'ACTIVE', 10000000.00);

-- Khách trả xe, nhân viên kiểm tra phát hiện vỡ đèn pha trái.
-- Insert dữ liệu vào bảng Inspections
INSERT INTO Inspections (rental_id, damage_description, inspector_name) 
VALUES (1, 'Vỡ đèn pha trái', 'Tran Van Vien');

-- Update bảng Rentals: Trạng thái COMPLETED, ghi nhận late_fee = 0, damage_fee = 2.000.000 VNĐ.
UPDATE Rentals 
SET status = 'COMPLETED', 
    return_date = '2026-10-22 18:00:00',
    late_fee = 0.00, 
    damage_fee = 2000000.00 
WHERE rental_id = 1;

-- Truy vấn tính toán số tiền thực tế cần hoàn trả cho khách hàng (Tiền cọc - Phí phạt trễ - Phí sửa chữa)
-- Sử dụng hàm COALESCE để xử lý an toàn các giá trị NULL nếu có
SELECT 
    r.rental_id,
    r.customer_name,
    c.license_plate,
    r.status,
    r.security_deposit,
    COALESCE(r.late_fee, 0.00) AS late_fee,
    COALESCE(r.damage_fee, 0.00) AS damage_fee,
    i.damage_description,
    -- Tính toán số tiền hoàn lại chính xác cho khách
    (r.security_deposit - COALESCE(r.late_fee, 0.00) - COALESCE(r.damage_fee, 0.00)) AS refund_amount
FROM Rentals r
JOIN Cars c ON r.car_id = c.car_id
LEFT JOIN Inspections i ON r.rental_id = i.rental_id
WHERE r.rental_id = 1;
