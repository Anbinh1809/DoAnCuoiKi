# 🥖 HỆ THỐNG QUẢN LÝ TIỆM BÁNH MÌ (WEBBANHMI)

> **Đồ Án Cuối Kỳ** - Hệ thống quản lý bán hàng, tồn kho nguyên liệu và thống kê doanh thu tiệm bánh mì chuyên nghiệp.

---

## 🛠️ Công Nghệ Sử Dụng (Tech Stack)
- **Backend**: Java 17, Jakarta Servlet / JSP, JDBC
- **Database**: Microsoft SQL Server
- **Frontend**: HTML5, CSS3 Vanilla, JavaScript (ES6+), FontAwesome Icons, Chart.js
- **Build Tool**: Maven

---

## ✨ Tính Năng Nổi Bật

### 1. 📊 Dashboard Tổng Quan & Biểu Đồ Doanh Thu
- Biểu đồ cột chồng (**Stacked Bar Chart**) theo dõi doanh thu 7 ngày gần nhất chi tiết theo từng ca / nhân viên.
- Thống kê nhanh tổng doanh thu, tổng hóa đơn hoàn thành, số lượng sản phẩm đang bán và số nhân viên đang hoạt động.
- Danh sách hóa đơn gần nhất cập nhật theo thời gian thực.

### 2. 🛒 Hệ Thống POS Bán Hàng Nhanh
- Giao diện bán hàng trực quan, dễ thao tác cho nhân viên.
- Cho phép chọn món, tùy chỉnh topping đi kèm (Trứng ốp la, Pate, Chả lụa, Thịt nướng...).
- Tính tổng tiền tự động, hỗ trợ nhiều phương thức thanh toán (Tiền mặt, Chuyển khoản / Momo).

### 3. 📦 Quản Lý Kho Nguyên Liệu & Tồn Kho (Topping)
- Quản lý danh mục nguyên liệu kho (đơn vị tính: Phần, Quả, Kg, Hộp, Cây...).
- Theo dõi số lượng tồn kho tự động với cảnh báo trực quan: **Còn hàng**, **Sắp hết**, **Hết hàng**.
- Tính năng **Nhập Kho** và **Xuất Kho** nhanh chóng ngay tại giao diện.

### 4. 🍔 Quản Lý Thực Đơn (Sản Phẩm & Loại Sản Phẩm)
- Quản lý danh mục bánh mì thịt, bánh mì chay, đồ uống và món ăn kèm.
- Thêm mới, chỉnh sửa giá bán, ảnh sản phẩm, mô tả và chuyển trạng thái ẩn/hiện sản phẩm.

### 5. 👥 Quản Lý Nhân Viên & Phân Quyền (RBAC)
- Phân quyền người dùng: **Admin** (Quản trị hệ thống) & **Staff** (Nhân viên bán hàng).
- Danh sách nhân viên mẫu: `Đặng Phi Hùng`, `Lê Bình An`, `Đinh Ngọc Đại`, `Đinh Tiến Lộc`, `Tôn Trần Triệu Vĩ`.

### 6. 📈 Báo Cáo & Thống Kê Chi Tiết
- Lọc lịch sử hóa đơn và tổng doanh thu theo khoảng thời gian tùy chọn (`TuNgay` -> `DenNgay`).
- Lọc doanh thu riêng cho từng nhân viên hoặc toàn cửa hàng.
- Xem chi tiết từng hóa đơn bao gồm danh sách món ăn, số lượng và topping kèm theo.

---

## 🗄️ Cấu Trúc Cơ Sở Dữ Liệu & Hướng Dẫn Cài Đặt

Dự án đi kèm 2 file kịch bản SQL Server được chuẩn hóa:

1. **[full_database.sql](file:///c:/Users/PC/eclipse-workspace/DoAnCuoiKi-main/DoAnCuoiKi-main/DoAnCuoiKi-main/full_database.sql)**: 
   - Dùng để tạo mới CSDL `webbanhmi` từ đầu trên SQL Server.
   - Bao gồm toàn bộ 8 bảng chuẩn, dữ liệu thực đơn, tồn kho topping và 138 hóa đơn mẫu 7 ngày.

2. **[update_database.sql](file:///c:/Users/PC/eclipse-workspace/DoAnCuoiKi-main/DoAnCuoiKi-main/DoAnCuoiKi-main/update_database.sql)**: 
   - Dùng để cập nhật an toàn cho CSDL đã có sẵn trên máy (bổ sung cột `so_luong_ton`, `don_vi_tinh` và nạp dữ liệu mẫu 7 ngày).

### 🚀 Hướng dẫn nạp CSDL trên SQL Server:
1. Mở **SQL Server Management Studio (SSMS)**.
2. Mở file `full_database.sql` (hoặc `update_database.sql`).
3. Nhấn **Execute (F5)** để thực thi.

---

## 🔑 Tài Khoản Đăng Nhập Mẫu

| Tài khoản (Username) | Mật khẩu (Password) | Họ và Tên | Vai trò |
|---|---|---|---|
| `admin` | `123` | Quản Trị Viên | **Admin** |
| `staff1` | `123` | Đặng Phi Hùng | **Staff** |
| `staff2` | `123` | Lê Bình An | **Staff** |
| `staff3` | `123` | Đinh Ngọc Đại | **Staff** |
| `staff4` | `123` | Đinh Tiến Lộc | **Staff** |
| `staff5` | `123` | Tôn Trần Triệu Vĩ | **Staff** |
