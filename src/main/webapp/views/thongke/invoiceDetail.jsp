<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<div style="text-align: left; padding: 10px;">
    <div style="border-bottom: 2px dashed #eee; padding-bottom: 12px; margin-bottom: 12px;">
        <h6 style="color:#d97706; font-weight: 700; margin-bottom: 8px;"><i class="fas fa-receipt"></i> Hóa Đơn: ${donHang.maSoDonHang}</h6>
        <div style="font-size: 13px; color: #666;">
            <div><strong>Ngày tạo:</strong> <fmt:formatDate value="${donHang.ngayTao}" pattern="dd/MM/yyyy HH:mm:ss" /></div>
            <div><strong>Nhân viên:</strong> ${donHang.tenNhanVien}</div>
            <div><strong>Trạng thái:</strong> ${donHang.trangThai}</div>
        </div>
    </div>
    
    <div style="max-height: 300px; overflow-y: auto; padding-right: 8px;">
        <c:forEach var="item" items="${donHang.chiTietList}">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; padding: 8px 0; border-bottom: 1px solid #f5f5f5;">
                <div>
                    <div style="font-weight: 600; font-size: 14px; color: #333;">${item.tenSp}</div>
                    <div style="color: #888; font-size: 12px;"><fmt:formatNumber value="${item.giaBan / item.soLuong}" pattern="#,###"/>đ x ${item.soLuong}</div>
                </div>
                <div style="font-weight: 700; color: #f59e0b;">
                    <fmt:formatNumber value="${item.giaBan}" pattern="#,###"/>đ
                </div>
            </div>
            <c:if test="${not empty item.toppingList}">
                <c:forEach var="t" items="${item.toppingList}">
                    <div style="display: flex; justify-content: space-between; padding: 4px 0 4px 16px; font-size: 13px; border-bottom: 1px dashed #f0f0f0;">
                        <div style="color: #d97706;">+ Topping: ${t.tenNguyenLieu}</div>
                        <div style="color: #f59e0b;">+ <fmt:formatNumber value="${t.giaCongThem * item.soLuong}" pattern="#,###"/>đ</div>
                    </div>
                </c:forEach>
            </c:if>
        </c:forEach>
        <c:if test="${empty donHang.chiTietList}">
            <div style="text-align: center; color: #999; padding: 20px 0;">Không có chi tiết sản phẩm.</div>
        </c:if>
    </div>
    
    <div style="display: flex; justify-content: space-between; align-items: center; padding-top: 16px; margin-top: 12px; border-top: 2px solid #eee;">
        <div style="font-weight: 700; color: #555; font-size: 16px;">Tổng cộng:</div>
        <div style="font-weight: 800; color: #d97706; font-size: 20px;"><fmt:formatNumber value="${donHang.tongTien}" pattern="#,###"/> đ</div>
    </div>
</div>
