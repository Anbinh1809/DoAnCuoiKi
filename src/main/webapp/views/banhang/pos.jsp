<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ include file="/views/layout/header.jsp" %>
<title>Bán Hàng POS - Tiệm Bánh Mì</title>
<style>
.pos-grid { display: grid; grid-template-columns: 1.2fr 1fr; gap: 24px; }
.product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: 12px; margin-bottom: 16px; }
.product-card { background: #fff; border: 2px solid #e2e8f0; border-radius: 10px; padding: 14px; text-align: center; cursor: pointer; transition: all 0.2s; }
.product-card:hover { border-color: #f59e0b; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(245,158,11,0.2); }
.product-card.selected { border-color: #f59e0b; background: #fef9c3; }
.product-card .price { color: #f59e0b; font-weight: 700; font-size: 15px; }
.product-card .name { font-size: 13px; font-weight: 600; color: #333; margin-bottom: 6px; }
.order-item { display: flex; align-items: center; justify-content: space-between; padding: 12px; background: #f8f9fa; border-radius: 8px; margin-bottom: 8px; }
.order-total { font-size: 22px; font-weight: 700; color: #f59e0b; text-align: right; padding: 16px 0; border-top: 2px solid #f0f0f0; }
.topping-grid { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 8px; }
.topping-chip { display: inline-flex; align-items: center; gap: 4px; padding: 5px 10px; border: 1px solid #e2e8f0; border-radius: 20px; font-size: 12px; cursor: pointer; transition: all 0.2s; }
.topping-chip:hover { border-color: #f59e0b; background: #fef9c3; }
.topping-chip input { display: none; }
.topping-chip.active { border-color: #f59e0b; background: #fef9c3; color: #d97706; font-weight: 600; }

/* ===== INLINE PAYMENT SECTION ===== */
#paymentSection { margin-top: 16px; display: none; }

/* Tiền mặt inline */
#cashInlineBox {
    display: none;
    background: linear-gradient(135deg, #fffbeb, #fef3c7);
    border: 2px solid #f59e0b;
    border-radius: 14px;
    padding: 18px;
    margin-bottom: 14px;
    text-align: center;
}
.cash-inline-icon {
    width: 60px; height: 60px;
    background: linear-gradient(135deg, #d97706, #f59e0b);
    border-radius: 50%; display: flex; align-items: center;
    justify-content: center; margin: 0 auto 12px;
    box-shadow: 0 6px 18px rgba(245,158,11,0.35);
}
.cash-inline-icon i { font-size: 28px; color: #fff; }
.cash-inline-title { font-size: 16px; font-weight: 700; color: #92400e; margin-bottom: 8px; }
.cash-inline-amount { font-size: 30px; font-weight: 900; color: #d97706; margin-bottom: 4px; }
.cash-inline-note { font-size: 12px; color: #a16207; }

/* Momo inline */
#momoInlineBox {
    display: none;
    background: linear-gradient(135deg, #fdf0f7, #ffe4f5);
    border: 2px solid #e91e8c;
    border-radius: 14px;
    padding: 18px;
    margin-bottom: 14px;
    text-align: center;
}
.momo-inline-badge {
    background: linear-gradient(135deg, #ae2070 0%, #d63384 100%);
    color: #fff; font-size: 18px; font-weight: 900;
    border-radius: 10px; padding: 4px 12px; letter-spacing: 1px;
    display: inline-block; margin-bottom: 10px;
}
.momo-inline-title { font-size: 14px; font-weight: 600; color: #7b1044; margin-bottom: 10px; }
.momo-inline-amount { font-size: 24px; font-weight: 900; color: #ae2070; margin-bottom: 6px; }
.momo-inline-note { font-size: 11px; color: #9d174d; line-height: 1.5; }

/* Momo modal styles */
.momo-modal-qr {
    background: #fff; border: 3px solid #e91e8c;
    border-radius: 12px; padding: 10px;
    display: inline-block; margin-bottom: 20px;
}
.momo-modal-qr img { width: 200px; height: 200px; object-fit: contain; display: block; border-radius: 6px; }
.btn-confirm-momo {
    width: 100%; padding: 14px;
    background: linear-gradient(135deg, #ae2070, #e91e8c);
    color: #fff; border: none; border-radius: 12px;
    font-size: 16px; font-weight: 700; cursor: pointer; transition: all 0.2s;
}
.btn-confirm-momo:hover {
    background: linear-gradient(135deg, #7b1044, #ae2070);
    transform: translateY(-1px); box-shadow: 0 6px 20px rgba(233,30,140,0.4);
}

/* Submit button */
.btn-pos-submit {
    width: 100%; padding: 14px;
    background: linear-gradient(135deg, #d97706, #f59e0b);
    color: #fff; border: none; border-radius: 12px;
    font-size: 16px; font-weight: 700; cursor: pointer;
    transition: all 0.2s; margin-top: 4px;
    display: flex; align-items: center; justify-content: center; gap: 8px;
}
.btn-pos-submit:hover {
    background: linear-gradient(135deg, #b45309, #d97706);
    transform: translateY(-1px); box-shadow: 0 6px 20px rgba(217,119,6,0.4);
}

/* ========== MODAL CHUNG ========== */
.modal-overlay {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.6);
    backdrop-filter: blur(4px);
    z-index: 9999;
    align-items: center;
    justify-content: center;
}
.modal-overlay.active { display: flex; }
.modal-box {
    background: #fff;
    border-radius: 20px;
    padding: 32px 28px;
    max-width: 440px;
    width: 92%;
    text-align: center;
    box-shadow: 0 24px 60px rgba(0,0,0,0.3);
    animation: modalSlideIn 0.3s ease;
    position: relative;
}
@keyframes modalSlideIn {
    from { transform: translateY(-30px); opacity: 0; }
    to   { transform: translateY(0);    opacity: 1; }
}
.modal-close-btn {
    position: absolute; top: 14px; right: 18px;
    background: none; border: none; font-size: 22px;
    cursor: pointer; color: #999; line-height: 1;
}
.modal-close-btn:hover { color: #333; }
.modal-title { font-size: 20px; font-weight: 700; color: #1a1a2e; margin-bottom: 4px; }
.modal-subtitle { font-size: 13px; color: #888; margin-bottom: 20px; }

/* TIỀN MẶT MODAL */
.cash-icon-wrap {
    width: 80px; height: 80px;
    background: linear-gradient(135deg, #d97706, #f59e0b);
    border-radius: 50%; display: flex; align-items: center;
    justify-content: center; margin: 0 auto 16px;
    box-shadow: 0 8px 24px rgba(245,158,11,0.35);
}
.cash-icon-wrap i { font-size: 36px; color: #fff; }
.amount-box-cash {
    background: linear-gradient(135deg, #fffbeb, #fef3c7);
    border: 2px solid #f59e0b; border-radius: 16px;
    padding: 18px 20px; margin-bottom: 20px;
}
.amount-label { font-size: 12px; color: #888; margin-bottom: 4px; }
.amount-value-cash { font-size: 36px; font-weight: 900; color: #d97706; }
.invoice-preview {
    background: #f8f9fa; border-radius: 12px;
    padding: 14px 16px; margin-bottom: 20px;
    text-align: left; font-size: 13px; color: #555;
}
.invoice-preview .inv-row { display: flex; justify-content: space-between; padding: 4px 0; }
.invoice-preview .inv-row:last-child { border-top: 1px solid #ddd; margin-top: 6px; padding-top: 10px; font-weight: 700; color: #d97706; }
.btn-confirm-cash {
    width: 100%; padding: 14px;
    background: linear-gradient(135deg, #d97706, #f59e0b);
    color: #fff; border: none; border-radius: 12px;
    font-size: 16px; font-weight: 700; cursor: pointer; transition: all 0.2s;
}
.btn-confirm-cash:hover {
    background: linear-gradient(135deg, #b45309, #d97706);
    transform: translateY(-1px); box-shadow: 0 6px 20px rgba(217,119,6,0.4);
}
.btn-cancel { width: 100%; padding: 10px; background: none; color: #888; border: 1px solid #ddd; border-radius: 12px; font-size: 14px; cursor: pointer; margin-top: 10px; transition: all 0.2s; }
.btn-cancel:hover { background: #f5f5f5; color: #333; }
</style>
</head>
<body>
<%@ include file="/views/layout/sidebar.jsp" %>
<div class="main-wrapper">
    <div class="topbar">
        <div class="topbar-title"><i class="fas fa-cash-register" style="color:#f59e0b;margin-right:8px"></i>Bán Hàng / Lập Hóa Đơn</div>
        <div class="topbar-user">
            <div class="avatar"><%= currentUser.getHoTen().charAt(0) %></div>
            <span><%= currentUser.getHoTen() %></span>
        </div>
    </div>
    <div class="page-content">
        <c:if test="${not empty message}"><div class="alert alert-success"><i class="fas fa-check-circle"></i> ${message}</div></c:if>
        <c:if test="${not empty error}"><div class="alert alert-danger"><i class="fas fa-exclamation-circle"></i> ${error}</div></c:if>

        <%-- Form chứa tất cả dữ liệu submit --%>
        <form method="post" action="${pageContext.request.contextPath}/banhang/taohoadon" id="posForm">
            <div id="hiddenInputsContainer"></div>
            <%-- Topping checkboxes nằm bên trong form --%>
            <div id="toppingHiddenArea" style="display:none"></div>
        </form>

        <div class="pos-grid">
            <!-- LEFT: Chọn sản phẩm -->
            <div>
                <div class="card">
                    <div class="card-header"><h5>🥖 Chọn Bánh Mì</h5></div>
                    <div class="card-body">
                        <div class="product-grid">
                            <c:forEach var="sp" items="${listSanPham}">
                            <div class="product-card"
                                 data-id="${sp.id}"
                                 data-name="<c:out value='${sp.tenSp}'/>"
                                 data-price="${sp.giaCoBan}"
                                 onclick="addToOrderFromCard(this)">
                                <div class="name">${sp.tenSp}</div>
                                <div class="price"><fmt:formatNumber value="${sp.giaCoBan}" pattern="#,###"/>đ</div>
                            </div>
                            </c:forEach>
                        </div>

                    </div>
                </div>

                <div class="card">
                    <div class="card-header"><h5>🧂 Chọn Topping (tùy chọn)</h5></div>
                    <div class="card-body">
                        <div class="topping-grid" id="toppingGrid">
                            <c:forEach var="t" items="${listTopping}">
                            <label class="topping-chip" onclick="toggleTopping(this)">
                                <input type="checkbox" class="topping-cb" data-id="${t.id}" data-price="${t.giaCongThem}">
                                ${t.tenNguyenLieu} (+<fmt:formatNumber value="${t.giaCongThem}" pattern="#,###"/>đ)
                            </label>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>

            <!-- RIGHT: Đơn hàng -->
            <div class="card" style="align-self:start">
                <div class="card-header"><h5>📋 Hóa Đơn</h5></div>
                <div class="card-body">
                    <div id="orderItems">
                        <p style="color:#aaa;text-align:center;padding:20px">Chưa có sản phẩm nào. Nhấp vào bánh mì để thêm!</p>
                    </div>
                    <div id="orderTotal" class="order-total" style="display:none">
                        Tổng cộng: <span id="totalAmount">0</span> đ
                    </div>

                    <!-- Phương thức thanh toán -->
                    <div class="form-group" style="margin-top:16px">
                        <label class="form-label">Phương Thức Thanh Toán</label>
                        <select class="form-control" id="paymentMethod" onchange="onPaymentChange()">
                            <option value="" data-name="">-- Không chọn --</option>
                            <c:forEach var="the" items="${listThe}">
                            <option value="${the.id}" data-name="${the.tenLoaiThe}">${the.tenLoaiThe}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- PHẦN THANH TOÁN INLINE -->
                    <div id="paymentSection">
                        <!-- Tiền mặt inline -->
                        <div id="cashInlineBox">
                            <div class="cash-inline-icon"><i class="fas fa-money-bill-wave"></i></div>
                            <div class="cash-inline-title">Thanh Toán Tiền Mặt</div>
                            <div class="cash-inline-amount" id="cashInlineAmount">0 đ</div>
                            <div class="cash-inline-note">Xác nhận thu tiền mặt từ khách hàng</div>
                        </div>

                        <!-- Momo inline -->
                        <div id="momoInlineBox">
                            <div class="momo-inline-badge">MoMo</div>
                            <div class="momo-inline-title">Thanh toán qua MoMo / Chuyển khoản</div>
                            <div class="momo-inline-amount" id="momoInlineAmount">0 đ</div>
                            <div class="momo-inline-note">Bấm "Tạo Hóa Đơn & Thanh Toán" để hiện mã QR quét thanh toán</div>
                        </div>

                        <!-- Nút xác nhận -->
                        <button type="button" class="btn-pos-submit" id="submitBtn" onclick="submitPosForm()">
                            <i class="fas fa-print"></i> Tạo Hóa Đơn &amp; Thanh Toán
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ========== MODAL XÁC NHẬN TIỀN MẶT ========== -->
<div class="modal-overlay" id="cashModal">
    <div class="modal-box">
        <button class="modal-close-btn" onclick="closeAllModals()">&times;</button>
        <div class="cash-icon-wrap"><i class="fas fa-money-bill-wave"></i></div>
        <div class="modal-title">Thanh Toán Tiền Mặt</div>
        <div class="modal-subtitle">Xác nhận thu tiền từ khách hàng</div>

        <div class="amount-box-cash">
            <div class="amount-label">Số tiền cần thu</div>
            <div class="amount-value-cash" id="cashModalAmount">0 đ</div>
        </div>

        <div class="invoice-preview" id="cashInvoicePreview">
            <%-- Nội dung sẽ được render bởi JavaScript --%>
        </div>

        <button class="btn-confirm-cash" onclick="doSubmitForm()">
            <i class="fas fa-check-circle"></i>&nbsp; Đã Thu Tiền - Tạo Hóa Đơn
        </button>
        <button class="btn-cancel" onclick="closeAllModals()">Huỷ bỏ</button>
    </div>
</div>

<!-- ========== MODAL XÁC NHẬN MOMO ========== -->
<div class="modal-overlay" id="momoModal">
    <div class="modal-box">
        <button class="modal-close-btn" onclick="closeAllModals()">&times;</button>
        <div class="momo-inline-badge" style="margin-bottom: 16px;">MoMo</div>
        <div class="modal-title">Quét mã để thanh toán</div>
        <div class="modal-subtitle">Vui lòng yêu cầu khách hàng quét mã QR dưới đây</div>

        <div class="momo-modal-qr">
            <img src="${pageContext.request.contextPath}/assets/images/momo_qr.jpg"
                 alt="Momo QR Code"
                 onerror="this.src='https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=Momo-TiemBanhMi&bgcolor=FDF0F7&color=AE2070'">
        </div>

        <div class="amount-box-cash" style="border-color: #e91e8c; background: #fdf0f7;">
            <div class="amount-label" style="color: #9d174d;">Số tiền cần thu</div>
            <div class="amount-value-cash" id="momoModalAmount" style="color: #ae2070;">0 đ</div>
        </div>

        <button class="btn-confirm-momo" onclick="doSubmitForm()">
            <i class="fas fa-check-circle"></i>&nbsp; Khách Đã Thanh Toán
        </button>
        <button class="btn-cancel" onclick="closeAllModals()">Huỷ bỏ</button>
    </div>
</div>

<script>
let orderItems = {};
let totalPrice = 0;

// Đọc thông tin sản phẩm từ data attributes (an toàn với tên có dấu nháy)
function addToOrderFromCard(el) {
    const id = el.dataset.id;
    const name = el.dataset.name;
    const price = parseInt(el.dataset.price);
    addToOrder(id, name, price);
}

function addToOrder(id, name, price) {
    if (orderItems[id]) {
        orderItems[id].qty++;
    } else {
        orderItems[id] = { id, name, price, qty: 1 };
    }
    renderOrder();
}

function removeFromOrder(id) {
    delete orderItems[id];
    renderOrder();
}

function changeQty(id, delta) {
    orderItems[id].qty += delta;
    if (orderItems[id].qty <= 0) delete orderItems[id];
    renderOrder();
}

function toggleTopping(label) {
    label.classList.toggle('active');
    const cb = label.querySelector('.topping-cb');
    cb.checked = !cb.checked;
    renderOrder();
}

function renderOrder() {
    const container = document.getElementById('orderItems');
    const totalDiv  = document.getElementById('orderTotal');
    const totalSpan = document.getElementById('totalAmount');

    container.innerHTML = '';
    totalPrice = 0;

    const ids = Object.keys(orderItems);
    if (ids.length === 0) {
        container.innerHTML = '<p style="color:#aaa;text-align:center;padding:20px">Chưa có sản phẩm nào. Nhấp vào bánh mì để thêm!</p>';
        totalDiv.style.display = 'none';
        document.getElementById('paymentSection').style.display = 'none';
        return;
    }

    for (let id of ids) {
        const item = orderItems[id];
        const itemTotal = item.price * item.qty;
        totalPrice += itemTotal;

        const div = document.createElement('div');
        div.className = 'order-item';
        div.innerHTML = `
            <div>
                <div style="font-weight:600;font-size:14px">\${item.name}</div>
                <div style="color:#888;font-size:12px">\${item.price.toLocaleString('vi-VN')}đ x \${item.qty}</div>
            </div>
            <div style="display:flex;align-items:center;gap:8px">
                <button type="button" onclick="changeQty(\${id},-1)" style="width:24px;height:24px;border:1px solid #ddd;border-radius:50%;cursor:pointer;background:#fff">-</button>
                <strong>\${item.qty}</strong>
                <button type="button" onclick="changeQty(\${id},1)" style="width:24px;height:24px;border:1px solid #ddd;border-radius:50%;cursor:pointer;background:#fff">+</button>
                <span style="color:#f59e0b;font-weight:700;min-width:70px;text-align:right">\${itemTotal.toLocaleString('vi-VN')}đ</span>
                <button type="button" onclick="removeFromOrder(\${id})" style="color:#ef4444;border:none;background:none;cursor:pointer;font-size:16px">✕</button>
            </div>`;
        container.appendChild(div);
    }

    // Cộng topping
    document.querySelectorAll('.topping-cb:checked').forEach(cb => {
        totalPrice += parseInt(cb.dataset.price);
    });

    totalDiv.style.display = 'block';
    totalSpan.textContent = totalPrice.toLocaleString('vi-VN');

    // Cập nhật hiển thị thanh toán inline
    document.getElementById('paymentSection').style.display = 'block';
    updatePaymentDisplay();
}

function onPaymentChange() {
    updatePaymentDisplay();
}

function updatePaymentDisplay() {
    const select = document.getElementById('paymentMethod');
    const methodName = (select.options[select.selectedIndex].getAttribute('data-name') || '').toLowerCase();
    const amountText = totalPrice.toLocaleString('vi-VN') + ' đ';

    const cashBox  = document.getElementById('cashInlineBox');
    const momoBox  = document.getElementById('momoInlineBox');

    if (Object.keys(orderItems).length === 0) {
        cashBox.style.display = 'none';
        momoBox.style.display = 'none';
        return;
    }

    if (methodName.includes('momo') || methodName.includes('chuyển') || methodName.includes('chuyen')) {
        cashBox.style.display = 'none';
        momoBox.style.display = 'block';
        document.getElementById('momoInlineAmount').textContent = amountText;
    } else if (methodName.includes('tiền') || methodName.includes('tien') || methodName.includes('mặt') || methodName !== '') {
        momoBox.style.display = 'none';
        cashBox.style.display = 'block';
        document.getElementById('cashInlineAmount').textContent = amountText;
    } else {
        cashBox.style.display = 'none';
        momoBox.style.display = 'none';
    }
}

// Xây dựng hidden inputs trong form trước khi submit
function buildFormInputs() {
    const container = document.getElementById('hiddenInputsContainer');
    container.innerHTML = ''; // Xóa hết cũ

    // 1. Thêm idThe
    const select = document.getElementById('paymentMethod');
    const idTheInput = document.createElement('input');
    idTheInput.type  = 'hidden';
    idTheInput.name  = 'idThe';
    idTheInput.value = select.value;
    container.appendChild(idTheInput);

    // 2. Thêm từng sản phẩm
    const ids = Object.keys(orderItems);
    for (let id of ids) {
        const item = orderItems[id];

        const pidInput = document.createElement('input');
        pidInput.type  = 'hidden';
        pidInput.name  = 'productId[]';
        pidInput.value = id;
        container.appendChild(pidInput);

        const qtyInput = document.createElement('input');
        qtyInput.type  = 'hidden';
        qtyInput.name  = 'quantity[]';
        qtyInput.value = item.qty;
        container.appendChild(qtyInput);
    }

    // 3. Thêm toppings đang được chọn
    document.querySelectorAll('.topping-cb:checked').forEach(cb => {
        const tidInput = document.createElement('input');
        tidInput.type  = 'hidden';
        tidInput.name  = 'toppingIds[]';
        tidInput.value = cb.dataset.id;
        container.appendChild(tidInput);
    });
}

// Xây dựng nội dung preview cho modal tiền mặt
function buildCashPreview() {
    let html = '';
    for (let id in orderItems) {
        const item = orderItems[id];
        html += `<div class="inv-row"><span>\${item.name} x\${item.qty}</span><span>\${(item.price * item.qty).toLocaleString('vi-VN')}đ</span></div>`;
    }
    document.querySelectorAll('.topping-cb:checked').forEach(cb => {
        const label = cb.closest('label').textContent.trim();
        const price = parseInt(cb.dataset.price);
        html += `<div class="inv-row"><span>Topping: \${label.split('(')[0].trim()}</span><span>+\${price.toLocaleString('vi-VN')}đ</span></div>`;
    });
    html += `<div class="inv-row"><span>Tổng cộng</span><span>\${totalPrice.toLocaleString('vi-VN')} đ</span></div>`;
    document.getElementById('cashInvoicePreview').innerHTML = html;
}

// Khi bấm nút "Tạo Hóa Đơn & Thanh Toán"
function submitPosForm() {
    if (Object.keys(orderItems).length === 0) {
        alert('Vui lòng chọn ít nhất 1 sản phẩm!');
        return;
    }

    const select = document.getElementById('paymentMethod');
    const methodName = (select.options[select.selectedIndex].getAttribute('data-name') || '').toLowerCase();

    // Nếu là tiền mặt → hiện modal xác nhận
    if (!methodName.includes('momo') && !methodName.includes('chuyển') && !methodName.includes('chuyen')) {
        document.getElementById('cashModalAmount').textContent = totalPrice.toLocaleString('vi-VN') + ' đ';
        buildCashPreview();
        document.getElementById('cashModal').classList.add('active');
    } else {
        // Momo → hiện modal quét QR
        document.getElementById('momoModalAmount').textContent = totalPrice.toLocaleString('vi-VN') + ' đ';
        document.getElementById('momoModal').classList.add('active');
    }
}

function closeAllModals() {
    document.getElementById('cashModal').classList.remove('active');
    document.getElementById('momoModal').classList.remove('active');
}

// Submit form thực sự
function doSubmitForm() {
    buildFormInputs();
    closeAllModals();
    document.getElementById('posForm').submit();
}

// Bấm ngoài modal để đóng
document.getElementById('cashModal').addEventListener('click', function(e) {
    if (e.target === this) closeAllModals();
});
document.getElementById('momoModal').addEventListener('click', function(e) {
    if (e.target === this) closeAllModals();
});
</script>
</body></html>
