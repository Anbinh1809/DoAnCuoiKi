-- Thêm 5 tài khoản nhân viên staff1-staff5
INSERT INTO nhan_vien (ten_dang_nhap, mat_khau, ho_ten, dien_thoai, vai_tro, active) VALUES
('staff1', '123', N'Nguyễn Thị An', '0901000001', 0, 1),
('staff2', '123', N'Trần Văn Bình', '0901000002', 0, 1),
('staff3', '123', N'Lê Thị Cúc', '0901000003', 0, 1),
('staff4', '123', N'Phạm Văn Dũng', '0901000004', 0, 1),
('staff5', '123', N'Hoàng Thị Em', '0901000005', 0, 1);
GO

-- Thêm hóa đơn cho từng staff (dùng subquery trực tiếp)
-- staff1
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'S1HD001', 45000, 'COMPLETED', id, NULL, '2026-07-20 08:30:00' FROM nhan_vien WHERE ten_dang_nhap='staff1' UNION ALL
SELECT 'S1HD002', 38000, 'COMPLETED', id, 1,    '2026-07-21 09:15:00' FROM nhan_vien WHERE ten_dang_nhap='staff1' UNION ALL
SELECT 'S1HD003', 72000, 'COMPLETED', id, NULL, '2026-07-22 11:00:00' FROM nhan_vien WHERE ten_dang_nhap='staff1' UNION ALL
SELECT 'S1HD004', 25000, 'COMPLETED', id, 1,    '2026-07-23 14:30:00' FROM nhan_vien WHERE ten_dang_nhap='staff1' UNION ALL
SELECT 'S1HD005', 56000, 'COMPLETED', id, NULL, '2026-07-24 07:45:00' FROM nhan_vien WHERE ten_dang_nhap='staff1';

-- staff2
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'S2HD001', 20000, 'COMPLETED', id, NULL, '2026-07-20 10:00:00' FROM nhan_vien WHERE ten_dang_nhap='staff2' UNION ALL
SELECT 'S2HD002', 60000, 'COMPLETED', id, NULL, '2026-07-21 13:30:00' FROM nhan_vien WHERE ten_dang_nhap='staff2' UNION ALL
SELECT 'S2HD003', 35000, 'COMPLETED', id, 1,    '2026-07-22 15:00:00' FROM nhan_vien WHERE ten_dang_nhap='staff2' UNION ALL
SELECT 'S2HD004', 90000, 'COMPLETED', id, NULL, '2026-07-23 16:45:00' FROM nhan_vien WHERE ten_dang_nhap='staff2' UNION ALL
SELECT 'S2HD005', 40000, 'COMPLETED', id, 1,    '2026-07-24 09:20:00' FROM nhan_vien WHERE ten_dang_nhap='staff2';

-- staff3
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'S3HD001', 55000, 'COMPLETED', id, NULL, '2026-07-20 11:00:00' FROM nhan_vien WHERE ten_dang_nhap='staff3' UNION ALL
SELECT 'S3HD002', 30000, 'COMPLETED', id, 1,    '2026-07-21 10:30:00' FROM nhan_vien WHERE ten_dang_nhap='staff3' UNION ALL
SELECT 'S3HD003', 80000, 'COMPLETED', id, NULL, '2026-07-22 17:00:00' FROM nhan_vien WHERE ten_dang_nhap='staff3' UNION ALL
SELECT 'S3HD004', 48000, 'COMPLETED', id, NULL, '2026-07-23 08:30:00' FROM nhan_vien WHERE ten_dang_nhap='staff3' UNION ALL
SELECT 'S3HD005', 22000, 'COMPLETED', id, 1,    '2026-07-24 11:00:00' FROM nhan_vien WHERE ten_dang_nhap='staff3';

-- staff4
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'S4HD001', 65000, 'COMPLETED', id, NULL, '2026-07-20 14:00:00' FROM nhan_vien WHERE ten_dang_nhap='staff4' UNION ALL
SELECT 'S4HD002', 43000, 'COMPLETED', id, 1,    '2026-07-21 15:30:00' FROM nhan_vien WHERE ten_dang_nhap='staff4' UNION ALL
SELECT 'S4HD003', 28000, 'COMPLETED', id, NULL, '2026-07-22 09:00:00' FROM nhan_vien WHERE ten_dang_nhap='staff4' UNION ALL
SELECT 'S4HD004', 75000, 'COMPLETED', id, NULL, '2026-07-23 12:00:00' FROM nhan_vien WHERE ten_dang_nhap='staff4' UNION ALL
SELECT 'S4HD005', 50000, 'COMPLETED', id, 1,    '2026-07-24 16:00:00' FROM nhan_vien WHERE ten_dang_nhap='staff4';

-- staff5
INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao)
SELECT 'S5HD001', 33000, 'COMPLETED', id, NULL, '2026-07-20 09:00:00' FROM nhan_vien WHERE ten_dang_nhap='staff5' UNION ALL
SELECT 'S5HD002', 58000, 'COMPLETED', id, 1,    '2026-07-21 11:00:00' FROM nhan_vien WHERE ten_dang_nhap='staff5' UNION ALL
SELECT 'S5HD003', 42000, 'COMPLETED', id, NULL, '2026-07-22 13:30:00' FROM nhan_vien WHERE ten_dang_nhap='staff5' UNION ALL
SELECT 'S5HD004', 68000, 'COMPLETED', id, NULL, '2026-07-23 18:00:00' FROM nhan_vien WHERE ten_dang_nhap='staff5' UNION ALL
SELECT 'S5HD005', 27000, 'COMPLETED', id, 1,    '2026-07-24 15:30:00' FROM nhan_vien WHERE ten_dang_nhap='staff5';
GO

