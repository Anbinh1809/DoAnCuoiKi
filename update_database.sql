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


-- ============================================================
-- DỮ LIỆU MẪU 7 NGÀY GẦN NHẤT (25/07 - 31/07) CHO DASHBOARD
-- ============================================================
USE webbanhmi;
GO

-- Bổ sung nhân viên staff1-staff5 nếu chưa có
IF NOT EXISTS (SELECT 1 FROM nhan_vien WHERE ten_dang_nhap = 'staff1')
BEGIN
    INSERT INTO nhan_vien (ten_dang_nhap, mat_khau, ho_ten, dien_thoai, vai_tro, active) VALUES
    ('staff1', '123', N'Đặng Phi Hùng', '0901000001', 0, 1),
    ('staff2', '123', N'Lê Bình An', '0901000002', 0, 1),
    ('staff3', '123', N'Đinh Ngọc Đại', '0901000003', 0, 1),
    ('staff4', '123', N'Đinh Tiến Lộc', '0901000004', 0, 1),
    ('staff5', '123', N'Tôn Trần Triệu Vĩ', '0901000005', 0, 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D201')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D201', 50000, 'COMPLETED', id, 1, '2026-07-25 07:00:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_id_HD7D201 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D201');
    IF @ord_id_HD7D201 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D201, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D201, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D202')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D202', 56000, 'COMPLETED', id, 2, '2026-07-25 09:13:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff';

    DECLARE @ord_id_HD7D202 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D202');
    IF @ord_id_HD7D202 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D202, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D202, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D203')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D203', 70000, 'COMPLETED', id, 1, '2026-07-25 11:26:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_id_HD7D203 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D203');
    IF @ord_id_HD7D203 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D203, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D203, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D204')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D204', 50000, 'COMPLETED', id, 2, '2026-07-25 13:39:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_id_HD7D204 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D204');
    IF @ord_id_HD7D204 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D204, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D204, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D205')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D205', 56000, 'COMPLETED', id, 1, '2026-07-25 15:52:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_id_HD7D205 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D205');
    IF @ord_id_HD7D205 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D205, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D205, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D206')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D206', 70000, 'COMPLETED', id, 2, '2026-07-25 17:05:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_id_HD7D206 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D206');
    IF @ord_id_HD7D206 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D206, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D206, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D207')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D207', 50000, 'COMPLETED', id, 1, '2026-07-25 08:18:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_id_HD7D207 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D207');
    IF @ord_id_HD7D207 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D207, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D207, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D208')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D208', 56000, 'COMPLETED', id, 2, '2026-07-26 10:09:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_id_HD7D208 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D208');
    IF @ord_id_HD7D208 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D208, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D208, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D209')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D209', 70000, 'COMPLETED', id, 1, '2026-07-26 12:22:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff';

    DECLARE @ord_id_HD7D209 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D209');
    IF @ord_id_HD7D209 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D209, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D209, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D210')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D210', 50000, 'COMPLETED', id, 2, '2026-07-26 14:35:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_id_HD7D210 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D210');
    IF @ord_id_HD7D210 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D210, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D210, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D211')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D211', 56000, 'COMPLETED', id, 1, '2026-07-26 16:48:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_id_HD7D211 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D211');
    IF @ord_id_HD7D211 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D211, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D211, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D212')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D212', 70000, 'COMPLETED', id, 2, '2026-07-26 07:01:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_id_HD7D212 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D212');
    IF @ord_id_HD7D212 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D212, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D212, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D213')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D213', 50000, 'COMPLETED', id, 1, '2026-07-26 09:14:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_id_HD7D213 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D213');
    IF @ord_id_HD7D213 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D213, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D213, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D214')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D214', 56000, 'COMPLETED', id, 2, '2026-07-26 11:27:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_id_HD7D214 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D214');
    IF @ord_id_HD7D214 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D214, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D214, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D215')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D215', 70000, 'COMPLETED', id, 1, '2026-07-27 13:18:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_id_HD7D215 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D215');
    IF @ord_id_HD7D215 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D215, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D215, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D216')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D216', 50000, 'COMPLETED', id, 2, '2026-07-27 15:31:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff';

    DECLARE @ord_id_HD7D216 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D216');
    IF @ord_id_HD7D216 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D216, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D216, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D217')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D217', 56000, 'COMPLETED', id, 1, '2026-07-27 17:44:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_id_HD7D217 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D217');
    IF @ord_id_HD7D217 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D217, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D217, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D218')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D218', 70000, 'COMPLETED', id, 2, '2026-07-27 08:57:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_id_HD7D218 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D218');
    IF @ord_id_HD7D218 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D218, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D218, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D219')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D219', 50000, 'COMPLETED', id, 1, '2026-07-27 10:10:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_id_HD7D219 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D219');
    IF @ord_id_HD7D219 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D219, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D219, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D220')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D220', 56000, 'COMPLETED', id, 2, '2026-07-27 12:23:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_id_HD7D220 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D220');
    IF @ord_id_HD7D220 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D220, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D220, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D221')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D221', 70000, 'COMPLETED', id, 1, '2026-07-27 14:36:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_id_HD7D221 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D221');
    IF @ord_id_HD7D221 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D221, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D221, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D222')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D222', 50000, 'COMPLETED', id, 2, '2026-07-28 16:27:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_id_HD7D222 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D222');
    IF @ord_id_HD7D222 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D222, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D222, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D223')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D223', 56000, 'COMPLETED', id, 1, '2026-07-28 07:40:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff';

    DECLARE @ord_id_HD7D223 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D223');
    IF @ord_id_HD7D223 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D223, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D223, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D224')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D224', 70000, 'COMPLETED', id, 2, '2026-07-28 09:53:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_id_HD7D224 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D224');
    IF @ord_id_HD7D224 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D224, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D224, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D225')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D225', 50000, 'COMPLETED', id, 1, '2026-07-28 11:06:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_id_HD7D225 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D225');
    IF @ord_id_HD7D225 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D225, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D225, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D226')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D226', 56000, 'COMPLETED', id, 2, '2026-07-28 13:19:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_id_HD7D226 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D226');
    IF @ord_id_HD7D226 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D226, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D226, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D227')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D227', 70000, 'COMPLETED', id, 1, '2026-07-28 15:32:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_id_HD7D227 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D227');
    IF @ord_id_HD7D227 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D227, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D227, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D228')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D228', 50000, 'COMPLETED', id, 2, '2026-07-28 17:45:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_id_HD7D228 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D228');
    IF @ord_id_HD7D228 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D228, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D228, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D229')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D229', 56000, 'COMPLETED', id, 1, '2026-07-29 08:36:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_id_HD7D229 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D229');
    IF @ord_id_HD7D229 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D229, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D229, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D230')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D230', 70000, 'COMPLETED', id, 2, '2026-07-29 10:49:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff';

    DECLARE @ord_id_HD7D230 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D230');
    IF @ord_id_HD7D230 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D230, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D230, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D231')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D231', 50000, 'COMPLETED', id, 1, '2026-07-29 12:02:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_id_HD7D231 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D231');
    IF @ord_id_HD7D231 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D231, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D231, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D232')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D232', 56000, 'COMPLETED', id, 2, '2026-07-29 14:15:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_id_HD7D232 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D232');
    IF @ord_id_HD7D232 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D232, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D232, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D233')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D233', 70000, 'COMPLETED', id, 1, '2026-07-29 16:28:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_id_HD7D233 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D233');
    IF @ord_id_HD7D233 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D233, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D233, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D234')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D234', 50000, 'COMPLETED', id, 2, '2026-07-29 07:41:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_id_HD7D234 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D234');
    IF @ord_id_HD7D234 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D234, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D234, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D235')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D235', 56000, 'COMPLETED', id, 1, '2026-07-29 09:54:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_id_HD7D235 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D235');
    IF @ord_id_HD7D235 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D235, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D235, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D236')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D236', 70000, 'COMPLETED', id, 2, '2026-07-30 11:45:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_id_HD7D236 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D236');
    IF @ord_id_HD7D236 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D236, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D236, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D237')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D237', 50000, 'COMPLETED', id, 1, '2026-07-30 13:58:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff';

    DECLARE @ord_id_HD7D237 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D237');
    IF @ord_id_HD7D237 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D237, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D237, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D238')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D238', 56000, 'COMPLETED', id, 2, '2026-07-30 15:11:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_id_HD7D238 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D238');
    IF @ord_id_HD7D238 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D238, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D238, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D239')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D239', 70000, 'COMPLETED', id, 1, '2026-07-30 17:24:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_id_HD7D239 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D239');
    IF @ord_id_HD7D239 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D239, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D239, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D240')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D240', 50000, 'COMPLETED', id, 2, '2026-07-30 08:37:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_id_HD7D240 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D240');
    IF @ord_id_HD7D240 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D240, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D240, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D241')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D241', 56000, 'COMPLETED', id, 1, '2026-07-30 10:50:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_id_HD7D241 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D241');
    IF @ord_id_HD7D241 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D241, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D241, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D242')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D242', 70000, 'COMPLETED', id, 2, '2026-07-30 12:03:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_id_HD7D242 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D242');
    IF @ord_id_HD7D242 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D242, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D242, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D243')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D243', 50000, 'COMPLETED', id, 1, '2026-07-31 14:54:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_id_HD7D243 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D243');
    IF @ord_id_HD7D243 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D243, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D243, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D244')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D244', 56000, 'COMPLETED', id, 2, '2026-07-31 16:07:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff';

    DECLARE @ord_id_HD7D244 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D244');
    IF @ord_id_HD7D244 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D244, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D244, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D245')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D245', 70000, 'COMPLETED', id, 1, '2026-07-31 07:20:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_id_HD7D245 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D245');
    IF @ord_id_HD7D245 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D245, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D245, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D246')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D246', 50000, 'COMPLETED', id, 2, '2026-07-31 09:33:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_id_HD7D246 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D246');
    IF @ord_id_HD7D246 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D246, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D246, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D247')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D247', 56000, 'COMPLETED', id, 1, '2026-07-31 11:46:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_id_HD7D247 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D247');
    IF @ord_id_HD7D247 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D247, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D247, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D248')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D248', 70000, 'COMPLETED', id, 2, '2026-07-31 13:59:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_id_HD7D248 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D248');
    IF @ord_id_HD7D248 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D248, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D248, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D249')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D249', 50000, 'COMPLETED', id, 1, '2026-07-31 15:12:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_id_HD7D249 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D249');
    IF @ord_id_HD7D249 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D249, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D249, 3, 1, 10000);
    END
END
GO