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
import com.webbanhmi.entity.DonHang;
import com.webbanhmi.entity.NhanVien;
import com.webbanhmi.util.ParamUtil;

@WebServlet("/thongke")
public class ThongKeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DonHangDAO donHangDAO = new DonHangDAO();
    private NhanVienDAO nhanVienDAO = new NhanVienDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tuNgay = ParamUtil.getString(request, "tuNgay");
        String denNgay = ParamUtil.getString(request, "denNgay");
        int nhanVienId = ParamUtil.getInt(request, "nhanVienId");

        // Lấy thông tin user đang đăng nhập
        NhanVien currentUser = (NhanVien) request.getSession().getAttribute("user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        boolean isAdmin = currentUser.isVaiTro();
        List<DonHang> list;

        if (isAdmin) {
            if (nhanVienId > 0) {
                if (!tuNgay.isEmpty() && !denNgay.isEmpty()) {
                    list = donHangDAO.thongKeTheoNgayVaNhanVien(tuNgay, denNgay, nhanVienId);
                } else {
                    list = donHangDAO.findByNhanVienId(nhanVienId);
                }
            } else {
                if (!tuNgay.isEmpty() && !denNgay.isEmpty()) {
                    list = donHangDAO.thongKeTheoNgay(tuNgay, denNgay);
                } else {
                    list = donHangDAO.findAll();
                }
            }
        } else {
            // Staff: chỉ xem của chính mình
            nhanVienId = currentUser.getId();
            if (!tuNgay.isEmpty() && !denNgay.isEmpty()) {
                list = donHangDAO.thongKeTheoNgayVaNhanVien(tuNgay, denNgay, nhanVienId);
            } else {
                list = donHangDAO.findByNhanVienId(nhanVienId);
            }
        }

        int tongDoanhThu = list.stream().mapToInt(d -> d.getTongTien() != null ? d.getTongTien() : 0).sum();
        request.setAttribute("list", list);
        request.setAttribute("tongDoanhThu", tongDoanhThu);
        request.setAttribute("tuNgay", tuNgay);
        request.setAttribute("denNgay", denNgay);
        request.setAttribute("nhanVienId", nhanVienId);
        request.setAttribute("isAdmin", isAdmin);
        request.setAttribute("listNhanVien", nhanVienDAO.findAllActive());
        request.getRequestDispatcher("/views/thongke/report.jsp").forward(request, response);
    }
}
