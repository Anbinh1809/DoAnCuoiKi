<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="/views/layout/header.jsp" %>
<title>Dashboard - Tiệm Bánh Mì</title>
<style>
.stat-change { font-size: 12px; color: #10b981; margin-top: 4px; }
.recent-badge { font-size: 11px; padding: 3px 8px; border-radius: 20px; font-weight: 600; }
.badge-completed { background: #d1fae5; color: #065f46; }
.badge-pending   { background: #fef3c7; color: #92400e; }
.money-cell { font-weight: 700; color: #f59e0b; font-size: 15px; }
.tong-doanh-thu .stat-value { font-size: 26px; }
</style>
</head>
<body>
<%@ include file="/views/layout/sidebar.jsp" %>
<div class="main-wrapper">
    <div class="topbar">
        <div class="topbar-title"><i class="fas fa-chart-pie" style="color:#f59e0b;margin-right:8px"></i>Dashboard</div>
        <div class="topbar-user">
            <div class="avatar"><%= currentUser.getHoTen().charAt(0) %></div>
            <span><%= currentUser.getHoTen() %></span>
        </div>
    </div>
    <div class="page-content">

        <!-- STATS -->
        <div class="stats-grid">
            <div class="stat-card tong-doanh-thu">
                <div class="stat-icon orange"><i class="fas fa-coins"></i></div>
                <div>
                    <div class="stat-value"><fmt:formatNumber value="${tongDoanhThu}" pattern="#,###"/> đ</div>
                    <div class="stat-label">Tổng Doanh Thu</div>
                    <div class="stat-change"><i class="fas fa-arrow-up"></i> Tổng tất cả hóa đơn</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon blue"><i class="fas fa-receipt"></i></div>
                <div>
                    <div class="stat-value">${tongHoaDon}</div>
                    <div class="stat-label">Tổng Hóa Đơn</div>
                    <div class="stat-change"><i class="fas fa-check"></i> Đã hoàn thành</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green"><i class="fas fa-bread-slice"></i></div>
                <div>
                    <div class="stat-value">${tongSanPham}</div>
                    <div class="stat-label">Sản Phẩm</div>
                    <div class="stat-change"><i class="fas fa-store"></i> Đang bán</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon purple"><i class="fas fa-users"></i></div>
                <div>
                    <div class="stat-value">${tongNhanVien}</div>
                    <div class="stat-label">Nhân Viên</div>
                    <div class="stat-change"><i class="fas fa-user-check"></i> Đang hoạt động</div>
                </div>
            </div>
        </div>

        <!-- RECENT ORDERS -->
        <div class="card">
            <div class="card-header">
                <h5><i class="fas fa-clock" style="color:#f59e0b;margin-right:8px"></i>Hóa Đơn Gần Đây</h5>
                <a href="${pageContext.request.contextPath}/thongke" class="btn btn-primary btn-sm">Xem tất cả</a>
            </div>
            <div class="card-body" style="padding:0">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Mã HĐ</th>
                            <th>Ngày Tạo</th>
                            <th>Nhân Viên</th>
                            <th>Thanh Toán</th>
                            <th>Tổng Tiền</th>
                            <th>Trạng Thái</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="dh" items="${dsHoaDonGanDay}">
                        <tr>
                            <td><strong>${dh.maSoDonHang}</strong></td>
                            <td style="font-size:13px;color:#666">${dh.ngayTao}</td>
                            <td><c:out value="${dh.tenNhanVien}"/></td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty dh.tenLoaiThe}">
                                        <i class="fas fa-credit-card" style="color:#f59e0b;margin-right:4px"></i><c:out value="${dh.tenLoaiThe}"/>
                                    </c:when>
                                    <c:otherwise><span style="color:#aaa">Không xác định</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="money-cell">
                                <fmt:formatNumber value="${dh.tongTien}" pattern="#,###"/> đ
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${dh.trangThai == 'COMPLETED'}">
                                        <span class="recent-badge badge-completed">✓ Hoàn thành</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="recent-badge badge-pending">${dh.trangThai}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        </c:forEach>
                        <c:if test="${empty dsHoaDonGanDay}">
                            <tr><td colspan="6" style="text-align:center;color:#aaa;padding:30px">Chưa có hóa đơn nào</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- QUICK ACTIONS -->
        <div class="card">
            <div class="card-header"><h5><i class="fas fa-bolt" style="color:#f59e0b;margin-right:8px"></i>Thao Tác Nhanh</h5></div>
            <div class="card-body" style="display:flex;gap:12px;flex-wrap:wrap">
                <a href="${pageContext.request.contextPath}/banhang" class="btn btn-primary"><i class="fas fa-cash-register"></i> Mở POS Bán Hàng</a>
                <a href="${pageContext.request.contextPath}/sanpham/add" class="btn btn-info"><i class="fas fa-plus"></i> Thêm Sản Phẩm</a>
                <a href="${pageContext.request.contextPath}/manager/topping/add" class="btn btn-success"><i class="fas fa-plus"></i> Thêm Topping</a>
                <% if (isAdmin) { %>
                <a href="${pageContext.request.contextPath}/manager/nhanvien/add" class="btn btn-secondary"><i class="fas fa-user-plus"></i> Thêm Nhân Viên</a>
                <% } %>
            </div>
        </div>
    </div>
</div>
</body></html>
