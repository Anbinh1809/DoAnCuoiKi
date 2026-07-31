-- ============================================================
-- SCRIPT CẬP NHẬT CƠ SỞ DỮ LIỆU WEBBANHMI (DÀNH CHO MÁY ĐÃ CÓ CSDL)
-- Chạy file này trên SQL Server Management Studio (SSMS)
-- ============================================================

USE webbanhmi;
GO

-- 1. Bổ sung cột so_luong_ton và don_vi_tinh cho bảng toppings nếu chưa có
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'toppings')
BEGIN
    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('toppings') AND name = 'so_luong_ton')
    BEGIN
        ALTER TABLE toppings ADD so_luong_ton INT NOT NULL DEFAULT 50;
        PRINT N'Đã bổ sung cột so_luong_ton vào bảng toppings.';
    END

    IF NOT EXISTS (SELECT * FROM sys.columns WHERE object_id = OBJECT_ID('toppings') AND name = 'don_vi_tinh')
    BEGIN
        ALTER TABLE toppings ADD don_vi_tinh NVARCHAR(50) NOT NULL DEFAULT N'Phần';
        PRINT N'Đã bổ sung cột don_vi_tinh vào bảng toppings.';
    END
END
GO

-- 2. Đảm bảo có đủ 5 tài khoản nhân viên staff1-staff5 với tên mới chuẩn Unicode
IF NOT EXISTS (SELECT 1 FROM nhan_vien WHERE ten_dang_nhap = 'staff1')
BEGIN
    INSERT INTO nhan_vien (ten_dang_nhap, mat_khau, ho_ten, dien_thoai, vai_tro, active) VALUES
    ('staff1', '123', N'Đặng Phi Hùng',     '0901000001', 0, 1),
    ('staff2', '123', N'Lê Bình An',        '0901000002', 0, 1),
    ('staff3', '123', N'Đinh Ngọc Đại',     '0901000003', 0, 1),
    ('staff4', '123', N'Đinh Tiến Lộc',     '0901000004', 0, 1),
    ('staff5', '123', N'Tôn Trần Triệu Vĩ', '0901000005', 0, 1);
END
ELSE
BEGIN
    UPDATE nhan_vien SET ho_ten = N'Đặng Phi Hùng'     WHERE ten_dang_nhap IN ('staff', 'staff1');
    UPDATE nhan_vien SET ho_ten = N'Lê Bình An'        WHERE ten_dang_nhap = 'staff2';
    UPDATE nhan_vien SET ho_ten = N'Đinh Ngọc Đại'     WHERE ten_dang_nhap = 'staff3';
    UPDATE nhan_vien SET ho_ten = N'Đinh Tiến Lộc'     WHERE ten_dang_nhap = 'staff4';
    UPDATE nhan_vien SET ho_ten = N'Tôn Trần Triệu Vĩ' WHERE ten_dang_nhap = 'staff5';
END
GO

-- 3. Đảm bảo đủ các phương thức thanh toán
IF NOT EXISTS (SELECT 1 FROM the_thanh_toan WHERE ten_loai_the LIKE N'%Momo%')
BEGIN
    INSERT INTO the_thanh_toan (ten_loai_the, active) VALUES (N'Chuyển khoản / Momo', 1);
END
GO

-- 4. Bổ sung các loại sản phẩm nếu chưa có
IF NOT EXISTS (SELECT 1 FROM loai_san_pham WHERE id = 1) INSERT INTO loai_san_pham(ten_loai, active) VALUES (N'Bánh Mì Thịt', 1);
IF NOT EXISTS (SELECT 1 FROM loai_san_pham WHERE id = 2) INSERT INTO loai_san_pham(ten_loai, active) VALUES (N'Bánh Mì Chay / Món Khác', 1);
IF NOT EXISTS (SELECT 1 FROM loai_san_pham WHERE id = 3) INSERT INTO loai_san_pham(ten_loai, active) VALUES (N'Đồ Uống', 1);
GO

-- 5. Cập nhật / Bổ sung sản phẩm chuẩn Unicode
UPDATE san_pham SET ten_sp = N'Bánh mì thịt nướng' WHERE id = 1;
UPDATE san_pham SET ten_sp = N'Bánh mì xíu mại' WHERE id = 2;
UPDATE san_pham SET ten_sp = N'Trà tắc giải nhiệt' WHERE id = 3;

