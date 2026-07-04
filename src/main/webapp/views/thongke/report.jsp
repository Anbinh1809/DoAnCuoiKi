<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="/views/layout/header.jsp" %>
<title>Thống Kê & Báo Cáo - Tiệm Bánh Mì</title>
<style>
.money-big { font-size: 28px; font-weight: 800; color: #f59e0b; }
.report-table tfoot td { font-size: 15px; }
.report-table .money-cell { font-weight: 700; color: #f59e0b; font-size: 15px; }
.badge-completed { background: #d1fae5; color: #065f46; font-size: 11px; padding: 3px 10px; border-radius: 20px; font-weight: 600; }
.badge-pending   { background: #fef3c7; color: #92400e; font-size: 11px; padding: 3px 10px; border-radius: 20px; font-weight: 600; }
.summary-total-row { background: linear-gradient(90deg, #fef9c3, #fffbeb); }
.summary-total-row td { padding: 16px !important; }
</style>
</head>
<body>
<%@ include file="/views/layout/sidebar.jsp" %>
<div class="main-wrapper">
    <div class="topbar">
        <div class="topbar-title"><i class="fas fa-chart-bar" style="color:#f59e0b;margin-right:8px"></i>Thống Kê & Báo Cáo Doanh Thu</div>
        <div class="topbar-user">
            <div class="avatar"><%= currentUser.getHoTen().charAt(0) %></div>
            <span><%= currentUser.getHoTen() %></span>
        </div>
    </div>
    <div class="page-content">

        <!-- Bộ lọc ngày -->
        <div class="card">
            <div class="card-header"><h5><i class="fas fa-filter" style="color:#f59e0b;margin-right:8px"></i>Lọc Theo Thời Gian</h5></div>
            <div class="card-body">
                <form method="get" action="${pageContext.request.contextPath}/thongke" style="display:flex;gap:16px;align-items:flex-end;flex-wrap:wrap">
                    <div class="form-group" style="margin:0;flex:1">
                        <label class="form-label">Từ Ngày</label>
                        <input type="date" name="tuNgay" class="form-control" value="${tuNgay}">
                    </div>
                    <div class="form-group" style="margin:0;flex:1">
                        <label class="form-label">Đến Ngày</label>
                        <input type="date" name="denNgay" class="form-control" value="${denNgay}">
                    </div>
                    <button type="submit" class="btn btn-primary"><i class="fas fa-search"></i> Xem Báo Cáo</button>
                    <a href="${pageContext.request.contextPath}/thongke" class="btn btn-secondary">Reset</a>
                </form>
            </div>
        </div>

        <!-- Tổng doanh thu -->
        <div class="stats-grid" style="grid-template-columns:repeat(2,1fr)">
            <div class="stat-card">
                <div class="stat-icon orange"><i class="fas fa-coins"></i></div>
                <div>
                    <div class="money-big"><fmt:formatNumber value="${tongDoanhThu}" pattern="#,###"/> đ</div>
                    <div class="stat-label">Tổng Doanh Thu</div>
                    <c:if test="${not empty tuNgay and not empty denNgay}">
                        <div style="font-size:12px;color:#888;margin-top:4px">
                            <i class="fas fa-calendar"></i> ${tuNgay} → ${denNgay}
                        </div>
                    </c:if>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon blue"><i class="fas fa-receipt"></i></div>
                <div>
                    <div class="stat-value">${list.size()}</div>
                    <div class="stat-label">Số Hóa Đơn</div>
                    <div style="font-size:12px;color:#10b981;margin-top:4px">
                        <i class="fas fa-check-circle"></i> Đã hoàn thành
                    </div>
                </div>
            </div>
        </div>

        <!-- Bảng chi tiết -->
        <div class="card">
            <div class="card-header">
                <h5><i class="fas fa-list-alt" style="color:#f59e0b;margin-right:8px"></i>Chi Tiết Hóa Đơn</h5>
                <c:if test="${not empty list}">
                    <span style="font-size:13px;color:#888">${list.size()} hóa đơn</span>
                </c:if>
            </div>
            <div style="overflow-x:auto">
                <table class="table report-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Mã HĐ</th>
                            <th>Ngày Tạo</th>
                            <th>Nhân Viên</th>
                            <th>Phương Thức TT</th>
                            <th>Trạng Thái</th>
                            <th style="text-align:right">Tổng Tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="dh" items="${list}" varStatus="i">
                        <tr>
                            <td style="color:#999;font-size:13px">${i.index + 1}</td>
                            <td><strong style="color:#1a1a2e">${dh.maSoDonHang}</strong></td>
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
                            <td>
                                <c:choose>
                                    <c:when test="${dh.trangThai == 'COMPLETED'}">
                                        <span class="badge-completed">✓ Hoàn thành</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-pending">${dh.trangThai}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="money-cell" style="text-align:right">
                                <fmt:formatNumber value="${dh.tongTien}" pattern="#,###"/> đ
                            </td>
                        </tr>
                        </c:forEach>
                        <c:if test="${empty list}">
                            <tr><td colspan="7" style="text-align:center;color:#aaa;padding:40px">
                                <i class="fas fa-inbox" style="font-size:32px;display:block;margin-bottom:10px"></i>
                                Không có dữ liệu trong khoảng thời gian này
                            </td></tr>
                        </c:if>
                    </tbody>
                    <tfoot>
                        <tr class="summary-total-row">
                            <td colspan="6" style="text-align:right;font-weight:700;color:#555">
                                <i class="fas fa-calculator" style="margin-right:6px"></i>Tổng cộng (${list.size()} hóa đơn):
                            </td>
                            <td style="text-align:right;font-weight:800;font-size:18px;color:#d97706">
                                <fmt:formatNumber value="${tongDoanhThu}" pattern="#,###"/> đ
                            </td>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </div>
    </div>
</div>
</body></html>
