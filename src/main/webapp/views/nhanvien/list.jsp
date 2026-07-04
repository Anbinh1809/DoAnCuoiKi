<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="/views/layout/header.jsp" %>
<title>Nhân Viên - Tiệm Bánh Mì</title>
</head>
<body>
<%@ include file="/views/layout/sidebar.jsp" %>
<div class="main-wrapper">
    <div class="topbar">
        <div class="topbar-title"><i class="fas fa-users" style="color:#f59e0b;margin-right:8px"></i>Quản lý Nhân Viên</div>
        <div class="topbar-user">
            <div class="avatar"><%= currentUser.getHoTen().charAt(0) %></div>
            <span><%= currentUser.getHoTen() %></span>
        </div>
    </div>
    <div class="page-content">
        <c:if test="${not empty message}"><div class="alert alert-success"><i class="fas fa-check-circle"></i> ${message}</div></c:if>
        <c:if test="${not empty error}"><div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div></c:if>

        <div style="display:grid;grid-template-columns:1fr 1.5fr;gap:24px">
            <div class="card">
                <div class="card-header">
                    <h5>${not empty nhanVien ? "✏️ Sửa Nhân Viên" : "➕ Thêm Nhân Viên"}</h5>
                    <c:if test="${not empty nhanVien}"><a href="${pageContext.request.contextPath}/manager/nhanvien" class="btn btn-secondary btn-sm">Huỷ</a></c:if>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/manager/nhanvien/${not empty nhanVien ? 'edit' : 'add'}">
                        <c:if test="${not empty nhanVien}"><input type="hidden" name="id" value="${nhanVien.id}"></c:if>
                        <c:if test="${empty nhanVien}">
                        <div class="form-group">
                            <label class="form-label">Tên Đăng Nhập *</label>
                            <input type="text" name="tenDangNhap" class="form-control" required placeholder="VD: nv001">
                        </div>
                        </c:if>
                        <div class="form-group">
                            <label class="form-label">Họ Tên *</label>
                            <input type="text" name="hoTen" class="form-control" value="${nhanVien.hoTen}" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Số Điện Thoại</label>
                            <input type="text" name="dienThoai" class="form-control" value="${nhanVien.dienThoai}">
                        </div>
                        <div class="form-group">
                            <label class="form-label">${not empty nhanVien ? "Mật Khẩu Mới (để trống nếu không đổi)" : "Mật Khẩu *"}</label>
                            <input type="password" name="matKhau" class="form-control" ${empty nhanVien ? 'required' : ''} placeholder="Nhập mật khẩu">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Vai Trò</label>
                            <select name="vaiTro" class="form-control">
                                <option value="0" ${!nhanVien.vaiTro ? 'selected' : ''}>Nhân viên</option>
                                <option value="1" ${nhanVien.vaiTro ? 'selected' : ''}>Quản lý (Admin)</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary" style="width:100%"><i class="fas fa-save"></i> ${not empty nhanVien ? "Lưu" : "Thêm Nhân Viên"}</button>
                    </form>
                </div>
            </div>

            <div class="card">
                <div class="card-header"><h5>Danh Sách Nhân Viên</h5></div>
                <div style="overflow-x:auto">
                    <table class="table">
                        <thead><tr><th>#</th><th>Họ Tên</th><th>Tên ĐN</th><th>SĐT</th><th>Vai Trò</th><th>T.Thái</th><th>Thao Tác</th></tr></thead>
                        <tbody>
                            <c:forEach var="nv" items="${list}" varStatus="i">
                            <tr>
                                <td>${i.index + 1}</td>
                                <td><strong><c:out value="${nv.hoTen}"/></strong></td>
                                <td><c:out value="${nv.tenDangNhap}"/></td>
                                <td><c:out value="${nv.dienThoai}"/></td>
                                <td><span class="badge ${nv.vaiTro ? 'badge-warning' : 'badge-success'}">${nv.vaiTro ? 'Quản lý' : 'Nhân viên'}</span></td>
                                <td><span class="badge ${nv.active ? 'badge-success' : 'badge-danger'}">${nv.active ? 'Active' : 'Inactive'}</span></td>
                                <td>
                                    <a href="?id=${nv.id}" class="btn btn-info btn-sm"><i class="fas fa-edit"></i></a>
                                    <form method="post" action="${pageContext.request.contextPath}/manager/nhanvien/delete" style="display:inline" onsubmit="return confirm('Vô hiệu hóa nhân viên này?')">
                                        <input type="hidden" name="id" value="${nv.id}">
                                        <button type="submit" class="btn btn-danger btn-sm"><i class="fas fa-ban"></i></button>
                                    </form>
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