IF NOT EXISTS (SELECT 1 FROM san_pham WHERE ten_sp LIKE N'%chả lụa%')
BEGIN
    INSERT INTO san_pham (ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES
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

-- 6. Cập nhật / Bổ sung Toppings
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
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD301')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD301', 50000, 'COMPLETED', id, 1, DATEADD(minute, -8220, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_HDUPD301 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD301');
    IF @ord_HDUPD301 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD301, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD301, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD302')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD302', 56000, 'COMPLETED', id, 2, DATEADD(minute, -8087, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_HDUPD302 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD302');
    IF @ord_HDUPD302 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD302, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD302, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD303')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD303', 70000, 'COMPLETED', id, 1, DATEADD(minute, -7954, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_HDUPD303 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD303');
    IF @ord_HDUPD303 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD303, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD303, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD304')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD304', 50000, 'COMPLETED', id, 2, DATEADD(minute, -7821, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_HDUPD304 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD304');
    IF @ord_HDUPD304 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD304, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD304, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD305')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD305', 56000, 'COMPLETED', id, 1, DATEADD(minute, -7688, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_HDUPD305 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD305');
    IF @ord_HDUPD305 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD305, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD305, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD306')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD306', 70000, 'COMPLETED', id, 2, DATEADD(minute, -7615, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_HDUPD306 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD306');
    IF @ord_HDUPD306 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD306, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD306, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD307')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD307', 56000, 'COMPLETED', id, 2, DATEADD(minute, -6591, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_HDUPD307 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD307');
    IF @ord_HDUPD307 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD307, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD307, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD308')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD308', 70000, 'COMPLETED', id, 1, DATEADD(minute, -6458, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_HDUPD308 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD308');
    IF @ord_HDUPD308 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD308, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD308, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD309')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD309', 50000, 'COMPLETED', id, 2, DATEADD(minute, -6325, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_HDUPD309 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD309');
    IF @ord_HDUPD309 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD309, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD309, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD310')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD310', 56000, 'COMPLETED', id, 1, DATEADD(minute, -6192, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_HDUPD310 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD310');
    IF @ord_HDUPD310 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD310, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD310, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD311')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD311', 70000, 'COMPLETED', id, 2, DATEADD(minute, -6779, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_HDUPD311 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD311');
    IF @ord_HDUPD311 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD311, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD311, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD312')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD312', 50000, 'COMPLETED', id, 1, DATEADD(minute, -6646, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_HDUPD312 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD312');
    IF @ord_HDUPD312 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD312, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD312, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD313')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD313', 70000, 'COMPLETED', id, 1, DATEADD(minute, -4962, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_HDUPD313 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD313');
    IF @ord_HDUPD313 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD313, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD313, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD314')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD314', 50000, 'COMPLETED', id, 2, DATEADD(minute, -4829, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_HDUPD314 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD314');
    IF @ord_HDUPD314 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD314, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD314, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD315')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD315', 56000, 'COMPLETED', id, 1, DATEADD(minute, -4696, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_HDUPD315 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD315');
    IF @ord_HDUPD315 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD315, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD315, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD316')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD316', 70000, 'COMPLETED', id, 2, DATEADD(minute, -5223, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_HDUPD316 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD316');
    IF @ord_HDUPD316 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD316, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD316, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD317')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD317', 50000, 'COMPLETED', id, 1, DATEADD(minute, -5150, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_HDUPD317 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD317');
    IF @ord_HDUPD317 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD317, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD317, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD318')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD318', 56000, 'COMPLETED', id, 2, DATEADD(minute, -5017, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_HDUPD318 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD318');
    IF @ord_HDUPD318 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD318, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD318, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD319')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD319', 50000, 'COMPLETED', id, 2, DATEADD(minute, -3333, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_HDUPD319 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD319');
    IF @ord_HDUPD319 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD319, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD319, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD320')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD320', 56000, 'COMPLETED', id, 1, DATEADD(minute, -3860, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_HDUPD320 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD320');
    IF @ord_HDUPD320 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD320, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD320, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD321')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD321', 70000, 'COMPLETED', id, 2, DATEADD(minute, -3727, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_HDUPD321 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD321');
    IF @ord_HDUPD321 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD321, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD321, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD322')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD322', 50000, 'COMPLETED', id, 1, DATEADD(minute, -3654, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_HDUPD322 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD322');
    IF @ord_HDUPD322 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD322, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD322, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD323')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD323', 56000, 'COMPLETED', id, 2, DATEADD(minute, -3521, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_HDUPD323 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD323');
    IF @ord_HDUPD323 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD323, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD323, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD324')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD324', 70000, 'COMPLETED', id, 1, DATEADD(minute, -3388, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_HDUPD324 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD324');
    IF @ord_HDUPD324 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD324, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD324, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD325')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD325', 56000, 'COMPLETED', id, 1, DATEADD(minute, -2364, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_HDUPD325 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD325');
    IF @ord_HDUPD325 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD325, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD325, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD326')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD326', 70000, 'COMPLETED', id, 2, DATEADD(minute, -2231, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_HDUPD326 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD326');
    IF @ord_HDUPD326 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD326, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD326, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD327')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD327', 50000, 'COMPLETED', id, 1, DATEADD(minute, -2158, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_HDUPD327 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD327');
    IF @ord_HDUPD327 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD327, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD327, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD328')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD328', 56000, 'COMPLETED', id, 2, DATEADD(minute, -2025, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_HDUPD328 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD328');
    IF @ord_HDUPD328 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD328, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD328, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD329')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD329', 70000, 'COMPLETED', id, 1, DATEADD(minute, -1892, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_HDUPD329 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD329');
    IF @ord_HDUPD329 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD329, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD329, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD330')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD330', 50000, 'COMPLETED', id, 2, DATEADD(minute, -2419, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_HDUPD330 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD330');
    IF @ord_HDUPD330 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD330, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD330, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD331')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD331', 70000, 'COMPLETED', id, 2, DATEADD(minute, -735, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_HDUPD331 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD331');
    IF @ord_HDUPD331 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD331, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD331, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD332')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD332', 50000, 'COMPLETED', id, 1, DATEADD(minute, -602, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_HDUPD332 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD332');
    IF @ord_HDUPD332 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD332, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD332, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD333')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD333', 56000, 'COMPLETED', id, 2, DATEADD(minute, -529, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_HDUPD333 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD333');
    IF @ord_HDUPD333 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD333, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD333, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD334')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD334', 70000, 'COMPLETED', id, 1, DATEADD(minute, -396, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_HDUPD334 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD334');
    IF @ord_HDUPD334 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD334, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD334, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD335')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD335', 50000, 'COMPLETED', id, 2, DATEADD(minute, -923, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_HDUPD335 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD335');
    IF @ord_HDUPD335 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD335, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD335, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD336')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD336', 56000, 'COMPLETED', id, 1, DATEADD(minute, -790, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_HDUPD336 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD336');
    IF @ord_HDUPD336 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD336, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD336, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD337')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD337', 50000, 'COMPLETED', id, 1, DATEADD(minute, 894, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_HDUPD337 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD337');
    IF @ord_HDUPD337 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD337, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD337, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD338')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD338', 56000, 'COMPLETED', id, 2, DATEADD(minute, 967, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_HDUPD338 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD338');
    IF @ord_HDUPD338 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD338, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD338, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD339')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD339', 70000, 'COMPLETED', id, 1, DATEADD(minute, 440, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_HDUPD339 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD339');
    IF @ord_HDUPD339 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD339, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD339, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD340')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD340', 50000, 'COMPLETED', id, 2, DATEADD(minute, 573, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_HDUPD340 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD340');
    IF @ord_HDUPD340 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD340, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD340, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD341')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD341', 56000, 'COMPLETED', id, 1, DATEADD(minute, 706, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_HDUPD341 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD341');
    IF @ord_HDUPD341 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD341, 2, 2, 36000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD341, 3, 2, 20000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HDUPD342')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HDUPD342', 70000, 'COMPLETED', id, 2, DATEADD(minute, 839, CAST(CAST(GETDATE() AS DATE) AS DATETIME))
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_HDUPD342 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HDUPD342');
    IF @ord_HDUPD342 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD342, 1, 3, 60000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_HDUPD342, 3, 1, 10000);
    END
END
GO

PRINT N'Cập nhật CSDL webbanhmi hoàn tất thành công!';
GO
