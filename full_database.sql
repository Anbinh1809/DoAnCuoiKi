-- ============================================================
-- KỊCH BẢN TẠO MỚI TOÀN BỘ CƠ SỞ DỮ LIỆU WEBBANHMI (DÀNH CHO MÁY MỚI)
-- Chạy file này trên SQL Server Management Studio (SSMS)
-- ============================================================

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'webbanhmi')
BEGIN
    ALTER DATABASE webbanhmi SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE webbanhmi;
END
GO

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
GO

-- ============================================================
-- NẠP DỮ LIỆU BAN ĐẦU
-- ============================================================

-- 1. Danh sách Nhân Viên (1 Admin, 5 Staff)
INSERT INTO nhan_vien (ten_dang_nhap, mat_khau, ho_ten, dien_thoai, vai_tro, active) VALUES
('admin',  '123', N'Quản Trị Viên',     '0901234567', 1, 1),
('staff1', '123', N'Đặng Phi Hùng',     '0901000001', 0, 1),
('staff2', '123', N'Lê Bình An',        '0901000002', 0, 1),
('staff3', '123', N'Đinh Ngọc Đại',     '0901000003', 0, 1),
('staff4', '123', N'Đinh Tiến Lộc',     '0901000004', 0, 1),
('staff5', '123', N'Tôn Trần Triệu Vĩ', '0901000005', 0, 1);
GO

-- 2. Phương Thức Thanh Toán
INSERT INTO the_thanh_toan (ten_loai_the, active) VALUES
(N'Tiền mặt', 1),
(N'Chuyển khoản / Momo', 1);
GO

-- 3. Loại Sản Phẩm
INSERT INTO loai_san_pham (ten_loai, active) VALUES
(N'Bánh Mì Thịt', 1),
(N'Bánh Mì Chay / Món Khác', 1),
(N'Đồ Uống', 1);
GO

