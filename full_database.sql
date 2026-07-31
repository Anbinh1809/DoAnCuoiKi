-- ============================================================
-- CƠ SỞ DỮ LIỆU SINGLE MASTER FILE DỰ ÁN WEBBANHMI
-- ĐƯỢC XUẤT TRỰC TIẾP TỪ CSDL ĐANG CHẠY CỦA HỆ THỐNG
-- Chạy file này trên SQL Server Management Studio (SSMS)
-- ============================================================

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'webbanhmi')
BEGIN
    CREATE DATABASE webbanhmi;
    PRINT N'Đã tạo CSDL webbanhmi.';
END
GO

USE webbanhmi;
GO

-- 1. Bảng nhân viên (nhan_vien)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'nhan_vien')
BEGIN
    CREATE TABLE nhan_vien (
        id INT IDENTITY(1,1) PRIMARY KEY,
        ten_dang_nhap VARCHAR(100) UNIQUE NOT NULL,
        mat_khau VARCHAR(255) NOT NULL,
        ho_ten NVARCHAR(100) NOT NULL,
        dien_thoai VARCHAR(15) UNIQUE,
        vai_tro BIT NOT NULL DEFAULT 0, -- 1 = admin, 0 = staff
        active BIT NOT NULL DEFAULT 1
    );
END
GO

-- 2. Bảng loại sản phẩm (loai_san_pham)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'loai_san_pham')
BEGIN
    CREATE TABLE loai_san_pham (
        id INT IDENTITY(1,1) PRIMARY KEY,
        ten_loai NVARCHAR(250) NOT NULL,
        active BIT NOT NULL DEFAULT 1
    );
END
GO

-- 3. Bảng sản phẩm (san_pham)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'san_pham')
BEGIN
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
END
GO

-- 4. Bảng toppings
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'toppings')
BEGIN
    CREATE TABLE toppings (
        id INT IDENTITY(1,1) PRIMARY KEY,
        ten_nguyen_lieu NVARCHAR(250) NOT NULL,
        gia_cong_them INT NOT NULL DEFAULT 0,
        so_luong_ton INT NOT NULL DEFAULT 50,
        don_vi_tinh NVARCHAR(50) NOT NULL DEFAULT N'Phần',
        active BIT NOT NULL DEFAULT 1
    );
END
ELSE
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('toppings') AND name = 'so_luong_ton')
        ALTER TABLE toppings ADD so_luong_ton INT NOT NULL DEFAULT 50;
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('toppings') AND name = 'don_vi_tinh')
        ALTER TABLE toppings ADD don_vi_tinh NVARCHAR(50) NOT NULL DEFAULT N'Phần';
END
GO

-- 5. Bảng thẻ thanh toán (the_thanh_toan)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'the_thanh_toan')
BEGIN
    CREATE TABLE the_thanh_toan (
        id INT IDENTITY(1,1) PRIMARY KEY,
        ten_loai_the NVARCHAR(100) NOT NULL,
        active BIT NOT NULL DEFAULT 1
    );
END
GO

-- 6. Bảng đơn hàng (don_hang)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'don_hang')
BEGIN
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
END
GO

-- 7. Bảng chi tiết đơn hàng (chi_tiet_don_hang)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'chi_tiet_don_hang')
BEGIN
    CREATE TABLE chi_tiet_don_hang (
        id INT IDENTITY(1,1) PRIMARY KEY,
        so_luong INT NOT NULL DEFAULT 1,
        gia_ban INT NOT NULL,
        order_id INT NOT NULL,
        product_id INT NOT NULL,
        CONSTRAINT FK_ChiTietDonHang_DonHang FOREIGN KEY (order_id) REFERENCES don_hang(id),
        CONSTRAINT FK_ChiTietDonHang_SanPham FOREIGN KEY (product_id) REFERENCES san_pham(id)
    );
END
GO

-- 8. Bảng chi tiết topping đơn hàng (chi_tiet_topping_don_hang)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'chi_tiet_topping_don_hang')
BEGIN
    CREATE TABLE chi_tiet_topping_don_hang (
        id INT IDENTITY(1,1) PRIMARY KEY,
        so_luong INT NOT NULL DEFAULT 1,
        order_item_id INT NOT NULL,
        topping_id INT NOT NULL,
        CONSTRAINT FK_ToppingDonHang_ChiTietDonHang FOREIGN KEY (order_item_id) REFERENCES chi_tiet_don_hang(id),
        CONSTRAINT FK_ToppingDonHang_Toppings FOREIGN KEY (topping_id) REFERENCES toppings(id)
    );
END
GO

-- ============================================================
-- DỮ LIỆU THỰC TẾ ĐƯỢC ĐỒNG BỘ TỪ CSDL ĐANG CHẠY
-- ============================================================

SET IDENTITY_INSERT nhan_vien ON;
IF NOT EXISTS (SELECT 1 FROM nhan_vien WHERE id = 1) INSERT INTO nhan_vien(id, ten_dang_nhap, mat_khau, ho_ten, dien_thoai, vai_tro, active) VALUES (1, N'admin', N'123', N'Quản Trị Viên', N'0901234567', 1, 1) ELSE UPDATE nhan_vien SET ten_dang_nhap=N'admin', mat_khau=N'123', ho_ten=N'Quản Trị Viên', dien_thoai=N'0901234567', vai_tro=1, active=1 WHERE id=1;
IF NOT EXISTS (SELECT 1 FROM nhan_vien WHERE id = 2) INSERT INTO nhan_vien(id, ten_dang_nhap, mat_khau, ho_ten, dien_thoai, vai_tro, active) VALUES (2, N'staff1', N'123', N'Đặng Phi Hùng', N'0901000001', 0, 1) ELSE UPDATE nhan_vien SET ten_dang_nhap=N'staff1', mat_khau=N'123', ho_ten=N'Đặng Phi Hùng', dien_thoai=N'0901000001', vai_tro=0, active=1 WHERE id=2;
IF NOT EXISTS (SELECT 1 FROM nhan_vien WHERE id = 3) INSERT INTO nhan_vien(id, ten_dang_nhap, mat_khau, ho_ten, dien_thoai, vai_tro, active) VALUES (3, N'staff2', N'123', N'Lê Bình An', N'0901000002', 0, 1) ELSE UPDATE nhan_vien SET ten_dang_nhap=N'staff2', mat_khau=N'123', ho_ten=N'Lê Bình An', dien_thoai=N'0901000002', vai_tro=0, active=1 WHERE id=3;
IF NOT EXISTS (SELECT 1 FROM nhan_vien WHERE id = 4) INSERT INTO nhan_vien(id, ten_dang_nhap, mat_khau, ho_ten, dien_thoai, vai_tro, active) VALUES (4, N'staff3', N'123', N'Đinh Ngọc Đại', N'0901000003', 0, 1) ELSE UPDATE nhan_vien SET ten_dang_nhap=N'staff3', mat_khau=N'123', ho_ten=N'Đinh Ngọc Đại', dien_thoai=N'0901000003', vai_tro=0, active=1 WHERE id=4;
IF NOT EXISTS (SELECT 1 FROM nhan_vien WHERE id = 5) INSERT INTO nhan_vien(id, ten_dang_nhap, mat_khau, ho_ten, dien_thoai, vai_tro, active) VALUES (5, N'staff4', N'123', N'Đinh Tiến Lộc', N'0901000004', 0, 1) ELSE UPDATE nhan_vien SET ten_dang_nhap=N'staff4', mat_khau=N'123', ho_ten=N'Đinh Tiến Lộc', dien_thoai=N'0901000004', vai_tro=0, active=1 WHERE id=5;
IF NOT EXISTS (SELECT 1 FROM nhan_vien WHERE id = 6) INSERT INTO nhan_vien(id, ten_dang_nhap, mat_khau, ho_ten, dien_thoai, vai_tro, active) VALUES (6, N'staff5', N'123', N'Tôn Trần Triệu Vĩ', N'0901000005', 0, 1) ELSE UPDATE nhan_vien SET ten_dang_nhap=N'staff5', mat_khau=N'123', ho_ten=N'Tôn Trần Triệu Vĩ', dien_thoai=N'0901000005', vai_tro=0, active=1 WHERE id=6;
SET IDENTITY_INSERT nhan_vien OFF;
GO

