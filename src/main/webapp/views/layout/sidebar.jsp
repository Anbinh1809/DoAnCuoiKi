<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="sidebar">
    <div class="sidebar-logo">
        <span class="logo-icon">🥖</span>
        <div>
            <h2>Tiệm Bánh Mì</h2>
            <span>Quản lý hệ thống</span>
        </div>
    </div>
    <div class="sidebar-user">
        <div class="user-name"><i class="fas fa-user-circle"></i> <%= currentUser != null ? currentUser.getHoTen() : "" %></div>
        <span class="user-role"><%= isAdmin ? "Quản lý" : "Nhân viên" %></span>
    </div>

    <div class="nav-section">
        <div class="nav-label">Tổng quan</div>
        <a href="<%= request.getContextPath() %>/home" class="nav-item <%= currentUri.contains("/home") ? "active" : "" %>">
            <i class="fas fa-chart-pie"></i> Dashboard
        </a>
    </div>

    <div class="nav-section">
        <div class="nav-label">Nghiệp vụ</div>
        <a href="<%= request.getContextPath() %>/banhang" class="nav-item <%= currentUri.contains("/banhang") ? "active" : "" %>">
            <i class="fas fa-cash-register"></i> Bán Hàng (POS)
        </a>
        <a href="<%= request.getContextPath() %>/sanpham" class="nav-item <%= currentUri.contains("/sanpham") ? "active" : "" %>">
            <i class="fas fa-bread-slice"></i> Quản lý Menu
        </a>
        <a href="<%= request.getContextPath() %>/manager/topping" class="nav-item <%= currentUri.contains("/topping") ? "active" : "" %>">
            <i class="fas fa-boxes-stacked"></i> Kho Nguyên Liệu
        </a>
    </div>

    <% if (isAdmin) { %>
    <div class="nav-section">
        <div class="nav-label">Quản lý</div>
        <a href="<%= request.getContextPath() %>/manager/nhanvien" class="nav-item <%= currentUri.contains("/nhanvien") ? "active" : "" %>">
            <i class="fas fa-users"></i> Nhân viên
        </a>
        <a href="<%= request.getContextPath() %>/thongke" class="nav-item <%= currentUri.contains("/thongke") ? "active" : "" %>">
            <i class="fas fa-chart-bar"></i> Thống kê &amp; Báo cáo
        </a>
    </div>
    <% } %>

    <div class="sidebar-footer">
        <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
            <i class="fas fa-sign-out-alt"></i> Đăng Xuất
        </a>
    </div>
</div>
