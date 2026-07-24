<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="/views/layout/header.jsp" %>
<title>Quản Lý Kho Nguyên Liệu - Tiệm Bánh Mì</title>
<style>
.inv-grid { display: grid; grid-template-columns: 320px 1fr; gap: 24px; }
.stock-badge-good { background: #dcfce7; color: #166534; font-weight: 600; padding: 4px 10px; border-radius: 12px; font-size: 12px; }
.stock-badge-warn { background: #fef3c7; color: #92400e; font-weight: 600; padding: 4px 10px; border-radius: 12px; font-size: 12px; }
.stock-badge-danger { background: #fee2e2; color: #991b1b; font-weight: 600; padding: 4px 10px; border-radius: 12px; font-size: 12px; }

.btn-stock-in { background: #10b981; color: #fff; border: none; padding: 5px 10px; border-radius: 6px; font-size: 12px; font-weight: 600; cursor: pointer; transition: 0.2s; }
.btn-stock-in:hover { background: #059669; }
.btn-stock-out { background: #f59e0b; color: #fff; border: none; padding: 5px 10px; border-radius: 6px; font-size: 12px; font-weight: 600; cursor: pointer; transition: 0.2s; }
.btn-stock-out:hover { background: #d97706; }

/* Modal overlay */
.stock-modal { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); backdrop-filter: blur(3px); z-index: 9999; align-items: center; justify-content: center; }
.stock-modal.active { display: flex; }
.stock-modal-box { background: #fff; padding: 24px; border-radius: 16px; width: 360px; text-align: center; box-shadow: 0 20px 50px rgba(0,0,0,0.2); }
</style>
</head>
<body>
<%@ include file="/views/layout/sidebar.jsp" %>
<div class="main-wrapper">
    <div class="topbar">
        <div class="topbar-title"><i class="fas fa-boxes-stacked" style="color:#f59e0b;margin-right:8px"></i>Quản Lý Kho Nguyên Liệu & Tồn Kho</div>
        <div class="topbar-user">
            <div class="avatar"><%= currentUser.getHoTen().charAt(0) %></div>
            <span><%= currentUser.getHoTen() %></span>
        </div>
    </div>
    <div class="page-content">
        <c:if test="${not empty message}"><div class="alert alert-success"><i class="fas fa-check-circle"></i> ${message}</div></c:if>
        <c:if test="${not empty error}"><div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div></c:if>

        <!-- Thống kê kho tổng quan -->
        <div class="stats-grid" style="margin-bottom: 24px;">
            <div class="stat-card">
                <div class="stat-icon orange"><i class="fas fa-boxes-stacked"></i></div>
                <div class="stat-info">
                    <div class="val">${tongMatHang}</div>
                    <div class="lbl">Tổng Mặt Hàng Kho</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon blue" style="background:#fef3c7;color:#d97706"><i class="fas fa-exclamation-triangle"></i></div>
                <div class="stat-info">
                    <div class="val" style="color:#d97706">${sapHet}</div>
                    <div class="lbl">Nguyên Liệu Sắp Hết</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon red" style="background:#fee2e2;color:#ef4444"><i class="fas fa-times-circle"></i></div>
                <div class="stat-info">
                    <div class="val" style="color:#ef4444">${daHet}</div>
                    <div class="lbl">Nguyên Liệu Đã Hết</div>
                </div>
            </div>
        </div>

        <div class="inv-grid">
            <!-- Form Thêm / Sửa nguyên liệu kho -->
            <div class="card" style="align-self:start">
                <div class="card-header">
                    <h5>${not empty topping ? "✏️ Sửa Nguyên Liệu" : "➕ Thêm Nguyên Liệu Mới"}</h5>
                    <c:if test="${not empty topping}"><a href="${pageContext.request.contextPath}/manager/topping" class="btn btn-secondary btn-sm">Huỷ</a></c:if>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/manager/topping/${not empty topping ? 'edit' : 'add'}">
                        <c:if test="${not empty topping}"><input type="hidden" name="id" value="${topping.id}"></c:if>
                        
                        <div class="form-group">
                            <label class="form-label">Tên Nguyên Liệu / Món Kho *</label>
                            <input type="text" name="tenNguyenLieu" class="form-control" value="${topping.tenNguyenLieu}" required placeholder="VD: Trứng, Pate, Chả lụa...">
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Đơn Vị Tính</label>
                            <select name="donViTinh" class="form-control">
                                <option value="Phần" ${topping.donViTinh == 'Phần' ? 'selected' : ''}>Phần</option>
                                <option value="Quả" ${topping.donViTinh == 'Quả' ? 'selected' : ''}>Quả</option>
                                <option value="Kg" ${topping.donViTinh == 'Kg' ? 'selected' : ''}>Kg</option>
                                <option value="Ổ" ${topping.donViTinh == 'Ổ' ? 'selected' : ''}>Ổ</option>
                                <option value="Thanh" ${topping.donViTinh == 'Thanh' ? 'selected' : ''}>Thanh</option>
                                <option value="Khay" ${topping.donViTinh == 'Khay' ? 'selected' : ''}>Khay</option>
                                <option value="Hộp" ${topping.donViTinh == 'Hộp' ? 'selected' : ''}>Hộp</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Số Lượng Tồn Ban Đầu</label>
                            <input type="number" name="soLuongTon" class="form-control" value="${not empty topping ? topping.soLuongTon : 50}" required min="0">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Giá Bán Topping (VNĐ)</label>
                            <input type="number" name="giaCongThem" class="form-control" value="${topping.giaCongThem}" placeholder="5000">
                        </div>

                        <c:if test="${not empty topping}">
                        <div class="form-group">
                            <label class="form-label">Trạng Thái</label>
                            <select name="active" class="form-control">
                                <option value="1" ${topping.active ? 'selected' : ''}>Kích hoạt</option>
                                <option value="0" ${!topping.active ? 'selected' : ''}>Ẩn khỏi kho</option>
                            </select>
                        </div>
                        </c:if>

                        <button type="submit" class="btn btn-primary" style="width:100%"><i class="fas fa-save"></i> ${not empty topping ? "Lưu Thay Đổi" : "Thêm Vào Kho"}</button>
                    </form>
                </div>
            </div>

            <!-- Bảng danh sách tồn kho -->
            <div class="card">
                <div class="card-header"><h5>📦 Bảng Quản Lý Tồn Kho & Nhập/Xuất Hàng</h5></div>
                <div style="overflow-x:auto">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Tên Nguyên Liệu</th>
                                <th>Đơn Vị</th>
                                <th>Giá Bán</th>
                                <th>Tồn Kho</th>
                                <th>Trạng Thái</th>
                                <th>Nhập / Xuất Kho</th>
                                <th>Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="t" items="${list}" varStatus="i">
                            <tr>
                                <td>${i.index + 1}</td>
                                <td><strong><c:out value="${t.tenNguyenLieu}"/></strong></td>
                                <td><span class="badge badge-secondary">${t.donViTinh}</span></td>
                                <td style="color:#f59e0b;font-weight:600"><fmt:formatNumber value="${t.giaCongThem}" pattern="#,###"/>đ</td>
                                <td><strong style="font-size:15px">${t.soLuongTon}</strong> ${t.donViTinh}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${t.soLuongTon > 20}">
                                            <span class="stock-badge-good"><i class="fas fa-check-circle"></i> Còn hàng</span>
                                        </c:when>
                                        <c:when test="${t.soLuongTon > 0}">
                                            <span class="stock-badge-warn"><i class="fas fa-exclamation-triangle"></i> Sắp hết</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="stock-badge-danger"><i class="fas fa-times-circle"></i> Hết hàng</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div style="display:flex;gap:4px">
                                        <button type="button" class="btn-stock-in" onclick="openNhapModal(${t.id}, '<c:out value="${t.tenNguyenLieu}"/>', '${t.donViTinh}')"><i class="fas fa-arrow-down"></i> Nhập</button>
                                        <button type="button" class="btn-stock-out" onclick="openXuatModal(${t.id}, '<c:out value="${t.tenNguyenLieu}"/>', '${t.donViTinh}')"><i class="fas fa-arrow-up"></i> Xuất</button>
                                    </div>
                                </td>
                                <td>
                                    <a href="?id=${t.id}" class="btn btn-info btn-sm" title="Sửa"><i class="fas fa-edit"></i></a>
                                    <form method="post" action="${pageContext.request.contextPath}/manager/topping/delete" style="display:inline" onsubmit="return confirm('Ẩn nguyên liệu này khỏi kho?')">
                                        <input type="hidden" name="id" value="${t.id}">
                                        <button type="submit" class="btn btn-danger btn-sm" title="Xóa"><i class="fas fa-trash"></i></button>
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

<!-- Modal Nhập Kho -->
<div class="stock-modal" id="nhapModal">
    <div class="stock-modal-box">
        <h4 style="margin-top:0;color:#10b981"><i class="fas fa-arrow-down"></i> Nhập Kho Nguyên Liệu</h4>
        <p id="nhapTitle" style="font-weight:600;color:#333"></p>
        <form method="post" action="${pageContext.request.contextPath}/manager/topping/nhapkho">
            <input type="hidden" name="id" id="nhapId">
            <div class="form-group" style="margin:16px 0">
                <label class="form-label">Số Lượng Nhập Thêm</label>
                <input type="number" name="soLuongNhap" class="form-control" value="10" min="1" required>
            </div>
            <button type="submit" class="btn btn-success" style="width:100%"><i class="fas fa-plus-circle"></i> Xác Nhận Nhập Kho</button>
            <button type="button" class="btn btn-secondary" onclick="closeStockModals()" style="width:100%;margin-top:8px">Hủy</button>
        </form>
    </div>
</div>

<!-- Modal Xuất Kho -->
<div class="stock-modal" id="xuatModal">
    <div class="stock-modal-box">
        <h4 style="margin-top:0;color:#f59e0b"><i class="fas fa-arrow-up"></i> Xuất Kho Nguyên Liệu</h4>
        <p id="xuatTitle" style="font-weight:600;color:#333"></p>
        <form method="post" action="${pageContext.request.contextPath}/manager/topping/xuatkho">
            <input type="hidden" name="id" id="xuatId">
            <div class="form-group" style="margin:16px 0">
                <label class="form-label">Số Lượng Xuất Hàng</label>
                <input type="number" name="soLuongXuat" class="form-control" value="5" min="1" required>
            </div>
            <button type="submit" class="btn btn-warning" style="width:100%;color:#fff"><i class="fas fa-minus-circle"></i> Xác Nhận Xuất Kho</button>
            <button type="button" class="btn btn-secondary" onclick="closeStockModals()" style="width:100%;margin-top:8px">Hủy</button>
        </form>
    </div>
</div>

<script>
function openNhapModal(id, name, unit) {
    document.getElementById('nhapId').value = id;
    document.getElementById('nhapTitle').textContent = name + ' (' + unit + ')';
    document.getElementById('nhapModal').classList.add('active');
}
function openXuatModal(id, name, unit) {
    document.getElementById('xuatId').value = id;
    document.getElementById('xuatTitle').textContent = name + ' (' + unit + ')';
    document.getElementById('xuatModal').classList.add('active');
}
function closeStockModals() {
    document.getElementById('nhapModal').classList.remove('active');
    document.getElementById('xuatModal').classList.remove('active');
}
</script>
</body></html>
