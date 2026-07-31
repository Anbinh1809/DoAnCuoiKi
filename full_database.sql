-- ============================================================
-- CƠ SỞ DỮ LIỆU CHUẨN TOÀN BỘ DỰ ÁN WEBBANHMI (SINGLE MASTER FILE)
-- Chạy file này trên SQL Server Management Studio (SSMS)
-- Tự động tạo CSDL/bảng nếu chưa có, hoặc cập nhật nếu đã có
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
    BEGIN
        ALTER TABLE toppings ADD so_luong_ton INT NOT NULL DEFAULT 50;
    END
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('toppings') AND name = 'don_vi_tinh')
    BEGIN
        ALTER TABLE toppings ADD don_vi_tinh NVARCHAR(50) NOT NULL DEFAULT N'Phần';
    END
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
-- NẠP VÀ CHUẨN HÓA DỮ LIỆU BAN ĐẦU
-- ============================================================

-- 1. Nhân Viên (1 Admin, 5 Staff chuẩn tên)
IF NOT EXISTS (SELECT 1 FROM nhan_vien WHERE ten_dang_nhap = 'admin')
    INSERT INTO nhan_vien (ten_dang_nhap, mat_khau, ho_ten, dien_thoai, vai_tro, active) VALUES ('admin', '123', N'Quản Trị Viên', '0901234567', 1, 1);

IF NOT EXISTS (SELECT 1 FROM nhan_vien WHERE ten_dang_nhap = 'staff1')
    INSERT INTO nhan_vien (ten_dang_nhap, mat_khau, ho_ten, dien_thoai, vai_tro, active) VALUES ('staff1', '123', N'Đặng Phi Hùng', '0901000001', 0, 1);
ELSE UPDATE nhan_vien SET ho_ten = N'Đặng Phi Hùng' WHERE ten_dang_nhap IN ('staff', 'staff1');

IF NOT EXISTS (SELECT 1 FROM nhan_vien WHERE ten_dang_nhap = 'staff2')
    INSERT INTO nhan_vien (ten_dang_nhap, mat_khau, ho_ten, dien_thoai, vai_tro, active) VALUES ('staff2', '123', N'Lê Bình An', '0901000002', 0, 1);
ELSE UPDATE nhan_vien SET ho_ten = N'Lê Bình An' WHERE ten_dang_nhap = 'staff2';

IF NOT EXISTS (SELECT 1 FROM nhan_vien WHERE ten_dang_nhap = 'staff3')
    INSERT INTO nhan_vien (ten_dang_nhap, mat_khau, ho_ten, dien_thoai, vai_tro, active) VALUES ('staff3', '123', N'Đinh Ngọc Đại', '0901000003', 0, 1);
ELSE UPDATE nhan_vien SET ho_ten = N'Đinh Ngọc Đại' WHERE ten_dang_nhap = 'staff3';

IF NOT EXISTS (SELECT 1 FROM nhan_vien WHERE ten_dang_nhap = 'staff4')
    INSERT INTO nhan_vien (ten_dang_nhap, mat_khau, ho_ten, dien_thoai, vai_tro, active) VALUES ('staff4', '123', N'Đinh Tiến Lộc', '0901000004', 0, 1);
ELSE UPDATE nhan_vien SET ho_ten = N'Đinh Tiến Lộc' WHERE ten_dang_nhap = 'staff4';

IF NOT EXISTS (SELECT 1 FROM nhan_vien WHERE ten_dang_nhap = 'staff5')
    INSERT INTO nhan_vien (ten_dang_nhap, mat_khau, ho_ten, dien_thoai, vai_tro, active) VALUES ('staff5', '123', N'Tôn Trần Triệu Vĩ', '0901000005', 0, 1);
ELSE UPDATE nhan_vien SET ho_ten = N'Tôn Trần Triệu Vĩ' WHERE ten_dang_nhap = 'staff5';
GO

-- 2. Phương Thức Thanh Toán
IF NOT EXISTS (SELECT 1 FROM the_thanh_toan WHERE id = 1) INSERT INTO the_thanh_toan (ten_loai_the, active) VALUES (N'Tiền mặt', 1);
IF NOT EXISTS (SELECT 1 FROM the_thanh_toan WHERE id = 2) INSERT INTO the_thanh_toan (ten_loai_the, active) VALUES (N'Chuyển khoản / Momo', 1);
GO

-- 3. Loại Sản Phẩm
IF NOT EXISTS (SELECT 1 FROM loai_san_pham WHERE id = 1) INSERT INTO loai_san_pham (ten_loai, active) VALUES (N'Bánh Mì Thịt', 1);
IF NOT EXISTS (SELECT 1 FROM loai_san_pham WHERE id = 2) INSERT INTO loai_san_pham (ten_loai, active) VALUES (N'Bánh Mì Chay / Món Khác', 1);
IF NOT EXISTS (SELECT 1 FROM loai_san_pham WHERE id = 3) INSERT INTO loai_san_pham (ten_loai, active) VALUES (N'Đồ Uống', 1);
GO

-- 4. Danh Sách 22 Sản Phẩm
UPDATE san_pham SET ten_sp = N'Bánh mì thịt nướng' WHERE id = 1;
UPDATE san_pham SET ten_sp = N'Bánh mì xíu mại' WHERE id = 2;
UPDATE san_pham SET ten_sp = N'Trà tắc giải nhiệt' WHERE id = 3;