SET IDENTITY_INSERT the_thanh_toan ON;
IF NOT EXISTS (SELECT 1 FROM the_thanh_toan WHERE id = 1) INSERT INTO the_thanh_toan(id, ten_loai_the, active) VALUES (1, N'Tiền mặt', 1) ELSE UPDATE the_thanh_toan SET ten_loai_the=N'Tiền mặt', active=1 WHERE id=1;
IF NOT EXISTS (SELECT 1 FROM the_thanh_toan WHERE id = 2) INSERT INTO the_thanh_toan(id, ten_loai_the, active) VALUES (2, N'Chuyển khoản / Momo', 1) ELSE UPDATE the_thanh_toan SET ten_loai_the=N'Chuyển khoản / Momo', active=1 WHERE id=2;
SET IDENTITY_INSERT the_thanh_toan OFF;
GO

SET IDENTITY_INSERT loai_san_pham ON;
IF NOT EXISTS (SELECT 1 FROM loai_san_pham WHERE id = 1) INSERT INTO loai_san_pham(id, ten_loai, active) VALUES (1, N'Bánh Mì Thịt', 1) ELSE UPDATE loai_san_pham SET ten_loai=N'Bánh Mì Thịt', active=1 WHERE id=1;
IF NOT EXISTS (SELECT 1 FROM loai_san_pham WHERE id = 2) INSERT INTO loai_san_pham(id, ten_loai, active) VALUES (2, N'Bánh Mì Chay / Món Khác', 1) ELSE UPDATE loai_san_pham SET ten_loai=N'Bánh Mì Chay / Món Khác', active=1 WHERE id=2;
IF NOT EXISTS (SELECT 1 FROM loai_san_pham WHERE id = 3) INSERT INTO loai_san_pham(id, ten_loai, active) VALUES (3, N'Đồ Uống', 1) ELSE UPDATE loai_san_pham SET ten_loai=N'Đồ Uống', active=1 WHERE id=3;
SET IDENTITY_INSERT loai_san_pham OFF;
GO

