-- ============================================================
-- SCRIPT CẬP NHẬT CƠ SỞ DỮ LIỆU WEBBANHMI
-- Dành cho hệ thống đã khởi tạo CSDL trước đó
-- Chạy script này trong SQL Server Management Studio (SSMS)
-- ============================================================

USE webbanhmi;
GO

-- 1. Bổ sung cột so_luong_ton cho bảng toppings nếu chưa có
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'toppings')
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('toppings') AND name = 'so_luong_ton')
    BEGIN
        ALTER TABLE toppings ADD so_luong_ton INT NOT NULL DEFAULT 50;
        PRINT N'Đã bổ sung cột so_luong_ton vào bảng toppings.';
    END
    ELSE
    BEGIN
        PRINT N'Cột so_luong_ton đã tồn tại trong bảng toppings.';
    END

    -- 2. Bổ sung cột don_vi_tinh cho bảng toppings nếu chưa có
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('toppings') AND name = 'don_vi_tinh')
    BEGIN
        ALTER TABLE toppings ADD don_vi_tinh NVARCHAR(50) NOT NULL DEFAULT N'Phần';
        PRINT N'Đã bổ sung cột don_vi_tinh vào bảng toppings.';
    END
    ELSE
    BEGIN
        PRINT N'Cột don_vi_tinh đã tồn tại trong bảng toppings.';
    END
END
GO

-- 3. Cập nhật tổng tiền hóa đơn bị lưu tong_tien = 0 (nếu có)
UPDATE dh
SET dh.tong_tien = sub.tong_thuc
FROM don_hang dh
INNER JOIN (
    SELECT order_id, SUM(gia_ban) AS tong_thuc
    FROM chi_tiet_don_hang
    GROUP BY order_id
    HAVING SUM(gia_ban) > 0
) sub ON dh.id = sub.order_id
WHERE dh.tong_tien = 0;
GO

PRINT N'Cập nhật cơ sở dữ liệu hoàn tất thành công!';
GO