IF NOT EXISTS (SELECT 1 FROM san_pham WHERE ten_sp LIKE N'%chả lụa%')
BEGIN
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
END
GO

-- 5. Danh Sách 10 Toppings
UPDATE toppings SET ten_nguyen_lieu = N'Trứng ốp la', don_vi_tinh = N'Quả', so_luong_ton = 50 WHERE id = 1;
UPDATE toppings SET ten_nguyen_lieu = N'Pate nhà làm', don_vi_tinh = N'Phần', so_luong_ton = 50 WHERE id = 2;
UPDATE toppings SET ten_nguyen_lieu = N'Chả lụa thêm', don_vi_tinh = N'Phần', so_luong_ton = 50 WHERE id = 3;
UPDATE toppings SET ten_nguyen_lieu = N'Thịt nướng thêm', don_vi_tinh = N'Phần', so_luong_ton = 50 WHERE id = 4;

IF NOT EXISTS (SELECT 1 FROM toppings WHERE ten_nguyen_lieu LIKE N'%Phô mai%')
BEGIN
    INSERT INTO toppings (ten_nguyen_lieu, gia_cong_them, so_luong_ton, don_vi_tinh, active) VALUES
    (N'Phô mai Con Bò Cười', 5000, 50, N'Cái', 1),
    (N'Bơ béo nhà làm', 3000, 50, N'Muỗng', 1),
    (N'Gà xé thêm', 8000, 50, N'Phần', 1),
    (N'Xá xíu thêm', 8000, 50, N'Phần', 1),
    (N'Xúc xích Đức', 7000, 50, N'Cây', 1),
    (N'Kim chi ăn kèm', 4000, 30, N'Hộp', 1);
END
GO

