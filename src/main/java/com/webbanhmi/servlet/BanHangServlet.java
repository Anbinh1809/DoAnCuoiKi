package com.webbanhmi.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.webbanhmi.dao.*;
import com.webbanhmi.entity.*;
import com.webbanhmi.util.ParamUtil;

@WebServlet({"/banhang", "/banhang/taohoadon"})
public class BanHangServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SanPhamDAO sanPhamDAO = new SanPhamDAO();
    private ToppingDAO toppingDAO = new ToppingDAO();
    private TheThanhToanDAO theDAO = new TheThanhToanDAO();
    private DonHangDAO donHangDAO = new DonHangDAO();
    private ChiTietDonHangDAO chiTietDAO = new ChiTietDonHangDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("listSanPham", sanPhamDAO.findAll());
        request.setAttribute("listTopping", toppingDAO.findAll());
        request.setAttribute("listThe", theDAO.findAll());
        request.getRequestDispatcher("/views/banhang/pos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Sửa lỗi: kiểm tra null cho user (session có thể hết hạn)
            NhanVien user = (NhanVien) request.getSession().getAttribute("user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            int idThe = ParamUtil.getInt(request, "idThe");

            // Lấy danh sách sản phẩm từ form (mảng)
            String[] productIds = request.getParameterValues("productId[]");
            String[] quantities = request.getParameterValues("quantity[]");
            String[] toppingIdsArr = request.getParameterValues("toppingIds[]");

            // Sửa lỗi: kiểm tra đủ cả productIds lẫn quantities
            if (productIds == null || productIds.length == 0
                    || (productIds.length == 1 && productIds[0].trim().isEmpty())) {
                request.setAttribute("error", "Vui lòng chọn ít nhất 1 sản phẩm");
                doGet(request, response);
                return;
            }

            if (quantities == null || quantities.length < productIds.length) {
                request.setAttribute("error", "Dữ liệu số lượng không hợp lệ");
                doGet(request, response);
                return;
            }

            // Tính tổng tiền
            int tongTien = 0;
            for (int i = 0; i < productIds.length; i++) {
                if (productIds[i] == null || productIds[i].trim().isEmpty()) continue;
                int pid = Integer.parseInt(productIds[i].trim());
                int qty = Integer.parseInt(quantities[i].trim());
                if (qty <= 0) {
                    throw new NumberFormatException("Số lượng sản phẩm không hợp lệ (phải lớn hơn 0)");
                }
                SanPham sp = sanPhamDAO.findById(pid);
                if (sp != null) tongTien += sp.getGiaCoBan() * qty;
            }
            // Cộng topping
            if (toppingIdsArr != null) {
                for (String tid : toppingIdsArr) {
                    if (tid != null && !tid.trim().isEmpty()) {
                        Topping t = toppingDAO.findById(Integer.parseInt(tid.trim()));
                        if (t != null) tongTien += t.getGiaCongThem();
                    }
                }
            }

            // Tạo mã đơn hàng an toàn hơn: HD + timestamp dạng hex + random để giảm trùng lặp
            String maHD = "HD" + String.format("%08X", (System.currentTimeMillis() ^ (long)(Math.random() * 0xFFFFFFFFL)) & 0xFFFFFFFFL);
            // Giới hạn 10 ký tự theo thiết kế DB (VARCHAR(10))
            if (maHD.length() > 10) maHD = maHD.substring(0, 10);

            // Lưu đơn hàng
            DonHang dh = new DonHang();
            dh.setMaSoDonHang(maHD);
            dh.setTongTien(tongTien);
            dh.setTrangThai("COMPLETED");
            dh.setIdNhanVien(user.getId());
            dh.setIdThe(idThe > 0 ? idThe : null);
            int donHangId = donHangDAO.createAndGetId(dh);

            if (donHangId > 0) {
                // Lưu chi tiết từng sản phẩm
                for (int i = 0; i < productIds.length; i++) {
                    if (productIds[i] == null || productIds[i].trim().isEmpty()) continue;
                    int pid = Integer.parseInt(productIds[i].trim());
                    int qty = Integer.parseInt(quantities[i].trim());
                    SanPham sp = sanPhamDAO.findById(pid);
                    if (sp == null) continue;

                    ChiTietDonHang ct = new ChiTietDonHang();
                    ct.setSoLuong(qty);
                    ct.setGiaBan(sp.getGiaCoBan() * qty);
                    ct.setOrderId(donHangId);
                    ct.setProductId(pid);
                    int ctId = chiTietDAO.createAndGetId(ct);

                    // Lưu topping cho từng item (nếu có)
                    String toppingForItem = request.getParameter("toppings_" + i);
                    if (toppingForItem != null && !toppingForItem.isEmpty()) {
                        for (String tid : toppingForItem.split(",")) {
                            if (!tid.trim().isEmpty()) {
                                chiTietDAO.addTopping(ctId, Integer.parseInt(tid.trim()), 1);
                            }
                        }
                    }
                }
                request.setAttribute("message", "Tạo hóa đơn " + maHD + " thành công! Tổng tiền: "
                        + String.format("%,d", tongTien) + " VNĐ");
            } else {
                request.setAttribute("error", "Tạo hóa đơn thất bại. Vui lòng thử lại.");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Dữ liệu sản phẩm không hợp lệ: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        doGet(request, response);
    }
}
