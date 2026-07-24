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

        // Biểu đồ doanh thu 7 ngày gần nhất phân theo từng ca / nhân viên
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM");
        java.util.List<String> labels = new java.util.ArrayList<>();
        java.util.List<java.util.Calendar> days = new java.util.ArrayList<>();
        
        for (int i = 6; i >= 0; i--) {
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.add(java.util.Calendar.DAY_OF_YEAR, -i);
            days.add(cal);
            labels.add(sdf.format(cal.getTime()));
        }
        
        StringBuilder labelsJson = new StringBuilder("[");
        for (int i = 0; i < labels.size(); i++) {
            labelsJson.append("\"").append(labels.get(i)).append("\"");
            if (i < labels.size() - 1) labelsJson.append(",");
        }
        labelsJson.append("]");

        // Lấy danh sách nhân viên để phân màu ca làm
        java.util.List<com.webbanhmi.entity.NhanVien> listNhanVien = nhanVienDAO.findAllActive();
        String[] colors = {"#f59e0b", "#10b981", "#3b82f6", "#8b5cf6", "#ec4899", "#06b6d4", "#64748b"};

        StringBuilder datasetsJson = new StringBuilder("[");
        for (int s = 0; s < listNhanVien.size(); s++) {
            com.webbanhmi.entity.NhanVien nv = listNhanVien.get(s);
            String color = colors[s % colors.length];

            datasetsJson.append("{");
            datasetsJson.append("\"label\":\"").append(nv.getHoTen()).append("\",");
            datasetsJson.append("\"backgroundColor\":\"").append(color).append("\",");
            datasetsJson.append("\"data\":[");

            for (int d = 0; d < days.size(); d++) {
                String dateStr = sdf.format(days.get(d).getTime());
                int staffDayTotal = 0;
                for (DonHang dh : dsHoaDon) {
                    if (dh.getNgayTao() != null && dh.getIdNhanVien() != null && dh.getIdNhanVien().equals(nv.getId())) {
                        if (sdf.format(dh.getNgayTao()).equals(dateStr)) {
                            staffDayTotal += (dh.getTongTien() != null ? dh.getTongTien() : 0);
                        }
                    }
                }
                datasetsJson.append(staffDayTotal);
                if (d < days.size() - 1) datasetsJson.append(",");
            }

            datasetsJson.append("]}");
            if (s < listNhanVien.size() - 1) datasetsJson.append(",");
        }
        datasetsJson.append("]");
        
        request.setAttribute("chartLabels", labelsJson.toString());
        request.setAttribute("chartDatasets", datasetsJson.toString());

        request.getRequestDispatcher("/views/home/dashboard.jsp").forward(request, response);
    }
}
