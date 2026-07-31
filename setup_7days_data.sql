-- ============================================================
-- DỮ LIỆU MẪU ĐẦY ĐỦ 7 NGÀY CHO DASHBOARD VÀ BÁO CÁO THỐNG KÊ
-- ============================================================
USE webbanhmi;
GO

-- 1. Bổ sung nhân viên staff1-staff5 nếu chưa có
IF NOT EXISTS (SELECT 1 FROM nhan_vien WHERE ten_dang_nhap = 'staff1')
BEGIN
    INSERT INTO nhan_vien (ten_dang_nhap, mat_khau, ho_ten, dien_thoai, vai_tro, active) VALUES
    ('staff1', '123', N'Nguyễn Thị An', '0901000001', 0, 1),
    ('staff2', '123', N'Trần Văn Bình', '0901000002', 0, 1),
    ('staff3', '123', N'Lê Thị Cúc', '0901000003', 0, 1),
    ('staff4', '123', N'Phạm Văn Dũng', '0901000004', 0, 1),
    ('staff5', '123', N'Hoàng Thị Em', '0901000005', 0, 1);
END
GO

-- 2. Chèn hóa đơn 7 ngày gần nhất cho tất cả nhân viên
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D101')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D101', 30000, 'COMPLETED', id, 1, '2026-07-25 07:00:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_id_HD7D101 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D101');
    IF @ord_id_HD7D101 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D101, 1, 1, 20000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D101, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D102')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D102', 50000, 'COMPLETED', id, 2, '2026-07-25 09:11:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff';

    DECLARE @ord_id_HD7D102 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D102');
    IF @ord_id_HD7D102 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D102, 2, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D102, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D103')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D103', 50000, 'COMPLETED', id, 1, '2026-07-25 11:22:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_id_HD7D103 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D103');
    IF @ord_id_HD7D103 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D103, 3, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D103, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D104')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D104', 50000, 'COMPLETED', id, 2, '2026-07-25 13:33:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_id_HD7D104 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D104');
    IF @ord_id_HD7D104 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D104, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D104, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D105')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D105', 50000, 'COMPLETED', id, 1, '2026-07-25 15:44:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_id_HD7D105 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D105');
    IF @ord_id_HD7D105 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D105, 2, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D105, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D106')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D106', 30000, 'COMPLETED', id, 2, '2026-07-25 17:55:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_id_HD7D106 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D106');
    IF @ord_id_HD7D106 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D106, 3, 1, 20000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D106, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D107')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D107', 50000, 'COMPLETED', id, 1, '2026-07-25 07:06:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_id_HD7D107 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D107');
    IF @ord_id_HD7D107 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D107, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D107, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D108')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D108', 50000, 'COMPLETED', id, 2, '2026-07-26 08:07:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_id_HD7D108 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D108');
    IF @ord_id_HD7D108 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D108, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D108, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D109')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D109', 50000, 'COMPLETED', id, 1, '2026-07-26 10:18:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff';

    DECLARE @ord_id_HD7D109 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D109');
    IF @ord_id_HD7D109 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D109, 2, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D109, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D110')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D110', 50000, 'COMPLETED', id, 2, '2026-07-26 12:29:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_id_HD7D110 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D110');
    IF @ord_id_HD7D110 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D110, 3, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D110, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D111')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D111', 50000, 'COMPLETED', id, 1, '2026-07-26 14:40:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_id_HD7D111 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D111');
    IF @ord_id_HD7D111 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D111, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D111, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D112')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D112', 50000, 'COMPLETED', id, 2, '2026-07-26 16:51:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_id_HD7D112 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D112');
    IF @ord_id_HD7D112 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D112, 2, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D112, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D113')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D113', 50000, 'COMPLETED', id, 1, '2026-07-26 18:02:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_id_HD7D113 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D113');
    IF @ord_id_HD7D113 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D113, 3, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D113, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D114')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D114', 50000, 'COMPLETED', id, 2, '2026-07-26 08:13:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_id_HD7D114 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D114');
    IF @ord_id_HD7D114 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D114, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D114, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D115')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D115', 50000, 'COMPLETED', id, 1, '2026-07-27 09:14:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_id_HD7D115 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D115');
    IF @ord_id_HD7D115 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D115, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D115, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D116')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D116', 50000, 'COMPLETED', id, 2, '2026-07-27 11:25:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff';

    DECLARE @ord_id_HD7D116 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D116');
    IF @ord_id_HD7D116 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D116, 2, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D116, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D117')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D117', 50000, 'COMPLETED', id, 1, '2026-07-27 13:36:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_id_HD7D117 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D117');
    IF @ord_id_HD7D117 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D117, 3, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D117, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D118')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D118', 50000, 'COMPLETED', id, 2, '2026-07-27 15:47:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_id_HD7D118 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D118');
    IF @ord_id_HD7D118 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D118, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D118, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D119')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D119', 30000, 'COMPLETED', id, 1, '2026-07-27 17:58:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_id_HD7D119 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D119');
    IF @ord_id_HD7D119 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D119, 2, 1, 20000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D119, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D120')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D120', 50000, 'COMPLETED', id, 2, '2026-07-27 07:09:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_id_HD7D120 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D120');
    IF @ord_id_HD7D120 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D120, 3, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D120, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D121')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D121', 50000, 'COMPLETED', id, 1, '2026-07-27 09:20:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_id_HD7D121 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D121');
    IF @ord_id_HD7D121 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D121, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D121, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D122')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D122', 50000, 'COMPLETED', id, 2, '2026-07-28 10:21:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_id_HD7D122 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D122');
    IF @ord_id_HD7D122 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D122, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D122, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D123')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D123', 50000, 'COMPLETED', id, 1, '2026-07-28 12:32:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff';

    DECLARE @ord_id_HD7D123 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D123');
    IF @ord_id_HD7D123 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D123, 2, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D123, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D124')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D124', 50000, 'COMPLETED', id, 2, '2026-07-28 14:43:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_id_HD7D124 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D124');
    IF @ord_id_HD7D124 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D124, 3, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D124, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D125')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D125', 50000, 'COMPLETED', id, 1, '2026-07-28 16:54:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_id_HD7D125 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D125');
    IF @ord_id_HD7D125 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D125, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D125, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D126')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D126', 50000, 'COMPLETED', id, 2, '2026-07-28 18:05:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_id_HD7D126 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D126');
    IF @ord_id_HD7D126 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D126, 2, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D126, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D127')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D127', 50000, 'COMPLETED', id, 1, '2026-07-28 08:16:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_id_HD7D127 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D127');
    IF @ord_id_HD7D127 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D127, 3, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D127, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D128')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D128', 50000, 'COMPLETED', id, 2, '2026-07-28 10:27:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_id_HD7D128 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D128');
    IF @ord_id_HD7D128 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D128, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D128, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D129')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D129', 50000, 'COMPLETED', id, 1, '2026-07-29 11:28:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_id_HD7D129 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D129');
    IF @ord_id_HD7D129 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D129, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D129, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D130')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D130', 50000, 'COMPLETED', id, 2, '2026-07-29 13:39:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff';

    DECLARE @ord_id_HD7D130 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D130');
    IF @ord_id_HD7D130 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D130, 2, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D130, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D131')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D131', 50000, 'COMPLETED', id, 1, '2026-07-29 15:50:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_id_HD7D131 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D131');
    IF @ord_id_HD7D131 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D131, 3, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D131, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D132')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D132', 30000, 'COMPLETED', id, 2, '2026-07-29 17:01:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_id_HD7D132 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D132');
    IF @ord_id_HD7D132 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D132, 1, 1, 20000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D132, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D133')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D133', 50000, 'COMPLETED', id, 1, '2026-07-29 07:12:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_id_HD7D133 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D133');
    IF @ord_id_HD7D133 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D133, 2, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D133, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D134')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D134', 50000, 'COMPLETED', id, 2, '2026-07-29 09:23:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_id_HD7D134 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D134');
    IF @ord_id_HD7D134 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D134, 3, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D134, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D135')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D135', 50000, 'COMPLETED', id, 1, '2026-07-29 11:34:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_id_HD7D135 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D135');
    IF @ord_id_HD7D135 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D135, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D135, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D136')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D136', 50000, 'COMPLETED', id, 2, '2026-07-30 12:35:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_id_HD7D136 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D136');
    IF @ord_id_HD7D136 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D136, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D136, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D137')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D137', 50000, 'COMPLETED', id, 1, '2026-07-30 14:46:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff';

    DECLARE @ord_id_HD7D137 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D137');
    IF @ord_id_HD7D137 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D137, 2, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D137, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D138')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D138', 50000, 'COMPLETED', id, 2, '2026-07-30 16:57:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_id_HD7D138 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D138');
    IF @ord_id_HD7D138 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D138, 3, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D138, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D139')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D139', 50000, 'COMPLETED', id, 1, '2026-07-30 18:08:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_id_HD7D139 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D139');
    IF @ord_id_HD7D139 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D139, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D139, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D140')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D140', 50000, 'COMPLETED', id, 2, '2026-07-30 08:19:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_id_HD7D140 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D140');
    IF @ord_id_HD7D140 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D140, 2, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D140, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D141')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D141', 50000, 'COMPLETED', id, 1, '2026-07-30 10:30:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_id_HD7D141 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D141');
    IF @ord_id_HD7D141 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D141, 3, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D141, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D142')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D142', 50000, 'COMPLETED', id, 2, '2026-07-30 12:41:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_id_HD7D142 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D142');
    IF @ord_id_HD7D142 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D142, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D142, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D143')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D143', 50000, 'COMPLETED', id, 1, '2026-07-31 13:42:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'admin';

    DECLARE @ord_id_HD7D143 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D143');
    IF @ord_id_HD7D143 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D143, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D143, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D144')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D144', 50000, 'COMPLETED', id, 2, '2026-07-31 15:53:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff';

    DECLARE @ord_id_HD7D144 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D144');
    IF @ord_id_HD7D144 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D144, 2, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D144, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D145')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D145', 30000, 'COMPLETED', id, 1, '2026-07-31 17:04:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff1';

    DECLARE @ord_id_HD7D145 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D145');
    IF @ord_id_HD7D145 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D145, 3, 1, 20000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D145, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D146')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D146', 50000, 'COMPLETED', id, 2, '2026-07-31 07:15:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff2';

    DECLARE @ord_id_HD7D146 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D146');
    IF @ord_id_HD7D146 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D146, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D146, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D147')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D147', 50000, 'COMPLETED', id, 1, '2026-07-31 09:26:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff3';

    DECLARE @ord_id_HD7D147 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D147');
    IF @ord_id_HD7D147 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D147, 2, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D147, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D148')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D148', 50000, 'COMPLETED', id, 2, '2026-07-31 11:37:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff4';

    DECLARE @ord_id_HD7D148 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D148');
    IF @ord_id_HD7D148 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D148, 3, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D148, 3, 1, 10000);
    END
END
GO
IF NOT EXISTS (SELECT 1 FROM don_hang WHERE ma_so_don_hang = 'HD7D149')
BEGIN
    INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
    SELECT 'HD7D149', 50000, 'COMPLETED', id, 1, '2026-07-31 13:48:00'
    FROM nhan_vien WHERE ten_dang_nhap = 'staff5';

    DECLARE @ord_id_HD7D149 INT = (SELECT id FROM don_hang WHERE ma_so_don_hang = 'HD7D149');
    IF @ord_id_HD7D149 IS NOT NULL
    BEGIN
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D149, 1, 2, 40000);
        INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) VALUES (@ord_id_HD7D149, 3, 1, 10000);
    END
END
GO