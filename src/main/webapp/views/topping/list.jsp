<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="/views/layout/header.jsp" %>
<title>Kho Nguyên Liệu - Tiệm Bánh Mì</title>
</head>
<body>
<%@ include file="/views/layout/sidebar.jsp" %>
<div class="main-wrapper">
    <div class="topbar">
        <div class="topbar-title"><i class="fas fa-boxes-stacked" style="color:#f59e0b;margin-right:8px"></i>Quản lý Kho Nguyên Liệu / Topping</div>
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
                    <h5>${not empty topping ? "✏️ Sửa Nguyên Liệu" : "➕ Thêm Nguyên Liệu"}</h5>
                    <c:if test="${not empty topping}"><a href="${pageContext.request.contextPath}/manager/topping" class="btn btn-secondary btn-sm">Huỷ</a></c:if>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/manager/topping/${not empty topping ? 'edit' : 'add'}">
                        <c:if test="${not empty topping}"><input type="hidden" name="id" value="${topping.id}"></c:if>
                        <div class="form-group">
                            <label class="form-label">Tên Nguyên Liệu / Topping *</label>
                            <input type="text" name="tenNguyenLieu" class="form-control" value="${topping.tenNguyenLieu}" required placeholder="VD: Trứng ốp la, Pate...">
                        </div>
                        <div class="form-group">
                            <label class="form-label">Giá Cộng Thêm (VNĐ)</label>
                            <input type="number" name="giaCongThem" class="form-control" value="${topping.giaCongThem}" placeholder="5000">
                        </div>
                        <c:if test="${not empty topping}">
                        <div class="form-group">
                            <label class="form-label">Trạng Thái</label>
                            <select name="active" class="form-control">
                                <option value="1" ${topping.active ? 'selected' : ''}>Còn hàng</option>
                                <option value="0" ${!topping.active ? 'selected' : ''}>Hết hàng</option>
                            </select>
                        </div>
                        </c:if>
                        <button type="submit" class="btn btn-primary" style="width:100%"><i class="fas fa-save"></i> ${not empty topping ? "Lưu" : "Thêm"}</button>
                    </form>
                </div>
            </div>

            <div class="card">
                <div class="card-header"><h5>Danh Sách Nguyên Liệu / Topping</h5></div>
                <div style="overflow-x:auto">
                    <table class="table">
                        <thead><tr><th>#</th><th>Tên Nguyên Liệu</th><th>Giá Cộng Thêm</th><th>Trạng Thái</th><th>Thao Tác</th></tr></thead>
                        <tbody>
                            <c:forEach var="t" items="${list}" varStatus="i">
                            <tr>
                                <td>${i.index + 1}</td>
                                <td><strong><c:out value="${t.tenNguyenLieu}"/></strong></td>
                                <td style="color:#f59e0b;font-weight:600"><fmt:formatNumber value="${t.giaCongThem}" pattern="#,###"/>đ</td>
                                <td><span class="badge ${t.active ? 'badge-success' : 'badge-danger'}">${t.active ? 'Còn hàng' : 'Hết hàng'}</span></td>
                                <td>
                                    <a href="?id=${t.id}" class="btn btn-info btn-sm"><i class="fas fa-edit"></i></a>
                                    <form method="post" action="${pageContext.request.contextPath}/manager/topping/delete" style="display:inline" onsubmit="return confirm('Xóa nguyên liệu này?')">
                                        <input type="hidden" name="id" value="${t.id}">
                                        <button type="submit" class="btn btn-danger btn-sm"><i class="fas fa-trash"></i></button>
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