-- ============================================================
-- DỮ LIỆU MẪU HÓA ĐƠN 7 NGÀY GẦN NHẤT CHO DASHBOARD
-- ============================================================
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST501')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST501', 50000, 'COMPLETED', id, 1, DATEADD(minute, -8220, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_HDMST501 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST501');
    IF @ord_HDMST501 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST501, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST501, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST502')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST502', 56000, 'COMPLETED', id, 2, DATEADD(minute, -8087, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_HDMST502 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST502');
    IF @ord_HDMST502 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST502, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST502, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST503')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST503', 70000, 'COMPLETED', id, 1, DATEADD(minute, -7954, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_HDMST503 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST503');
    IF @ord_HDMST503 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST503, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST503, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST504')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST504', 50000, 'COMPLETED', id, 2, DATEADD(minute, -7821, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_HDMST504 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST504');
    IF @ord_HDMST504 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST504, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST504, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST505')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST505', 56000, 'COMPLETED', id, 1, DATEADD(minute, -7688, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_HDMST505 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST505');
    IF @ord_HDMST505 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST505, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST505, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST506')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST506', 70000, 'COMPLETED', id, 2, DATEADD(minute, -7615, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_HDMST506 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST506');
    IF @ord_HDMST506 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST506, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST506, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST507')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST507', 56000, 'COMPLETED', id, 2, DATEADD(minute, -6591, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_HDMST507 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST507');
    IF @ord_HDMST507 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST507, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST507, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST508')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST508', 70000, 'COMPLETED', id, 1, DATEADD(minute, -6458, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_HDMST508 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST508');
    IF @ord_HDMST508 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST508, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST508, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST509')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST509', 50000, 'COMPLETED', id, 2, DATEADD(minute, -6325, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_HDMST509 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST509');
    IF @ord_HDMST509 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST509, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST509, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST510')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST510', 56000, 'COMPLETED', id, 1, DATEADD(minute, -6192, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_HDMST510 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST510');
    IF @ord_HDMST510 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST510, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST510, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST511')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST511', 70000, 'COMPLETED', id, 2, DATEADD(minute, -6779, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_HDMST511 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST511');
    IF @ord_HDMST511 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST511, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST511, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST512')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST512', 50000, 'COMPLETED', id, 1, DATEADD(minute, -6646, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_HDMST512 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST512');
    IF @ord_HDMST512 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST512, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST512, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST513')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST513', 70000, 'COMPLETED', id, 1, DATEADD(minute, -4962, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_HDMST513 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST513');
    IF @ord_HDMST513 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST513, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST513, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST514')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST514', 50000, 'COMPLETED', id, 2, DATEADD(minute, -4829, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_HDMST514 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST514');
    IF @ord_HDMST514 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST514, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST514, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST515')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST515', 56000, 'COMPLETED', id, 1, DATEADD(minute, -4696, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_HDMST515 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST515');
    IF @ord_HDMST515 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST515, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST515, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST516')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST516', 70000, 'COMPLETED', id, 2, DATEADD(minute, -5223, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_HDMST516 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST516');
    IF @ord_HDMST516 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST516, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST516, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST517')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST517', 50000, 'COMPLETED', id, 1, DATEADD(minute, -5150, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_HDMST517 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST517');
    IF @ord_HDMST517 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST517, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST517, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST518')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST518', 56000, 'COMPLETED', id, 2, DATEADD(minute, -5017, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_HDMST518 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST518');
    IF @ord_HDMST518 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST518, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST518, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST519')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST519', 50000, 'COMPLETED', id, 2, DATEADD(minute, -3333, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_HDMST519 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST519');
    IF @ord_HDMST519 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST519, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST519, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST520')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST520', 56000, 'COMPLETED', id, 1, DATEADD(minute, -3860, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_HDMST520 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST520');
    IF @ord_HDMST520 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST520, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST520, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST521')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST521', 70000, 'COMPLETED', id, 2, DATEADD(minute, -3727, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_HDMST521 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST521');
    IF @ord_HDMST521 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST521, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST521, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST522')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST522', 50000, 'COMPLETED', id, 1, DATEADD(minute, -3654, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_HDMST522 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST522');
    IF @ord_HDMST522 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST522, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST522, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST523')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST523', 56000, 'COMPLETED', id, 2, DATEADD(minute, -3521, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_HDMST523 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST523');
    IF @ord_HDMST523 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST523, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST523, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST524')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST524', 70000, 'COMPLETED', id, 1, DATEADD(minute, -3388, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_HDMST524 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST524');
    IF @ord_HDMST524 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST524, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST524, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST525')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST525', 56000, 'COMPLETED', id, 1, DATEADD(minute, -2364, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_HDMST525 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST525');
    IF @ord_HDMST525 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST525, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST525, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST526')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST526', 70000, 'COMPLETED', id, 2, DATEADD(minute, -2231, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_HDMST526 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST526');
    IF @ord_HDMST526 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST526, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST526, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST527')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST527', 50000, 'COMPLETED', id, 1, DATEADD(minute, -2158, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_HDMST527 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST527');
    IF @ord_HDMST527 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST527, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST527, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST528')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST528', 56000, 'COMPLETED', id, 2, DATEADD(minute, -2025, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_HDMST528 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST528');
    IF @ord_HDMST528 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST528, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST528, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST529')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST529', 70000, 'COMPLETED', id, 1, DATEADD(minute, -1892, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_HDMST529 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST529');
    IF @ord_HDMST529 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST529, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST529, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST530')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST530', 50000, 'COMPLETED', id, 2, DATEADD(minute, -2419, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_HDMST530 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST530');
    IF @ord_HDMST530 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST530, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST530, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST531')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST531', 70000, 'COMPLETED', id, 2, DATEADD(minute, -735, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_HDMST531 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST531');
    IF @ord_HDMST531 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST531, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST531, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST532')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST532', 50000, 'COMPLETED', id, 1, DATEADD(minute, -602, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_HDMST532 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST532');
    IF @ord_HDMST532 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST532, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST532, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST533')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST533', 56000, 'COMPLETED', id, 2, DATEADD(minute, -529, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_HDMST533 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST533');
    IF @ord_HDMST533 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST533, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST533, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST534')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST534', 70000, 'COMPLETED', id, 1, DATEADD(minute, -396, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_HDMST534 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST534');
    IF @ord_HDMST534 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST534, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST534, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST535')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST535', 50000, 'COMPLETED', id, 2, DATEADD(minute, -923, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_HDMST535 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST535');
    IF @ord_HDMST535 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST535, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST535, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST536')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST536', 56000, 'COMPLETED', id, 1, DATEADD(minute, -790, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_HDMST536 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST536');
    IF @ord_HDMST536 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST536, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST536, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST537')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST537', 50000, 'COMPLETED', id, 1, DATEADD(minute, 894, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_HDMST537 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST537');
    IF @ord_HDMST537 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST537, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST537, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST538')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST538', 56000, 'COMPLETED', id, 2, DATEADD(minute, 967, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_HDMST538 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST538');
    IF @ord_HDMST538 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST538, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST538, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST539')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST539', 70000, 'COMPLETED', id, 1, DATEADD(minute, 440, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_HDMST539 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST539');
    IF @ord_HDMST539 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST539, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST539, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST540')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST540', 50000, 'COMPLETED', id, 2, DATEADD(minute, 573, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_HDMST540 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST540');
    IF @ord_HDMST540 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST540, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST540, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST541')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST541', 56000, 'COMPLETED', id, 1, DATEADD(minute, 706, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_HDMST541 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST541');
    IF @ord_HDMST541 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST541, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST541, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDMST542')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDMST542', 70000, 'COMPLETED', id, 2, DATEADD(minute, 839, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_HDMST542 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDMST542');
    IF @ord_HDMST542 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST542, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDMST542, 3, 1, 10000);
    END
END
GO

PRINT N'===> TẠO & NẠP DỮ LIỆU CSDL WEBBANHMI HOÀN TẤT THÀNH CÔNG! <===';
GO
