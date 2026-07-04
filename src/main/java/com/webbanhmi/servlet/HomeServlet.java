package com.webbanhmi.servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.webbanhmi.dao.DonHangDAO;
import com.webbanhmi.dao.NhanVienDAO;
import com.webbanhmi.dao.SanPhamDAO;
import com.webbanhmi.entity.DonHang;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DonHangDAO donHangDAO = new DonHangDAO();
    private SanPhamDAO sanPhamDAO = new SanPhamDAO();
    private NhanVienDAO nhanVienDAO = new NhanVienDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Thống kê nhanh cho dashboard
        List<DonHang> dsHoaDon = donHangDAO.findAll();
        int tongDoanhThu = dsHoaDon.stream().mapToInt(d -> d.getTongTien() != null ? d.getTongTien() : 0).sum();
        int tongSanPham = sanPhamDAO.findAll().size();
        // Sửa lỗi: chỉ đếm nhân viên đang active thay vì đếm tất cả
        int tongNhanVien = nhanVienDAO.findAllActive().size();
        int tongHoaDon = dsHoaDon.size();

        request.setAttribute("tongDoanhThu", tongDoanhThu);
        request.setAttribute("tongSanPham", tongSanPham);
        request.setAttribute("tongNhanVien", tongNhanVien);
        request.setAttribute("tongHoaDon", tongHoaDon);
        request.setAttribute("dsHoaDonGanDay", dsHoaDon.subList(0, Math.min(5, dsHoaDon.size())));

        request.getRequestDispatcher("/views/home/dashboard.jsp").forward(request, response);
    }
}
