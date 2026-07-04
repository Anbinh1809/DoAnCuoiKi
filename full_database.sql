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