SET IDENTITY_INSERT san_pham ON;
IF NOT EXISTS (SELECT 1 FROM san_pham WHERE id = 1) INSERT INTO san_pham(id, ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (1, N'Bánh mì thịt nướng', 20000, N'banh-mi-thit-nuong.jpg', N'Bánh mì thịt nướng truyền thống thơm ngon', 1, 1) ELSE UPDATE san_pham SET ten_sp=N'Bánh mì thịt nướng', gia_co_ban=20000, anh_sp=N'banh-mi-thit-nuong.jpg', mo_ta=N'Bánh mì thịt nướng truyền thống thơm ngon', active=1, id_loai_sp=1 WHERE id=1;
IF NOT EXISTS (SELECT 1 FROM san_pham WHERE id = 2) INSERT INTO san_pham(id, ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (2, N'Bánh mì xíu mại', 18000, N'banh-mi-xiu-mai.jpg', N'Bánh mì xíu mại đậm đà sốt cà', 1, 1) ELSE UPDATE san_pham SET ten_sp=N'Bánh mì xíu mại', gia_co_ban=18000, anh_sp=N'banh-mi-xiu-mai.jpg', mo_ta=N'Bánh mì xíu mại đậm đà sốt cà', active=1, id_loai_sp=1 WHERE id=2;
IF NOT EXISTS (SELECT 1 FROM san_pham WHERE id = 3) INSERT INTO san_pham(id, ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (3, N'Trà tắc giải nhiệt', 10000, N'tra-tac.jpg', N'Trà tắc mát lạnh giải nhiệt mùa hè', 1, 3) ELSE UPDATE san_pham SET ten_sp=N'Trà tắc giải nhiệt', gia_co_ban=10000, anh_sp=N'tra-tac.jpg', mo_ta=N'Trà tắc mát lạnh giải nhiệt mùa hè', active=1, id_loai_sp=3 WHERE id=3;
IF NOT EXISTS (SELECT 1 FROM san_pham WHERE id = 4) INSERT INTO san_pham(id, ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (4, N'Bánh mì chả lụa', 20000, N'banh-mi-cha-lua.jpg', N'Bánh mì chả lụa pate thơm béo', 1, 1) ELSE UPDATE san_pham SET ten_sp=N'Bánh mì chả lụa', gia_co_ban=20000, anh_sp=N'banh-mi-cha-lua.jpg', mo_ta=N'Bánh mì chả lụa pate thơm béo', active=1, id_loai_sp=1 WHERE id=4;
IF NOT EXISTS (SELECT 1 FROM san_pham WHERE id = 5) INSERT INTO san_pham(id, ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (5, N'Bánh mì gà xé', 22000, N'banh-mi-ga-xe.jpg', N'Bánh mì gà xé phay giòn rụm', 1, 1) ELSE UPDATE san_pham SET ten_sp=N'Bánh mì gà xé', gia_co_ban=22000, anh_sp=N'banh-mi-ga-xe.jpg', mo_ta=N'Bánh mì gà xé phay giòn rụm', active=1, id_loai_sp=1 WHERE id=5;
IF NOT EXISTS (SELECT 1 FROM san_pham WHERE id = 6) INSERT INTO san_pham(id, ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (6, N'Bánh mì ốp la pate', 18000, N'banh-mi-op-la.jpg', N'Bánh mì ốp la 2 trứng dốt pate', 1, 1) ELSE UPDATE san_pham SET ten_sp=N'Bánh mì ốp la pate', gia_co_ban=18000, anh_sp=N'banh-mi-op-la.jpg', mo_ta=N'Bánh mì ốp la 2 trứng dốt pate', active=1, id_loai_sp=1 WHERE id=6;
IF NOT EXISTS (SELECT 1 FROM san_pham WHERE id = 7) INSERT INTO san_pham(id, ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (7, N'Bánh mì bò lá lốt', 25000, N'banh-mi-bo-la-lot.jpg', N'Bánh mì bò lá lốt nướng than hồng', 1, 1) ELSE UPDATE san_pham SET ten_sp=N'Bánh mì bò lá lốt', gia_co_ban=25000, anh_sp=N'banh-mi-bo-la-lot.jpg', mo_ta=N'Bánh mì bò lá lốt nướng than hồng', active=1, id_loai_sp=1 WHERE id=7;
IF NOT EXISTS (SELECT 1 FROM san_pham WHERE id = 8) INSERT INTO san_pham(id, ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (8, N'Bánh mì chả cá', 20000, N'banh-mi-cha-ca.jpg', N'Bánh mì chả cá Nha Trang nóng hổi', 1, 1) ELSE UPDATE san_pham SET ten_sp=N'Bánh mì chả cá', gia_co_ban=20000, anh_sp=N'banh-mi-cha-ca.jpg', mo_ta=N'Bánh mì chả cá Nha Trang nóng hổi', active=1, id_loai_sp=1 WHERE id=8;
IF NOT EXISTS (SELECT 1 FROM san_pham WHERE id = 9) INSERT INTO san_pham(id, ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (9, N'Bánh mì đặc biệt', 30000, N'banh-mi-dac-biet.jpg', N'Bánh mì full topping đặc biệt hủ tiếu bánh mì', 1, 1) ELSE UPDATE san_pham SET ten_sp=N'Bánh mì đặc biệt', gia_co_ban=30000, anh_sp=N'banh-mi-dac-biet.jpg', mo_ta=N'Bánh mì full topping đặc biệt hủ tiếu bánh mì', active=1, id_loai_sp=1 WHERE id=9;
IF NOT EXISTS (SELECT 1 FROM san_pham WHERE id = 10) INSERT INTO san_pham(id, ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (10, N'Cà phê sữa đá', 15000, N'ca-phe-sua.jpg', N'Cà phê pha phin đậm đà chuẩn vị Việt', 1, 3) ELSE UPDATE san_pham SET ten_sp=N'Cà phê sữa đá', gia_co_ban=15000, anh_sp=N'ca-phe-sua.jpg', mo_ta=N'Cà phê pha phin đậm đà chuẩn vị Việt', active=1, id_loai_sp=3 WHERE id=10;
IF NOT EXISTS (SELECT 1 FROM san_pham WHERE id = 11) INSERT INTO san_pham(id, ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (11, N'Cà phê đen đá', 12000, N'ca-phe-den.jpg', N'Cà phê đen đá nguyên chất tỉnh táo', 1, 3) ELSE UPDATE san_pham SET ten_sp=N'Cà phê đen đá', gia_co_ban=12000, anh_sp=N'ca-phe-den.jpg', mo_ta=N'Cà phê đen đá nguyên chất tỉnh táo', active=1, id_loai_sp=3 WHERE id=11;
IF NOT EXISTS (SELECT 1 FROM san_pham WHERE id = 12) INSERT INTO san_pham(id, ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (12, N'Trà đào cam sả', 20000, N'tra-dao-cam-sa.jpg', N'Trà đào cam sả thơm ngon mọng nước', 1, 3) ELSE UPDATE san_pham SET ten_sp=N'Trà đào cam sả', gia_co_ban=20000, anh_sp=N'tra-dao-cam-sa.jpg', mo_ta=N'Trà đào cam sả thơm ngon mọng nước', active=1, id_loai_sp=3 WHERE id=12;
IF NOT EXISTS (SELECT 1 FROM san_pham WHERE id = 13) INSERT INTO san_pham(id, ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (13, N'Trà sữa truyền thống', 22000, N'tra-sua.jpg', N'Trà sữa nhà làm topping chân trâu', 1, 3) ELSE UPDATE san_pham SET ten_sp=N'Trà sữa truyền thống', gia_co_ban=22000, anh_sp=N'tra-sua.jpg', mo_ta=N'Trà sữa nhà làm topping chân trâu', active=1, id_loai_sp=3 WHERE id=13;
IF NOT EXISTS (SELECT 1 FROM san_pham WHERE id = 14) INSERT INTO san_pham(id, ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (14, N'Nước sâm dứa thạch', 12000, N'nuoc-sam.jpg', N'Nước sâm dứa thạch nhà nấu', 1, 3) ELSE UPDATE san_pham SET ten_sp=N'Nước sâm dứa thạch', gia_co_ban=12000, anh_sp=N'nuoc-sam.jpg', mo_ta=N'Nước sâm dứa thạch nhà nấu', active=1, id_loai_sp=3 WHERE id=14;
IF NOT EXISTS (SELECT 1 FROM san_pham WHERE id = 15) INSERT INTO san_pham(id, ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (15, N'Nước ngọt (Coca/Pepsi)', 12000, N'nuoc-ngot.jpg', N'Nước ngọt lon mát lạnh', 1, 3) ELSE UPDATE san_pham SET ten_sp=N'Nước ngọt (Coca/Pepsi)', gia_co_ban=12000, anh_sp=N'nuoc-ngot.jpg', mo_ta=N'Nước ngọt lon mát lạnh', active=1, id_loai_sp=3 WHERE id=15;
IF NOT EXISTS (SELECT 1 FROM san_pham WHERE id = 16) INSERT INTO san_pham(id, ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (16, N'Bánh bao xá xíu', 18000, N'banh-bao-xa-xiu.jpg', N'Bánh bao nhân xá xíu trứng cút', 1, 2) ELSE UPDATE san_pham SET ten_sp=N'Bánh bao xá xíu', gia_co_ban=18000, anh_sp=N'banh-bao-xa-xiu.jpg', mo_ta=N'Bánh bao nhân xá xíu trứng cút', active=1, id_loai_sp=2 WHERE id=16;
IF NOT EXISTS (SELECT 1 FROM san_pham WHERE id = 17) INSERT INTO san_pham(id, ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (17, N'Bánh bao chay', 12000, N'banh-bao-chay.jpg', N'Bánh bao nấm hạt nêm thanh tịnh', 1, 2) ELSE UPDATE san_pham SET ten_sp=N'Bánh bao chay', gia_co_ban=12000, anh_sp=N'banh-bao-chay.jpg', mo_ta=N'Bánh bao nấm hạt nêm thanh tịnh', active=1, id_loai_sp=2 WHERE id=17;
IF NOT EXISTS (SELECT 1 FROM san_pham WHERE id = 18) INSERT INTO san_pham(id, ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (18, N'Há cảo hấp (4 viên)', 20000, N'ha-cao.jpg', N'Há cảo tôm thịt hấp nóng hổi', 1, 2) ELSE UPDATE san_pham SET ten_sp=N'Há cảo hấp (4 viên)', gia_co_ban=20000, anh_sp=N'ha-cao.jpg', mo_ta=N'Há cảo tôm thịt hấp nóng hổi', active=1, id_loai_sp=2 WHERE id=18;
IF NOT EXISTS (SELECT 1 FROM san_pham WHERE id = 19) INSERT INTO san_pham(id, ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (19, N'Xíu mại chén', 25000, N'xiu-mai-chen.jpg', N'Xíu mại chén chấm bánh mì giòn', 1, 2) ELSE UPDATE san_pham SET ten_sp=N'Xíu mại chén', gia_co_ban=25000, anh_sp=N'xiu-mai-chen.jpg', mo_ta=N'Xíu mại chén chấm bánh mì giòn', active=1, id_loai_sp=2 WHERE id=19;
SET IDENTITY_INSERT san_pham OFF;
GO

SET IDENTITY_INSERT toppings ON;
IF NOT EXISTS (SELECT 1 FROM toppings WHERE id = 1) INSERT INTO toppings(id, ten_nguyen_lieu, gia_cong_them, so_luong_ton, don_vi_tinh, active) VALUES (1, N'Trứng ốp la', 5000, 50, N'Quả', 1) ELSE UPDATE toppings SET ten_nguyen_lieu=N'Trứng ốp la', gia_cong_them=5000, so_luong_ton=50, don_vi_tinh=N'Quả', active=1 WHERE id=1;
IF NOT EXISTS (SELECT 1 FROM toppings WHERE id = 2) INSERT INTO toppings(id, ten_nguyen_lieu, gia_cong_them, so_luong_ton, don_vi_tinh, active) VALUES (2, N'Pate nhà làm', 3000, 50, N'Phần', 1) ELSE UPDATE toppings SET ten_nguyen_lieu=N'Pate nhà làm', gia_cong_them=3000, so_luong_ton=50, don_vi_tinh=N'Phần', active=1 WHERE id=2;
IF NOT EXISTS (SELECT 1 FROM toppings WHERE id = 3) INSERT INTO toppings(id, ten_nguyen_lieu, gia_cong_them, so_luong_ton, don_vi_tinh, active) VALUES (3, N'Chả lụa thêm', 5000, 50, N'Phần', 1) ELSE UPDATE toppings SET ten_nguyen_lieu=N'Chả lụa thêm', gia_cong_them=5000, so_luong_ton=50, don_vi_tinh=N'Phần', active=1 WHERE id=3;
IF NOT EXISTS (SELECT 1 FROM toppings WHERE id = 4) INSERT INTO toppings(id, ten_nguyen_lieu, gia_cong_them, so_luong_ton, don_vi_tinh, active) VALUES (4, N'Thịt nướng thêm', 8000, 50, N'Phần', 1) ELSE UPDATE toppings SET ten_nguyen_lieu=N'Thịt nướng thêm', gia_cong_them=8000, so_luong_ton=50, don_vi_tinh=N'Phần', active=1 WHERE id=4;
IF NOT EXISTS (SELECT 1 FROM toppings WHERE id = 5) INSERT INTO toppings(id, ten_nguyen_lieu, gia_cong_them, so_luong_ton, don_vi_tinh, active) VALUES (5, N'Phô mai Con Bò Cười', 5000, 50, N'Cái', 1) ELSE UPDATE toppings SET ten_nguyen_lieu=N'Phô mai Con Bò Cười', gia_cong_them=5000, so_luong_ton=50, don_vi_tinh=N'Cái', active=1 WHERE id=5;
IF NOT EXISTS (SELECT 1 FROM toppings WHERE id = 6) INSERT INTO toppings(id, ten_nguyen_lieu, gia_cong_them, so_luong_ton, don_vi_tinh, active) VALUES (6, N'Bơ béo nhà làm', 3000, 50, N'Muỗng', 1) ELSE UPDATE toppings SET ten_nguyen_lieu=N'Bơ béo nhà làm', gia_cong_them=3000, so_luong_ton=50, don_vi_tinh=N'Muỗng', active=1 WHERE id=6;
IF NOT EXISTS (SELECT 1 FROM toppings WHERE id = 7) INSERT INTO toppings(id, ten_nguyen_lieu, gia_cong_them, so_luong_ton, don_vi_tinh, active) VALUES (7, N'Gà xé thêm', 8000, 50, N'Phần', 1) ELSE UPDATE toppings SET ten_nguyen_lieu=N'Gà xé thêm', gia_cong_them=8000, so_luong_ton=50, don_vi_tinh=N'Phần', active=1 WHERE id=7;
IF NOT EXISTS (SELECT 1 FROM toppings WHERE id = 8) INSERT INTO toppings(id, ten_nguyen_lieu, gia_cong_them, so_luong_ton, don_vi_tinh, active) VALUES (8, N'Xá xíu thêm', 8000, 50, N'Phần', 1) ELSE UPDATE toppings SET ten_nguyen_lieu=N'Xá xíu thêm', gia_cong_them=8000, so_luong_ton=50, don_vi_tinh=N'Phần', active=1 WHERE id=8;
IF NOT EXISTS (SELECT 1 FROM toppings WHERE id = 9) INSERT INTO toppings(id, ten_nguyen_lieu, gia_cong_them, so_luong_ton, don_vi_tinh, active) VALUES (9, N'Xúc xích Đức', 7000, 50, N'Cây', 1) ELSE UPDATE toppings SET ten_nguyen_lieu=N'Xúc xích Đức', gia_cong_them=7000, so_luong_ton=50, don_vi_tinh=N'Cây', active=1 WHERE id=9;
IF NOT EXISTS (SELECT 1 FROM toppings WHERE id = 10) INSERT INTO toppings(id, ten_nguyen_lieu, gia_cong_them, so_luong_ton, don_vi_tinh, active) VALUES (10, N'Kim chi ăn kèm', 4000, 30, N'Hộp', 1) ELSE UPDATE toppings SET ten_nguyen_lieu=N'Kim chi ăn kèm', gia_cong_them=4000, so_luong_ton=30, don_vi_tinh=N'Hộp', active=1 WHERE id=10;
SET IDENTITY_INSERT toppings OFF;
GO

SET IDENTITY_INSERT don_hang ON;
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 1) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (1, N'HD7D101', N'2026-07-25T07:00:00', 50000, N'COMPLETED', 1, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 2) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (2, N'HD7D102', N'2026-07-25T09:13:00', 56000, N'COMPLETED', 2, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 3) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (3, N'HD7D103', N'2026-07-25T11:26:00', 70000, N'COMPLETED', 3, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 4) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (4, N'HD7D104', N'2026-07-25T13:39:00', 50000, N'COMPLETED', 4, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 5) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (5, N'HD7D105', N'2026-07-25T15:52:00', 56000, N'COMPLETED', 5, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 6) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (6, N'HD7D106', N'2026-07-25T17:05:00', 70000, N'COMPLETED', 6, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 7) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (7, N'HD7D107', N'2026-07-26T10:09:00', 56000, N'COMPLETED', 1, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 8) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (8, N'HD7D108', N'2026-07-26T12:22:00', 70000, N'COMPLETED', 2, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 9) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (9, N'HD7D109', N'2026-07-26T14:35:00', 50000, N'COMPLETED', 3, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 10) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (10, N'HD7D110', N'2026-07-26T16:48:00', 56000, N'COMPLETED', 4, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 11) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (11, N'HD7D111', N'2026-07-26T07:01:00', 70000, N'COMPLETED', 5, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 12) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (12, N'HD7D112', N'2026-07-26T09:14:00', 50000, N'COMPLETED', 6, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 13) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (13, N'HD7D113', N'2026-07-27T13:18:00', 70000, N'COMPLETED', 1, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 14) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (14, N'HD7D114', N'2026-07-27T15:31:00', 50000, N'COMPLETED', 2, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 15) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (15, N'HD7D115', N'2026-07-27T17:44:00', 56000, N'COMPLETED', 3, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 16) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (16, N'HD7D116', N'2026-07-27T08:57:00', 70000, N'COMPLETED', 4, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 17) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (17, N'HD7D117', N'2026-07-27T10:10:00', 50000, N'COMPLETED', 5, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 18) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (18, N'HD7D118', N'2026-07-27T12:23:00', 56000, N'COMPLETED', 6, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 19) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (19, N'HD7D119', N'2026-07-28T16:27:00', 50000, N'COMPLETED', 1, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 20) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (20, N'HD7D120', N'2026-07-28T07:40:00', 56000, N'COMPLETED', 2, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 21) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (21, N'HD7D121', N'2026-07-28T09:53:00', 70000, N'COMPLETED', 3, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 22) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (22, N'HD7D122', N'2026-07-28T11:06:00', 50000, N'COMPLETED', 4, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 23) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (23, N'HD7D123', N'2026-07-28T13:19:00', 56000, N'COMPLETED', 5, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 24) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (24, N'HD7D124', N'2026-07-28T15:32:00', 70000, N'COMPLETED', 6, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 25) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (25, N'HD7D125', N'2026-07-29T08:36:00', 56000, N'COMPLETED', 1, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 26) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (26, N'HD7D126', N'2026-07-29T10:49:00', 70000, N'COMPLETED', 2, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 27) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (27, N'HD7D127', N'2026-07-29T12:02:00', 50000, N'COMPLETED', 3, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 28) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (28, N'HD7D128', N'2026-07-29T14:15:00', 56000, N'COMPLETED', 4, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 29) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (29, N'HD7D129', N'2026-07-29T16:28:00', 70000, N'COMPLETED', 5, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 30) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (30, N'HD7D130', N'2026-07-29T07:41:00', 50000, N'COMPLETED', 6, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 31) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (31, N'HD7D131', N'2026-07-30T11:45:00', 70000, N'COMPLETED', 1, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 32) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (32, N'HD7D132', N'2026-07-30T13:58:00', 50000, N'COMPLETED', 2, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 33) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (33, N'HD7D133', N'2026-07-30T15:11:00', 56000, N'COMPLETED', 3, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 34) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (34, N'HD7D134', N'2026-07-30T17:24:00', 70000, N'COMPLETED', 4, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 35) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (35, N'HD7D135', N'2026-07-30T08:37:00', 50000, N'COMPLETED', 5, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 36) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (36, N'HD7D136', N'2026-07-30T10:50:00', 56000, N'COMPLETED', 6, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 37) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (37, N'HD7D137', N'2026-07-31T14:54:00', 50000, N'COMPLETED', 1, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 38) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (38, N'HD7D138', N'2026-07-31T16:07:00', 56000, N'COMPLETED', 2, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 39) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (39, N'HD7D139', N'2026-07-31T07:20:00', 70000, N'COMPLETED', 3, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 40) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (40, N'HD7D140', N'2026-07-31T09:33:00', 50000, N'COMPLETED', 4, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 41) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (41, N'HD7D141', N'2026-07-31T11:46:00', 56000, N'COMPLETED', 5, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 42) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (42, N'HD7D142', N'2026-07-31T13:59:00', 70000, N'COMPLETED', 6, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 43) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (43, N'HDUPD301', N'2026-07-25T07:00:00', 50000, N'COMPLETED', 1, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 44) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (44, N'HDUPD302', N'2026-07-25T09:13:00', 56000, N'COMPLETED', 2, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 45) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (45, N'HDUPD303', N'2026-07-25T11:26:00', 70000, N'COMPLETED', 3, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 46) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (46, N'HDUPD304', N'2026-07-25T13:39:00', 50000, N'COMPLETED', 4, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 47) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (47, N'HDUPD305', N'2026-07-25T15:52:00', 56000, N'COMPLETED', 5, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 48) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (48, N'HDUPD306', N'2026-07-25T17:05:00', 70000, N'COMPLETED', 6, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 49) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (49, N'HDUPD307', N'2026-07-26T10:09:00', 56000, N'COMPLETED', 1, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 50) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (50, N'HDUPD308', N'2026-07-26T12:22:00', 70000, N'COMPLETED', 2, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 51) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (51, N'HDUPD309', N'2026-07-26T14:35:00', 50000, N'COMPLETED', 3, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 52) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (52, N'HDUPD310', N'2026-07-26T16:48:00', 56000, N'COMPLETED', 4, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 53) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (53, N'HDUPD311', N'2026-07-26T07:01:00', 70000, N'COMPLETED', 5, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 54) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (54, N'HDUPD312', N'2026-07-26T09:14:00', 50000, N'COMPLETED', 6, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 55) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (55, N'HDUPD313', N'2026-07-27T13:18:00', 70000, N'COMPLETED', 1, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 56) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (56, N'HDUPD314', N'2026-07-27T15:31:00', 50000, N'COMPLETED', 2, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 57) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (57, N'HDUPD315', N'2026-07-27T17:44:00', 56000, N'COMPLETED', 3, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 58) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (58, N'HDUPD316', N'2026-07-27T08:57:00', 70000, N'COMPLETED', 4, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 59) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (59, N'HDUPD317', N'2026-07-27T10:10:00', 50000, N'COMPLETED', 5, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 60) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (60, N'HDUPD318', N'2026-07-27T12:23:00', 56000, N'COMPLETED', 6, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 61) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (61, N'HDUPD319', N'2026-07-28T16:27:00', 50000, N'COMPLETED', 1, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 62) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (62, N'HDUPD320', N'2026-07-28T07:40:00', 56000, N'COMPLETED', 2, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 63) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (63, N'HDUPD321', N'2026-07-28T09:53:00', 70000, N'COMPLETED', 3, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 64) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (64, N'HDUPD322', N'2026-07-28T11:06:00', 50000, N'COMPLETED', 4, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 65) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (65, N'HDUPD323', N'2026-07-28T13:19:00', 56000, N'COMPLETED', 5, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 66) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (66, N'HDUPD324', N'2026-07-28T15:32:00', 70000, N'COMPLETED', 6, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 67) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (67, N'HDUPD325', N'2026-07-29T08:36:00', 56000, N'COMPLETED', 1, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 68) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (68, N'HDUPD326', N'2026-07-29T10:49:00', 70000, N'COMPLETED', 2, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 69) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (69, N'HDUPD327', N'2026-07-29T12:02:00', 50000, N'COMPLETED', 3, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 70) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (70, N'HDUPD328', N'2026-07-29T14:15:00', 56000, N'COMPLETED', 4, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 71) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (71, N'HDUPD329', N'2026-07-29T16:28:00', 70000, N'COMPLETED', 5, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 72) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (72, N'HDUPD330', N'2026-07-29T07:41:00', 50000, N'COMPLETED', 6, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 73) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (73, N'HDUPD331', N'2026-07-30T11:45:00', 70000, N'COMPLETED', 1, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 74) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (74, N'HDUPD332', N'2026-07-30T13:58:00', 50000, N'COMPLETED', 2, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 75) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (75, N'HDUPD333', N'2026-07-30T15:11:00', 56000, N'COMPLETED', 3, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 76) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (76, N'HDUPD334', N'2026-07-30T17:24:00', 70000, N'COMPLETED', 4, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 77) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (77, N'HDUPD335', N'2026-07-30T08:37:00', 50000, N'COMPLETED', 5, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 78) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (78, N'HDUPD336', N'2026-07-30T10:50:00', 56000, N'COMPLETED', 6, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 79) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (79, N'HDUPD337', N'2026-07-31T14:54:00', 50000, N'COMPLETED', 1, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 80) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (80, N'HDUPD338', N'2026-07-31T16:07:00', 56000, N'COMPLETED', 2, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 81) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (81, N'HDUPD339', N'2026-07-31T07:20:00', 70000, N'COMPLETED', 3, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 82) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (82, N'HDUPD340', N'2026-07-31T09:33:00', 50000, N'COMPLETED', 4, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 83) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (83, N'HDUPD341', N'2026-07-31T11:46:00', 56000, N'COMPLETED', 5, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 84) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (84, N'HDUPD342', N'2026-07-31T13:59:00', 70000, N'COMPLETED', 6, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 85) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (85, N'HDMST501', N'2026-07-25T07:00:00', 50000, N'COMPLETED', 1, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 86) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (86, N'HDMST502', N'2026-07-25T09:13:00', 56000, N'COMPLETED', 2, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 87) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (87, N'HDMST503', N'2026-07-25T11:26:00', 70000, N'COMPLETED', 3, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 88) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (88, N'HDMST504', N'2026-07-25T13:39:00', 50000, N'COMPLETED', 4, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 89) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (89, N'HDMST505', N'2026-07-25T15:52:00', 56000, N'COMPLETED', 5, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 90) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (90, N'HDMST506', N'2026-07-25T17:05:00', 70000, N'COMPLETED', 6, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 91) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (91, N'HDMST507', N'2026-07-26T10:09:00', 56000, N'COMPLETED', 1, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 92) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (92, N'HDMST508', N'2026-07-26T12:22:00', 70000, N'COMPLETED', 2, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 93) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (93, N'HDMST509', N'2026-07-26T14:35:00', 50000, N'COMPLETED', 3, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 94) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (94, N'HDMST510', N'2026-07-26T16:48:00', 56000, N'COMPLETED', 4, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 95) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (95, N'HDMST511', N'2026-07-26T07:01:00', 70000, N'COMPLETED', 5, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 96) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (96, N'HDMST512', N'2026-07-26T09:14:00', 50000, N'COMPLETED', 6, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 97) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (97, N'HDMST513', N'2026-07-27T13:18:00', 70000, N'COMPLETED', 1, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 98) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (98, N'HDMST514', N'2026-07-27T15:31:00', 50000, N'COMPLETED', 2, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 99) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (99, N'HDMST515', N'2026-07-27T17:44:00', 56000, N'COMPLETED', 3, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 100) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (100, N'HDMST516', N'2026-07-27T08:57:00', 70000, N'COMPLETED', 4, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 101) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (101, N'HDMST517', N'2026-07-27T10:10:00', 50000, N'COMPLETED', 5, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 102) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (102, N'HDMST518', N'2026-07-27T12:23:00', 56000, N'COMPLETED', 6, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 103) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (103, N'HDMST519', N'2026-07-28T16:27:00', 50000, N'COMPLETED', 1, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 104) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (104, N'HDMST520', N'2026-07-28T07:40:00', 56000, N'COMPLETED', 2, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 105) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (105, N'HDMST521', N'2026-07-28T09:53:00', 70000, N'COMPLETED', 3, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 106) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (106, N'HDMST522', N'2026-07-28T11:06:00', 50000, N'COMPLETED', 4, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 107) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (107, N'HDMST523', N'2026-07-28T13:19:00', 56000, N'COMPLETED', 5, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 108) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (108, N'HDMST524', N'2026-07-28T15:32:00', 70000, N'COMPLETED', 6, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 109) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (109, N'HDMST525', N'2026-07-29T08:36:00', 56000, N'COMPLETED', 1, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 110) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (110, N'HDMST526', N'2026-07-29T10:49:00', 70000, N'COMPLETED', 2, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 111) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (111, N'HDMST527', N'2026-07-29T12:02:00', 50000, N'COMPLETED', 3, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 112) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (112, N'HDMST528', N'2026-07-29T14:15:00', 56000, N'COMPLETED', 4, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 113) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (113, N'HDMST529', N'2026-07-29T16:28:00', 70000, N'COMPLETED', 5, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 114) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (114, N'HDMST530', N'2026-07-29T07:41:00', 50000, N'COMPLETED', 6, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 115) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (115, N'HDMST531', N'2026-07-30T11:45:00', 70000, N'COMPLETED', 1, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 116) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (116, N'HDMST532', N'2026-07-30T13:58:00', 50000, N'COMPLETED', 2, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 117) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (117, N'HDMST533', N'2026-07-30T15:11:00', 56000, N'COMPLETED', 3, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 118) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (118, N'HDMST534', N'2026-07-30T17:24:00', 70000, N'COMPLETED', 4, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 119) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (119, N'HDMST535', N'2026-07-30T08:37:00', 50000, N'COMPLETED', 5, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 120) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (120, N'HDMST536', N'2026-07-30T10:50:00', 56000, N'COMPLETED', 6, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 121) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (121, N'HDMST537', N'2026-07-31T14:54:00', 50000, N'COMPLETED', 1, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 122) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (122, N'HDMST538', N'2026-07-31T16:07:00', 56000, N'COMPLETED', 2, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 123) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (123, N'HDMST539', N'2026-07-31T07:20:00', 70000, N'COMPLETED', 3, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 124) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (124, N'HDMST540', N'2026-07-31T09:33:00', 50000, N'COMPLETED', 4, 2);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 125) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (125, N'HDMST541', N'2026-07-31T11:46:00', 56000, N'COMPLETED', 5, 1);
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE id = 126) INSERT INTO don_hang(id, ma_so_don_hang, ngay_tao, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (126, N'HDMST542', N'2026-07-31T13:59:00', 70000, N'COMPLETED', 6, 2);
SET IDENTITY_INSERT don_hang OFF;
GO

SET IDENTITY_INSERT chi_tiet_don_hang ON;
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 1) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (1, 2, 40000, 1, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 2) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (2, 1, 10000, 1, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 3) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (3, 2, 36000, 2, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 4) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (4, 2, 20000, 2, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 5) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (5, 3, 60000, 3, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 6) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (6, 1, 10000, 3, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 7) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (7, 2, 40000, 4, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 8) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (8, 1, 10000, 4, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 9) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (9, 2, 36000, 5, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 10) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (10, 2, 20000, 5, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 11) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (11, 3, 60000, 6, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 12) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (12, 1, 10000, 6, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 13) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (13, 2, 36000, 7, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 14) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (14, 2, 20000, 7, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 15) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (15, 3, 60000, 8, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 16) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (16, 1, 10000, 8, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 17) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (17, 2, 40000, 9, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 18) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (18, 1, 10000, 9, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 19) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (19, 2, 36000, 10, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 20) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (20, 2, 20000, 10, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 21) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (21, 3, 60000, 11, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 22) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (22, 1, 10000, 11, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 23) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (23, 2, 40000, 12, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 24) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (24, 1, 10000, 12, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 25) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (25, 3, 60000, 13, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 26) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (26, 1, 10000, 13, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 27) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (27, 2, 40000, 14, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 28) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (28, 1, 10000, 14, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 29) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (29, 2, 36000, 15, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 30) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (30, 2, 20000, 15, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 31) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (31, 3, 60000, 16, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 32) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (32, 1, 10000, 16, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 33) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (33, 2, 40000, 17, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 34) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (34, 1, 10000, 17, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 35) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (35, 2, 36000, 18, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 36) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (36, 2, 20000, 18, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 37) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (37, 2, 40000, 19, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 38) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (38, 1, 10000, 19, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 39) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (39, 2, 36000, 20, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 40) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (40, 2, 20000, 20, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 41) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (41, 3, 60000, 21, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 42) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (42, 1, 10000, 21, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 43) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (43, 2, 40000, 22, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 44) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (44, 1, 10000, 22, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 45) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (45, 2, 36000, 23, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 46) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (46, 2, 20000, 23, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 47) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (47, 3, 60000, 24, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 48) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (48, 1, 10000, 24, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 49) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (49, 2, 36000, 25, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 50) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (50, 2, 20000, 25, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 51) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (51, 3, 60000, 26, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 52) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (52, 1, 10000, 26, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 53) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (53, 2, 40000, 27, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 54) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (54, 1, 10000, 27, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 55) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (55, 2, 36000, 28, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 56) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (56, 2, 20000, 28, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 57) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (57, 3, 60000, 29, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 58) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (58, 1, 10000, 29, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 59) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (59, 2, 40000, 30, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 60) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (60, 1, 10000, 30, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 61) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (61, 3, 60000, 31, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 62) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (62, 1, 10000, 31, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 63) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (63, 2, 40000, 32, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 64) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (64, 1, 10000, 32, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 65) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (65, 2, 36000, 33, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 66) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (66, 2, 20000, 33, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 67) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (67, 3, 60000, 34, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 68) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (68, 1, 10000, 34, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 69) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (69, 2, 40000, 35, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 70) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (70, 1, 10000, 35, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 71) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (71, 2, 36000, 36, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 72) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (72, 2, 20000, 36, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 73) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (73, 2, 40000, 37, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 74) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (74, 1, 10000, 37, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 75) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (75, 2, 36000, 38, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 76) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (76, 2, 20000, 38, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 77) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (77, 3, 60000, 39, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 78) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (78, 1, 10000, 39, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 79) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (79, 2, 40000, 40, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 80) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (80, 1, 10000, 40, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 81) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (81, 2, 36000, 41, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 82) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (82, 2, 20000, 41, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 83) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (83, 3, 60000, 42, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 84) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (84, 1, 10000, 42, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 85) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (85, 2, 40000, 43, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 86) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (86, 1, 10000, 43, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 87) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (87, 2, 36000, 44, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 88) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (88, 2, 20000, 44, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 89) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (89, 3, 60000, 45, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 90) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (90, 1, 10000, 45, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 91) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (91, 2, 40000, 46, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 92) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (92, 1, 10000, 46, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 93) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (93, 2, 36000, 47, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 94) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (94, 2, 20000, 47, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 95) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (95, 3, 60000, 48, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 96) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (96, 1, 10000, 48, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 97) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (97, 2, 36000, 49, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 98) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (98, 2, 20000, 49, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 99) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (99, 3, 60000, 50, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 100) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (100, 1, 10000, 50, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 101) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (101, 2, 40000, 51, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 102) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (102, 1, 10000, 51, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 103) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (103, 2, 36000, 52, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 104) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (104, 2, 20000, 52, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 105) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (105, 3, 60000, 53, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 106) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (106, 1, 10000, 53, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 107) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (107, 2, 40000, 54, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 108) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (108, 1, 10000, 54, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 109) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (109, 3, 60000, 55, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 110) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (110, 1, 10000, 55, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 111) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (111, 2, 40000, 56, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 112) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (112, 1, 10000, 56, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 113) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (113, 2, 36000, 57, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 114) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (114, 2, 20000, 57, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 115) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (115, 3, 60000, 58, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 116) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (116, 1, 10000, 58, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 117) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (117, 2, 40000, 59, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 118) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (118, 1, 10000, 59, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 119) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (119, 2, 36000, 60, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 120) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (120, 2, 20000, 60, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 121) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (121, 2, 40000, 61, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 122) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (122, 1, 10000, 61, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 123) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (123, 2, 36000, 62, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 124) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (124, 2, 20000, 62, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 125) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (125, 3, 60000, 63, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 126) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (126, 1, 10000, 63, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 127) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (127, 2, 40000, 64, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 128) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (128, 1, 10000, 64, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 129) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (129, 2, 36000, 65, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 130) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (130, 2, 20000, 65, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 131) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (131, 3, 60000, 66, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 132) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (132, 1, 10000, 66, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 133) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (133, 2, 36000, 67, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 134) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (134, 2, 20000, 67, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 135) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (135, 3, 60000, 68, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 136) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (136, 1, 10000, 68, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 137) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (137, 2, 40000, 69, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 138) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (138, 1, 10000, 69, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 139) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (139, 2, 36000, 70, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 140) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (140, 2, 20000, 70, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 141) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (141, 3, 60000, 71, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 142) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (142, 1, 10000, 71, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 143) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (143, 2, 40000, 72, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 144) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (144, 1, 10000, 72, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 145) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (145, 3, 60000, 73, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 146) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (146, 1, 10000, 73, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 147) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (147, 2, 40000, 74, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 148) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (148, 1, 10000, 74, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 149) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (149, 2, 36000, 75, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 150) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (150, 2, 20000, 75, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 151) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (151, 3, 60000, 76, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 152) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (152, 1, 10000, 76, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 153) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (153, 2, 40000, 77, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 154) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (154, 1, 10000, 77, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 155) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (155, 2, 36000, 78, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 156) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (156, 2, 20000, 78, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 157) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (157, 2, 40000, 79, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 158) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (158, 1, 10000, 79, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 159) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (159, 2, 36000, 80, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 160) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (160, 2, 20000, 80, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 161) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (161, 3, 60000, 81, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 162) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (162, 1, 10000, 81, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 163) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (163, 2, 40000, 82, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 164) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (164, 1, 10000, 82, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 165) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (165, 2, 36000, 83, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 166) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (166, 2, 20000, 83, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 167) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (167, 3, 60000, 84, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 168) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (168, 1, 10000, 84, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 169) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (169, 2, 40000, 85, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 170) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (170, 1, 10000, 85, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 171) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (171, 2, 36000, 86, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 172) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (172, 2, 20000, 86, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 173) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (173, 3, 60000, 87, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 174) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (174, 1, 10000, 87, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 175) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (175, 2, 40000, 88, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 176) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (176, 1, 10000, 88, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 177) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (177, 2, 36000, 89, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 178) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (178, 2, 20000, 89, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 179) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (179, 3, 60000, 90, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 180) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (180, 1, 10000, 90, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 181) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (181, 2, 36000, 91, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 182) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (182, 2, 20000, 91, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 183) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (183, 3, 60000, 92, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 184) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (184, 1, 10000, 92, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 185) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (185, 2, 40000, 93, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 186) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (186, 1, 10000, 93, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 187) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (187, 2, 36000, 94, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 188) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (188, 2, 20000, 94, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 189) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (189, 3, 60000, 95, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 190) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (190, 1, 10000, 95, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 191) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (191, 2, 40000, 96, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 192) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (192, 1, 10000, 96, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 193) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (193, 3, 60000, 97, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 194) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (194, 1, 10000, 97, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 195) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (195, 2, 40000, 98, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 196) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (196, 1, 10000, 98, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 197) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (197, 2, 36000, 99, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 198) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (198, 2, 20000, 99, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 199) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (199, 3, 60000, 100, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 200) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (200, 1, 10000, 100, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 201) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (201, 2, 40000, 101, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 202) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (202, 1, 10000, 101, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 203) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (203, 2, 36000, 102, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 204) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (204, 2, 20000, 102, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 205) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (205, 2, 40000, 103, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 206) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (206, 1, 10000, 103, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 207) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (207, 2, 36000, 104, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 208) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (208, 2, 20000, 104, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 209) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (209, 3, 60000, 105, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 210) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (210, 1, 10000, 105, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 211) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (211, 2, 40000, 106, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 212) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (212, 1, 10000, 106, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 213) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (213, 2, 36000, 107, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 214) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (214, 2, 20000, 107, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 215) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (215, 3, 60000, 108, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 216) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (216, 1, 10000, 108, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 217) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (217, 2, 36000, 109, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 218) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (218, 2, 20000, 109, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 219) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (219, 3, 60000, 110, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 220) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (220, 1, 10000, 110, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 221) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (221, 2, 40000, 111, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 222) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (222, 1, 10000, 111, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 223) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (223, 2, 36000, 112, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 224) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (224, 2, 20000, 112, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 225) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (225, 3, 60000, 113, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 226) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (226, 1, 10000, 113, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 227) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (227, 2, 40000, 114, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 228) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (228, 1, 10000, 114, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 229) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (229, 3, 60000, 115, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 230) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (230, 1, 10000, 115, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 231) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (231, 2, 40000, 116, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 232) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (232, 1, 10000, 116, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 233) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (233, 2, 36000, 117, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 234) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (234, 2, 20000, 117, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 235) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (235, 3, 60000, 118, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 236) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (236, 1, 10000, 118, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 237) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (237, 2, 40000, 119, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 238) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (238, 1, 10000, 119, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 239) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (239, 2, 36000, 120, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 240) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (240, 2, 20000, 120, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 241) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (241, 2, 40000, 121, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 242) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (242, 1, 10000, 121, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 243) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (243, 2, 36000, 122, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 244) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (244, 2, 20000, 122, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 245) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (245, 3, 60000, 123, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 246) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (246, 1, 10000, 123, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 247) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (247, 2, 40000, 124, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 248) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (248, 1, 10000, 124, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 249) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (249, 2, 36000, 125, 2);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 250) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (250, 2, 20000, 125, 3);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 251) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (251, 3, 60000, 126, 1);
IF NOT EXISTS (SELECT 1 FROM chi_tiet_don_hang WHERE id = 252) INSERT INTO chi_tiet_don_hang(id, so_luong, gia_ban, order_id, product_id) VALUES (252, 1, 10000, 126, 3);
SET IDENTITY_INSERT chi_tiet_don_hang OFF;
GO

PRINT N'===> ĐỒNG BỘ THÀNH CÔNG DỮ LIỆU THỰC TẾ VÀO CSDL WEBBANHMI! <===';
GO
