-- Tạo database
CREATE DATABASE webbanhmi;
GO

USE webbanhmi;
GO

-- 1. Bảng nhân viên (nhan_vien)
CREATE TABLE nhan_vien (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_dang_nhap VARCHAR(100) UNIQUE NOT NULL,
    mat_khau VARCHAR(255) NOT NULL,
    ho_ten NVARCHAR(100) NOT NULL,
    dien_thoai VARCHAR(15) UNIQUE,
    vai_tro BIT NOT NULL DEFAULT 0, -- 1 = admin, 0 = staff
    active BIT NOT NULL DEFAULT 1
);

-- 2. Bảng loại sản phẩm (loai_san_pham)
CREATE TABLE loai_san_pham (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_loai NVARCHAR(250) NOT NULL,
    active BIT NOT NULL DEFAULT 1
);

-- 3. Bảng sản phẩm (san_pham)
CREATE TABLE san_pham (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_sp NVARCHAR(250) NOT NULL,
    gia_co_ban INT NOT NULL,
    anh_sp NVARCHAR(250),
    mo_ta NVARCHAR(MAX),
    active BIT NOT NULL DEFAULT 1,
    id_loai_sp INT NOT NULL,
    CONSTRAINT FK_SanPham_LoaiSanPham FOREIGN KEY (id_loai_sp) REFERENCES loai_san_pham(id)
);

-- 4. Bảng toppings
CREATE TABLE toppings (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_nguyen_lieu NVARCHAR(250) NOT NULL,
    gia_cong_them INT NOT NULL DEFAULT 0,
    so_luong_ton INT NOT NULL DEFAULT 50,
    don_vi_tinh NVARCHAR(50) NOT NULL DEFAULT N'Phần',
    active BIT NOT NULL DEFAULT 1
);

-- 5. Bảng thẻ thanh toán (the_thanh_toan)
CREATE TABLE the_thanh_toan (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ten_loai_the NVARCHAR(100) NOT NULL,
    active BIT NOT NULL DEFAULT 1
);

-- 6. Bảng đơn hàng (don_hang)
CREATE TABLE don_hang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    ma_so_don_hang VARCHAR(10) UNIQUE NOT NULL,
    ngay_tao DATETIME NOT NULL DEFAULT GETDATE(),
    tong_tien INT NOT NULL DEFAULT 0,
    trang_thai VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    id_nhan_vien INT NOT NULL,
    id_the INT,
    CONSTRAINT FK_DonHang_NhanVien FOREIGN KEY (id_nhan_vien) REFERENCES nhan_vien(id),
    CONSTRAINT FK_DonHang_TheThanhToan FOREIGN KEY (id_the) REFERENCES the_thanh_toan(id)
);

-- 7. Bảng chi tiết đơn hàng (chi_tiet_don_hang)
CREATE TABLE chi_tiet_don_hang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    so_luong INT NOT NULL DEFAULT 1,
    gia_ban INT NOT NULL,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    CONSTRAINT FK_ChiTietDonHang_DonHang FOREIGN KEY (order_id) REFERENCES don_hang(id),
    CONSTRAINT FK_ChiTietDonHang_SanPham FOREIGN KEY (product_id) REFERENCES san_pham(id)
);

-- 8. Bảng chi tiết topping đơn hàng (chi_tiet_topping_don_hang)
CREATE TABLE chi_tiet_topping_don_hang (
    id INT IDENTITY(1,1) PRIMARY KEY,
    so_luong INT NOT NULL DEFAULT 1,
    order_item_id INT NOT NULL,
    topping_id INT NOT NULL,
    CONSTRAINT FK_ToppingDonHang_ChiTietDonHang FOREIGN KEY (order_item_id) REFERENCES chi_tiet_don_hang(id),
    CONSTRAINT FK_ToppingDonHang_Toppings FOREIGN KEY (topping_id) REFERENCES toppings(id)
);

-- Chèn dữ liệu mẫu
INSERT INTO nhan_vien (ten_dang_nhap, mat_khau, ho_ten, dien_thoai, vai_tro, active)
VALUES ('admin', '123', N'Quản Trị Viên', '0901234567', 1, 1),
       ('staff', '123', N'Nhân Viên Bán Hàng', '0907654321', 0, 1);

INSERT INTO the_thanh_toan (ten_loai_the, active)
VALUES (N'Tiền mặt', 1), (N'Chuyển khoản / Momo', 1);

INSERT INTO loai_san_pham (ten_loai, active)
VALUES (N'Bánh Mì Thịt', 1), (N'Bánh Mì Chay', 1), (N'Đồ Uống', 1);

INSERT INTO san_pham (ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp)
VALUES (N'Bánh mì thịt nướng', 20000, 'banh-mi-thit-nuong.jpg', N'Bánh mì thịt nướng truyền thống', 1, 1),
       (N'Bánh mì xíu mại', 18000, 'banh-mi-xiu-mai.jpg', N'Bánh mì xíu mại thơm ngon', 1, 1),
       (N'Trà tắc', 10000, 'tra-tac.jpg', N'Trà tắc giải nhiệt', 1, 3);

INSERT INTO toppings (ten_nguyen_lieu, gia_cong_them, active)
VALUES (N'Trứng ốp la', 5000, 1),
       (N'Pate', 3000, 1),
       (N'Chả lụa', 5000, 1),
       (N'Thịt nướng thêm', 8000, 1);
-- ============================================================
-- Script sửa dữ liệu hóa đơn bị lưu tong_tien = 0
-- Chạy trong SQL Server Management Studio (SSMS)
-- ============================================================

USE webbanhmi;
GO

-- Bước 1: Xem tổng tiền thực tế từ chi_tiet_don_hang
SELECT
    dh.id,
    dh.ma_so_don_hang,
    dh.tong_tien AS tong_tien_cu,
    ISNULL(SUM(ct.gia_ban), 0) AS tong_tien_thuc_te
FROM don_hang dh
LEFT JOIN chi_tiet_don_hang ct ON ct.order_id = dh.id
GROUP BY dh.id, dh.ma_so_don_hang, dh.tong_tien
ORDER BY dh.id;
GO

-- Bước 2: Cập nhật tong_tien cho những hóa đơn bị = 0
--         nhưng CÓ dữ liệu trong chi_tiet_don_hang
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

-- Bước 3: Kiểm tra lại sau khi update
SELECT
    dh.id,
    dh.ma_so_don_hang,
    dh.tong_tien,
    dh.trang_thai,
    nv.ho_ten AS nhan_vien,
    ttt.ten_loai_the AS thanh_toan
FROM don_hang dh
LEFT JOIN nhan_vien nv ON dh.id_nhan_vien = nv.id
LEFT JOIN the_thanh_toan ttt ON dh.id_the = ttt.id
ORDER BY dh.ngay_tao DESC;
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