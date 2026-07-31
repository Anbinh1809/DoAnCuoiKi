<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="/views/layout/header.jsp" %>
<title>Quản Lý Nhân Viên - Tiệm Bánh Mì</title>
</head>
<body>
<%@ include file="/views/layout/sidebar.jsp" %>
<div class="main-wrapper">
    <div class="topbar">
        <div class="topbar-title"><i class="fas fa-users-cog" style="color:#f59e0b;margin-right:8px"></i>Quản Lý Nhân Viên</div>
        <div class="topbar-user">
            <div class="avatar"><%= currentUser.getHoTen().charAt(0) %></div>
            <span><%= currentUser.getHoTen() %></span>
        </div>
    </div>
    <div class="page-content">
        <c:if test="${not empty message}"><div class="alert alert-success"><i class="fas fa-check-circle"></i> ${message}</div></c:if>
        <c:if test="${not empty error}"><div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div></c:if>

        <div style="display:grid;grid-template-columns:1fr 1.5fr;gap:24px">
            <!-- Form Thêm / Sửa Nhân Viên -->
            <div class="card" style="align-self:start">
                <div class="card-header">
                    <h5>${not empty nhanVien ? "✏️ Sửa Thông Tin Nhân Viên" : "➕ Thêm Nhân Viên Mới"}</h5>
                    <c:if test="${not empty nhanVien}"><a href="${pageContext.request.contextPath}/manager/nhanvien" class="btn btn-secondary btn-sm">Huỷ Sửa</a></c:if>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/manager/nhanvien/${not empty nhanVien ? 'edit' : 'add'}">
                        <c:if test="${not empty nhanVien}">
                            <input type="hidden" name="id" value="${nhanVien.id}">
                            <input type="hidden" name="tenDangNhap" value="${nhanVien.tenDangNhap}">
                            <div class="form-group">
                                <label class="form-label">Tên Đăng Nhập</label>
                                <input type="text" class="form-control" value="${nhanVien.tenDangNhap}" readonly disabled style="background:#f3f4f6;color:#6b7280;font-weight:600">
                            </div>
                        </c:if>

                        <c:if test="${empty nhanVien}">
                            <div class="form-group">
                                <label class="form-label">Tên Đăng Nhập *</label>
                                <input type="text" name="tenDangNhap" class="form-control" required placeholder="VD: nv001, staff6...">
                            </div>
                        </c:if>

                        <div class="form-group">
                            <label class="form-label">Họ Và Tên *</label>
                            <input type="text" name="hoTen" class="form-control" value="${nhanVien.hoTen}" required placeholder="VD: Nguyễn Văn A">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Số Điện Thoại</label>
                            <input type="text" name="dienThoai" class="form-control" value="${nhanVien.dienThoai}" placeholder="090XXXXXXX">
                        </div>

                        <div class="form-group">
                            <label class="form-label">${not empty nhanVien ? "Mật Khẩu Mới (để trống nếu không đổi)" : "Mật Khẩu *"}</label>
                            <input type="password" name="matKhau" class="form-control" ${empty nhanVien ? 'required' : ''} placeholder="Nhập mật khẩu">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Vai Trò Hệ Thống</label>
                            <select name="vaiTro" class="form-control">
                                <option value="0" ${!nhanVien.vaiTro ? 'selected' : ''}>Nhân viên bán hàng (Staff)</option>
                                <option value="1" ${nhanVien.vaiTro ? 'selected' : ''}>Quản lý hệ thống (Admin)</option>
                            </select>
                        </div>

                        <c:if test="${not empty nhanVien}">
                        <div class="form-group">
                            <label class="form-label">Trạng Thái Tài Khoản</label>
                            <select name="active" class="form-control">
                                <option value="1" ${nhanVien.active ? 'selected' : ''}>Hoạt động (Active)</option>
                                <option value="0" ${!nhanVien.active ? 'selected' : ''}>Khóa / Vô hiệu hóa (Inactive)</option>
                            </select>
                        </div>
                        </c:if>

                        <button type="submit" class="btn btn-primary" style="width:100%;margin-top:8px"><i class="fas fa-save"></i> ${not empty nhanVien ? "Lưu Thay Đổi" : "Tạo Nhân Viên Mới"}</button>
                    </form>
                </div>
            </div>

            <!-- Bảng Danh Sách Nhân Viên -->
            <div class="card">
                <div class="card-header"><h5>👥 Danh Sách Nhân Viên</h5></div>
                <div style="overflow-x:auto">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Họ Tên</th>
                                <th>Tên ĐN</th>
                                <th>SĐT</th>
                                <th>Vai Trò</th>
                                <th>T.Thái</th>
                                <th>Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="nv" items="${list}" varStatus="i">
                            <tr>
                                <td>${i.index + 1}</td>
                                <td><strong><c:out value="${nv.hoTen}"/></strong></td>
                                <td><code><c:out value="${nv.tenDangNhap}"/></code></td>
                                <td><c:out value="${nv.dienThoai}"/></td>
                                <td><span class="badge ${nv.vaiTro ? 'badge-warning' : 'badge-secondary'}">${nv.vaiTro ? 'Quản lý' : 'Nhân viên'}</span></td>
                                <td><span class="badge ${nv.active ? 'badge-success' : 'badge-danger'}">${nv.active ? 'Active' : 'Inactive'}</span></td>
                                <td>
                                    <div style="display:flex;gap:4px">
                                        <!-- Nút Sửa -->
                                        <a href="${pageContext.request.contextPath}/manager/nhanvien?id=${nv.id}" class="btn btn-info btn-sm" title="Chỉnh sửa thông tin"><i class="fas fa-edit"></i></a>
                                        
                                        <!-- Nút Khóa / Kích hoạt nhanh -->
                                        <a href="${pageContext.request.contextPath}/manager/nhanvien/toggle?id=${nv.id}" class="btn ${nv.active ? 'btn-warning' : 'btn-success'} btn-sm" title="${nv.active ? 'Vô hiệu hóa tài khoản' : 'Kích hoạt lại tài khoản'}"><i class="fas ${nv.active ? 'fa-user-slash' : 'fa-user-check'}"></i></a>
                                        
                                        <!-- Nút Xóa -->
                                        <a href="${pageContext.request.contextPath}/manager/nhanvien/delete?id=${nv.id}" class="btn btn-danger btn-sm" title="Xóa nhân viên" onclick="return confirm('Bạn có chắc chắn muốn xóa nhân viên <c:out value="${nv.hoTen}"/>?')"><i class="fas fa-trash"></i></a>
                                    </div>
                                </td>
                            </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
</body></html>
