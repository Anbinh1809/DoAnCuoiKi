<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="/views/layout/header.jsp" %>
<title>Quản lý Menu - Tiệm Bánh Mì</title>
</head>
<body>
<%@ include file="/views/layout/sidebar.jsp" %>
<div class="main-wrapper">
    <div class="topbar">
        <div class="topbar-title"><i class="fas fa-bread-slice" style="color:#f59e0b;margin-right:8px"></i>Quản lý Menu Sản Phẩm</div>
        <div class="topbar-user">
            <div class="avatar"><%= currentUser.getHoTen().charAt(0) %></div>
            <span><%= currentUser.getHoTen() %></span>
        </div>
    </div>
    <div class="page-content">

        <c:if test="${not empty message}"><div class="alert alert-success"><i class="fas fa-check-circle"></i> ${message}</div></c:if>
        <c:if test="${not empty error}"><div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div></c:if>

        <div style="display:grid;grid-template-columns:1fr 1.5fr;gap:24px">
            <!-- FORM -->
            <div class="card">
                <div class="card-header">
                    <h5>${not empty sanPham ? "✏️ Sửa Sản Phẩm" : "➕ Thêm Sản Phẩm Mới"}</h5>
                    <c:if test="${not empty sanPham}">
                        <a href="${pageContext.request.contextPath}/sanpham" class="btn btn-secondary btn-sm">Huỷ</a>
                    </c:if>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/sanpham/${not empty sanPham ? 'edit' : 'add'}">
                        <c:if test="${not empty sanPham}"><input type="hidden" name="id" value="${sanPham.id}"></c:if>
                        <div class="form-group">
                            <label class="form-label">Tên Sản Phẩm *</label>
                            <input type="text" name="tenSp" class="form-control" value="${sanPham.tenSp}" placeholder="VD: Bánh mì thịt nướng" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Loại Sản Phẩm *</label>
                            <select name="idLoaiSp" class="form-control" required>
                                <option value="">-- Chọn loại --</option>
                                <c:forEach var="loai" items="${listLoai}">
                                    <option value="${loai.id}" ${sanPham.idLoaiSp == loai.id ? 'selected' : ''}>${loai.tenLoai}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Giá Cơ Bản (VNĐ) *</label>
                            <input type="number" name="giaCoBan" class="form-control" value="${sanPham.giaCoBan}" placeholder="20000" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Tên File Ảnh</label>
                            <input type="text" name="anhSp" class="form-control" value="${sanPham.anhSp}" placeholder="banh-mi.jpg">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Mô Tả</label>
                            <textarea name="moTa" class="form-control" rows="3" placeholder="Mô tả ngắn về sản phẩm...">${sanPham.moTa}</textarea>
                        </div>
                        <c:if test="${not empty sanPham}">
                        <div class="form-group">
                            <label class="form-label">Trạng Thái</label>
                            <select name="active" class="form-control">
                                <option value="1" ${sanPham.active ? 'selected' : ''}>Còn hàng</option>
                                <option value="0" ${!sanPham.active ? 'selected' : ''}>Hết hàng</option>
                            </select>
                        </div>
                        </c:if>
                        <button type="submit" class="btn btn-primary" style="width:100%">
                            <i class="fas fa-save"></i> ${not empty sanPham ? "Lưu Thay Đổi" : "Thêm Sản Phẩm"}
                        </button>
                    </form>
                </div>
            </div>

            <!-- LIST -->
            <div class="card">
                <div class="card-header"><h5>Danh Sách Sản Phẩm (${list.size()} món)</h5></div>
                <div style="overflow-x:auto">
                    <table class="table">
                        <thead>
                            <tr><th>#</th><th>Tên Món</th><th>Giá</th><th>Loại</th><th>T.Thái</th><th>Thao Tác</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach var="sp" items="${list}" varStatus="i">
                            <tr>
                                <td>${i.index + 1}</td>
                                <td><strong><c:out value="${sp.tenSp}"/></strong></td>
                                <td style="color:#f59e0b;font-weight:600"><fmt:formatNumber value="${sp.giaCoBan}" pattern="#,###"/>đ</td>
                                <td><c:out value="${not empty sp.tenLoaiSp ? sp.tenLoaiSp : sp.idLoaiSp}"/></td>
                                <td><span class="badge ${sp.active ? 'badge-success' : 'badge-danger'}">${sp.active ? 'Còn hàng' : 'Hết hàng'}</span></td>
                                <td>
                                    <a href="?id=${sp.id}" class="btn btn-info btn-sm"><i class="fas fa-edit"></i></a>
                                    <form method="post" action="${pageContext.request.contextPath}/sanpham/delete" style="display:inline" onsubmit="return confirm('Ẩn sản phẩm này?')">
                                        <input type="hidden" name="id" value="${sp.id}">
                                        <button type="submit" class="btn btn-danger btn-sm"><i class="fas fa-eye-slash"></i></button>
                                    </form>
                                </td>
                            </tr>
                            </c:forEach>
                            <c:if test="${empty list}">
                                <tr><td colspan="6" style="text-align:center;color:#aaa;padding:30px">Chưa có sản phẩm nào</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
</body></html>