-- Chi tiết hóa đơn cho staff1
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 2, 40000 FROM don_hang WHERE ma_so_don_hang='S1HD001';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 4, 1, 5000  FROM don_hang WHERE ma_so_don_hang='S1HD001';

INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 2, 2, 36000 FROM don_hang WHERE ma_so_don_hang='S1HD002';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 4, 1, 2000  FROM don_hang WHERE ma_so_don_hang='S1HD002';

INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 3, 60000 FROM don_hang WHERE ma_so_don_hang='S1HD003';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 3, 1, 10000 FROM don_hang WHERE ma_so_don_hang='S1HD003';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 4, 1, 2000  FROM don_hang WHERE ma_so_don_hang='S1HD003';

INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 1, 20000 FROM don_hang WHERE ma_so_don_hang='S1HD004';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 4, 1, 5000  FROM don_hang WHERE ma_so_don_hang='S1HD004';

INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 2, 40000 FROM don_hang WHERE ma_so_don_hang='S1HD005';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 3, 1, 10000 FROM don_hang WHERE ma_so_don_hang='S1HD005';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 4, 1, 6000  FROM don_hang WHERE ma_so_don_hang='S1HD005';

-- Chi tiết hóa đơn cho staff2
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 1, 20000 FROM don_hang WHERE ma_so_don_hang='S2HD001';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 3, 60000 FROM don_hang WHERE ma_so_don_hang='S2HD002';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 1, 20000 FROM don_hang WHERE ma_so_don_hang='S2HD003';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 3, 1, 10000 FROM don_hang WHERE ma_so_don_hang='S2HD003';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 4, 1, 5000  FROM don_hang WHERE ma_so_don_hang='S2HD003';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 4, 80000 FROM don_hang WHERE ma_so_don_hang='S2HD004';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 3, 1, 10000 FROM don_hang WHERE ma_so_don_hang='S2HD004';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 2, 40000 FROM don_hang WHERE ma_so_don_hang='S2HD005';

-- Chi tiết hóa đơn cho staff3
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 2, 40000 FROM don_hang WHERE ma_so_don_hang='S3HD001';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 3, 1, 10000 FROM don_hang WHERE ma_so_don_hang='S3HD001';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 4, 1, 5000  FROM don_hang WHERE ma_so_don_hang='S3HD001';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 1, 20000 FROM don_hang WHERE ma_so_don_hang='S3HD002';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 3, 1, 10000 FROM don_hang WHERE ma_so_don_hang='S3HD002';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 4, 80000 FROM don_hang WHERE ma_so_don_hang='S3HD003';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 2, 40000 FROM don_hang WHERE ma_so_don_hang='S3HD004';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 2, 1, 8000  FROM don_hang WHERE ma_so_don_hang='S3HD004';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 1, 20000 FROM don_hang WHERE ma_so_don_hang='S3HD005';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 4, 1, 2000  FROM don_hang WHERE ma_so_don_hang='S3HD005';

-- Chi tiết hóa đơn cho staff4
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 3, 60000 FROM don_hang WHERE ma_so_don_hang='S4HD001';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 4, 1, 5000  FROM don_hang WHERE ma_so_don_hang='S4HD001';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 2, 40000 FROM don_hang WHERE ma_so_don_hang='S4HD002';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 4, 1, 3000  FROM don_hang WHERE ma_so_don_hang='S4HD002';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 1, 20000 FROM don_hang WHERE ma_so_don_hang='S4HD003';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 2, 1, 8000  FROM don_hang WHERE ma_so_don_hang='S4HD003';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 3, 60000 FROM don_hang WHERE ma_so_don_hang='S4HD004';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 3, 1, 10000 FROM don_hang WHERE ma_so_don_hang='S4HD004';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 4, 1, 5000  FROM don_hang WHERE ma_so_don_hang='S4HD004';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 2, 40000 FROM don_hang WHERE ma_so_don_hang='S4HD005';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 3, 1, 10000 FROM don_hang WHERE ma_so_don_hang='S4HD005';

-- Chi tiết hóa đơn cho staff5
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 1, 20000 FROM don_hang WHERE ma_so_don_hang='S5HD001';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 2, 1, 13000 FROM don_hang WHERE ma_so_don_hang='S5HD001';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 2, 40000 FROM don_hang WHERE ma_so_don_hang='S5HD002';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 3, 1, 10000 FROM don_hang WHERE ma_so_don_hang='S5HD002';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 4, 1, 8000  FROM don_hang WHERE ma_so_don_hang='S5HD002';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 2, 40000 FROM don_hang WHERE ma_so_don_hang='S5HD003';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 4, 1, 2000  FROM don_hang WHERE ma_so_don_hang='S5HD003';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 3, 60000 FROM don_hang WHERE ma_so_don_hang='S5HD004';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 3, 1, 8000  FROM don_hang WHERE ma_so_don_hang='S5HD004';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 1, 1, 20000 FROM don_hang WHERE ma_so_don_hang='S5HD005';
INSERT INTO chi_tiet_don_hang(order_id, product_id, so_luong, gia_ban) SELECT id, 4, 1, 7000  FROM don_hang WHERE ma_so_don_hang='S5HD005';