-- 4. Danh Sách Sản Phẩm (22 sản phẩm)
INSERT INTO san_pham (ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES
(N'Bánh mì thịt nướng', 20000, 'banh-mi-thit-nuong.jpg', N'Bánh mì thịt nướng truyền thống thơm ngon', 1, 1),
(N'Bánh mì xíu mại', 18000, 'banh-mi-xiu-mai.jpg', N'Bánh mì xíu mại đậm đà sốt cà', 1, 1),
(N'Trà tắc giải nhiệt', 10000, 'tra-tac.jpg', N'Trà tắc mát lạnh giải nhiệt mùa hè', 1, 3),
(N'Bánh mì chả lụa', 20000, 'banh-mi-cha-lua.jpg', N'Bánh mì chả lụa pate thơm béo', 1, 1),
(N'Bánh mì gà xé', 22000, 'banh-mi-ga-xe.jpg', N'Bánh mì gà xé phay giòn rụm', 1, 1),
(N'Bánh mì ốp la pate', 18000, 'banh-mi-op-la.jpg', N'Bánh mì ốp la 2 trứng dốt pate', 1, 1),
(N'Bánh mì bò lá lốt', 25000, 'banh-mi-bo-la-lot.jpg', N'Bánh mì bò lá lốt nướng than hồng', 1, 1),
(N'Bánh mì chả cá', 20000, 'banh-mi-cha-ca.jpg', N'Bánh mì chả cá Nha Trang nóng hổi', 1, 1),
(N'Bánh mì đặc biệt', 30000, 'banh-mi-dac-biet.jpg', N'Bánh mì full topping đặc biệt hủ tiếu bánh mì', 1, 1),
(N'Cà phê sữa đá', 15000, 'ca-phe-sua.jpg', N'Cà phê pha phin đậm đà chuẩn vị Việt', 1, 3),
(N'Cà phê đen đá', 12000, 'ca-phe-den.jpg', N'Cà phê đen đá nguyên chất tỉnh táo', 1, 3),
(N'Trà đào cam sả', 20000, 'tra-dao-cam-sa.jpg', N'Trà đào cam sả thơm ngon mọng nước', 1, 3),
(N'Trà sữa truyền thống', 22000, 'tra-sua.jpg', N'Trà sữa nhà làm topping chân trâu', 1, 3),
(N'Nước sâm dứa thạch', 12000, 'nuoc-sam.jpg', N'Nước sâm dứa thạch nhà nấu', 1, 3),
(N'Nước ngọt (Coca/Pepsi)', 12000, 'nuoc-ngot.jpg', N'Nước ngọt lon mát lạnh', 1, 3),
(N'Bánh bao xá xíu', 18000, 'banh-bao-xa-xiu.jpg', N'Bánh bao nhân xá xíu trứng cút', 1, 2),
(N'Bánh bao chay', 12000, 'banh-bao-chay.jpg', N'Bánh bao nấm hạt nêm thanh tịnh', 1, 2),
(N'Há cảo hấp (4 viên)', 20000, 'ha-cao.jpg', N'Há cảo tôm thịt hấp nóng hổi', 1, 2),
(N'Xíu mại chén', 25000, 'xiu-mai-chen.jpg', N'Xíu mại chén chấm bánh mì giòn', 1, 2);
GO

-- 5. Danh Sách Toppings Kho (10 nguyên liệu)
INSERT INTO toppings (ten_nguyen_lieu, gia_cong_them, so_luong_ton, don_vi_tinh, active) VALUES
(N'Trứng ốp la', 5000, 50, N'Quả', 1),
(N'Pate nhà làm', 3000, 50, N'Phần', 1),
(N'Chả lụa thêm', 5000, 50, N'Phần', 1),
(N'Thịt nướng thêm', 8000, 50, N'Phần', 1),
(N'Phô mai Con Bò Cười', 5000, 50, N'Cái', 1),
(N'Bơ béo nhà làm', 3000, 50, N'Muỗng', 1),
(N'Gà xé thêm', 8000, 50, N'Phần', 1),
(N'Xá xíu thêm', 8000, 50, N'Phần', 1),
(N'Xúc xích Đức', 7000, 50, N'Cây', 1),
(N'Kim chi ăn kèm', 4000, 30, N'Hộp', 1);
GO

-- ============================================================
-- DỮ LIỆU MẪU HÓA ĐƠN 7 NGÀY GẦN NHẤT CHO DASHBOARD
-- ============================================================
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D101', 50000, 'COMPLETED', id, 1, DATEADD(minute, -8220, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'admin';

DECLARE @ord_HD7D101 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D101');
IF @ord_HD7D101 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D101, 1, 2, 40000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D101, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D102', 56000, 'COMPLETED', id, 2, DATEADD(minute, -8087, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

DECLARE @ord_HD7D102 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D102');
IF @ord_HD7D102 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D102, 2, 2, 36000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D102, 3, 2, 20000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D103', 70000, 'COMPLETED', id, 1, DATEADD(minute, -7954, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

DECLARE @ord_HD7D103 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D103');
IF @ord_HD7D103 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D103, 1, 3, 60000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D103, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D104', 50000, 'COMPLETED', id, 2, DATEADD(minute, -7821, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

DECLARE @ord_HD7D104 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D104');
IF @ord_HD7D104 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D104, 1, 2, 40000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D104, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D105', 56000, 'COMPLETED', id, 1, DATEADD(minute, -7688, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

DECLARE @ord_HD7D105 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D105');
IF @ord_HD7D105 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D105, 2, 2, 36000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D105, 3, 2, 20000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D106', 70000, 'COMPLETED', id, 2, DATEADD(minute, -7615, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

DECLARE @ord_HD7D106 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D106');
IF @ord_HD7D106 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D106, 1, 3, 60000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D106, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D107', 56000, 'COMPLETED', id, 2, DATEADD(minute, -6591, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'admin';

DECLARE @ord_HD7D107 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D107');
IF @ord_HD7D107 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D107, 2, 2, 36000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D107, 3, 2, 20000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D108', 70000, 'COMPLETED', id, 1, DATEADD(minute, -6458, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

DECLARE @ord_HD7D108 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D108');
IF @ord_HD7D108 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D108, 1, 3, 60000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D108, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D109', 50000, 'COMPLETED', id, 2, DATEADD(minute, -6325, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

DECLARE @ord_HD7D109 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D109');
IF @ord_HD7D109 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D109, 1, 2, 40000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D109, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D110', 56000, 'COMPLETED', id, 1, DATEADD(minute, -6192, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

DECLARE @ord_HD7D110 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D110');
IF @ord_HD7D110 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D110, 2, 2, 36000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D110, 3, 2, 20000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D111', 70000, 'COMPLETED', id, 2, DATEADD(minute, -6779, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

DECLARE @ord_HD7D111 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D111');
IF @ord_HD7D111 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D111, 1, 3, 60000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D111, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D112', 50000, 'COMPLETED', id, 1, DATEADD(minute, -6646, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

DECLARE @ord_HD7D112 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D112');
IF @ord_HD7D112 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D112, 1, 2, 40000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D112, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D113', 70000, 'COMPLETED', id, 1, DATEADD(minute, -4962, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'admin';

DECLARE @ord_HD7D113 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D113');
IF @ord_HD7D113 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D113, 1, 3, 60000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D113, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D114', 50000, 'COMPLETED', id, 2, DATEADD(minute, -4829, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

DECLARE @ord_HD7D114 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D114');
IF @ord_HD7D114 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D114, 1, 2, 40000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D114, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D115', 56000, 'COMPLETED', id, 1, DATEADD(minute, -4696, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

DECLARE @ord_HD7D115 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D115');
IF @ord_HD7D115 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D115, 2, 2, 36000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D115, 3, 2, 20000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D116', 70000, 'COMPLETED', id, 2, DATEADD(minute, -5223, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

DECLARE @ord_HD7D116 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D116');
IF @ord_HD7D116 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D116, 1, 3, 60000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D116, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D117', 50000, 'COMPLETED', id, 1, DATEADD(minute, -5150, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

DECLARE @ord_HD7D117 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D117');
IF @ord_HD7D117 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D117, 1, 2, 40000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D117, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D118', 56000, 'COMPLETED', id, 2, DATEADD(minute, -5017, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

DECLARE @ord_HD7D118 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D118');
IF @ord_HD7D118 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D118, 2, 2, 36000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D118, 3, 2, 20000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D119', 50000, 'COMPLETED', id, 2, DATEADD(minute, -3333, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'admin';

DECLARE @ord_HD7D119 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D119');
IF @ord_HD7D119 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D119, 1, 2, 40000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D119, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D120', 56000, 'COMPLETED', id, 1, DATEADD(minute, -3860, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

DECLARE @ord_HD7D120 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D120');
IF @ord_HD7D120 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D120, 2, 2, 36000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D120, 3, 2, 20000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D121', 70000, 'COMPLETED', id, 2, DATEADD(minute, -3727, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

DECLARE @ord_HD7D121 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D121');
IF @ord_HD7D121 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D121, 1, 3, 60000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D121, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D122', 50000, 'COMPLETED', id, 1, DATEADD(minute, -3654, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

DECLARE @ord_HD7D122 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D122');
IF @ord_HD7D122 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D122, 1, 2, 40000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D122, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D123', 56000, 'COMPLETED', id, 2, DATEADD(minute, -3521, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

DECLARE @ord_HD7D123 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D123');
IF @ord_HD7D123 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D123, 2, 2, 36000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D123, 3, 2, 20000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D124', 70000, 'COMPLETED', id, 1, DATEADD(minute, -3388, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

DECLARE @ord_HD7D124 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D124');
IF @ord_HD7D124 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D124, 1, 3, 60000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D124, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D125', 56000, 'COMPLETED', id, 1, DATEADD(minute, -2364, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'admin';

DECLARE @ord_HD7D125 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D125');
IF @ord_HD7D125 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D125, 2, 2, 36000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D125, 3, 2, 20000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D126', 70000, 'COMPLETED', id, 2, DATEADD(minute, -2231, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

DECLARE @ord_HD7D126 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D126');
IF @ord_HD7D126 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D126, 1, 3, 60000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D126, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D127', 50000, 'COMPLETED', id, 1, DATEADD(minute, -2158, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

DECLARE @ord_HD7D127 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D127');
IF @ord_HD7D127 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D127, 1, 2, 40000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D127, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D128', 56000, 'COMPLETED', id, 2, DATEADD(minute, -2025, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

DECLARE @ord_HD7D128 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D128');
IF @ord_HD7D128 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D128, 2, 2, 36000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D128, 3, 2, 20000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D129', 70000, 'COMPLETED', id, 1, DATEADD(minute, -1892, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

DECLARE @ord_HD7D129 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D129');
IF @ord_HD7D129 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D129, 1, 3, 60000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D129, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D130', 50000, 'COMPLETED', id, 2, DATEADD(minute, -2419, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

DECLARE @ord_HD7D130 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D130');
IF @ord_HD7D130 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D130, 1, 2, 40000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D130, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D131', 70000, 'COMPLETED', id, 2, DATEADD(minute, -735, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'admin';

DECLARE @ord_HD7D131 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D131');
IF @ord_HD7D131 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D131, 1, 3, 60000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D131, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D132', 50000, 'COMPLETED', id, 1, DATEADD(minute, -602, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

DECLARE @ord_HD7D132 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D132');
IF @ord_HD7D132 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D132, 1, 2, 40000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D132, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D133', 56000, 'COMPLETED', id, 2, DATEADD(minute, -529, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

DECLARE @ord_HD7D133 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D133');
IF @ord_HD7D133 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D133, 2, 2, 36000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D133, 3, 2, 20000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D134', 70000, 'COMPLETED', id, 1, DATEADD(minute, -396, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

DECLARE @ord_HD7D134 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D134');
IF @ord_HD7D134 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D134, 1, 3, 60000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D134, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D135', 50000, 'COMPLETED', id, 2, DATEADD(minute, -923, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

DECLARE @ord_HD7D135 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D135');
IF @ord_HD7D135 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D135, 1, 2, 40000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D135, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D136', 56000, 'COMPLETED', id, 1, DATEADD(minute, -790, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

DECLARE @ord_HD7D136 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D136');
IF @ord_HD7D136 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D136, 2, 2, 36000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D136, 3, 2, 20000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D137', 50000, 'COMPLETED', id, 1, DATEADD(minute, 894, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'admin';

DECLARE @ord_HD7D137 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D137');
IF @ord_HD7D137 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D137, 1, 2, 40000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D137, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D138', 56000, 'COMPLETED', id, 2, DATEADD(minute, 967, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

DECLARE @ord_HD7D138 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D138');
IF @ord_HD7D138 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D138, 2, 2, 36000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D138, 3, 2, 20000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D139', 70000, 'COMPLETED', id, 1, DATEADD(minute, 440, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

DECLARE @ord_HD7D139 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D139');
IF @ord_HD7D139 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D139, 1, 3, 60000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D139, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D140', 50000, 'COMPLETED', id, 2, DATEADD(minute, 573, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

DECLARE @ord_HD7D140 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D140');
IF @ord_HD7D140 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D140, 1, 2, 40000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D140, 3, 1, 10000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D141', 56000, 'COMPLETED', id, 1, DATEADD(minute, 706, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

DECLARE @ord_HD7D141 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D141');
IF @ord_HD7D141 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D141, 2, 2, 36000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D141, 3, 2, 20000);
END
GO
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'HD7D142', 70000, 'COMPLETED', id, 2, DATEADD(minute, 839, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

DECLARE @ord_HD7D142 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D142');
IF @ord_HD7D142 IS NOT NULL
BEGIN
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D142, 1, 3, 60000);
    INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HD7D142, 3, 1, 10000);
END
GO

PRINT N'Tạo mới toàn bộ CSDL webbanhmi thành công!';
GO
