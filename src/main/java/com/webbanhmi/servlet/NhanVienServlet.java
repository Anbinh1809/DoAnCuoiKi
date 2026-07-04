package com.webbanhmi.servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.webbanhmi.dao.NhanVienDAO;
import com.webbanhmi.entity.NhanVien;
import com.webbanhmi.util.ParamUtil;

@WebServlet({"/manager/nhanvien", "/manager/nhanvien/add",
             "/manager/nhanvien/edit", "/manager/nhanvien/delete"})
public class NhanVienServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NhanVienDAO nhanVienDAO = new NhanVienDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = ParamUtil.getInt(request, "id");
        if (id > 0) {
            request.setAttribute("nhanVien", nhanVienDAO.findById(id));
        }
        request.setAttribute("list", nhanVienDAO.findAll());
        request.getRequestDispatcher("/views/nhanvien/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.contains("add")) create(request);
        else if (uri.contains("edit")) update(request);
        else if (uri.contains("delete")) delete(request);
        request.setAttribute("list", nhanVienDAO.findAll());
        request.getRequestDispatcher("/views/nhanvien/list.jsp").forward(request, response);
    }

    private void create(HttpServletRequest request) {
        String tenDangNhap = ParamUtil.getString(request, "tenDangNhap");
        String matKhau = ParamUtil.getString(request, "matKhau");
        String hoTen = ParamUtil.getString(request, "hoTen");
        String dienThoai = ParamUtil.getString(request, "dienThoai");
        boolean vaiTro = "1".equals(request.getParameter("vaiTro"));

        if (tenDangNhap.isEmpty() || matKhau.isEmpty() || hoTen.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin bắt buộc");
            return;
        }
        NhanVien nv = new NhanVien(null, tenDangNhap, matKhau, hoTen, dienThoai, vaiTro, true);
        int rs = nhanVienDAO.create(nv);
        if (rs > 0) request.setAttribute("message", "Thêm nhân viên thành công");
        else request.setAttribute("error", "Thêm nhân viên thất bại (tên đăng nhập có thể đã tồn tại)");
    }

    private void update(HttpServletRequest request) {
        int id = ParamUtil.getInt(request, "id");
        String hoTen = ParamUtil.getString(request, "hoTen");
        if (hoTen.isEmpty()) {
            request.setAttribute("error", "Họ tên không được để trống");
            return;
        }

        NhanVien nv = nhanVienDAO.findById(id);
        if (nv != null) {
            nv.setHoTen(hoTen);
            nv.setDienThoai(ParamUtil.getString(request, "dienThoai"));
            nv.setVaiTro("1".equals(request.getParameter("vaiTro")));
            String matKhauMoi = ParamUtil.getString(request, "matKhau");
            if (!matKhauMoi.isEmpty()) nv.setMatKhau(matKhauMoi);
            int rs = nhanVienDAO.update(nv);
            if (rs > 0) request.setAttribute("message", "Cập nhật thành công");
            else request.setAttribute("error", "Cập nhật thất bại");
            request.setAttribute("nhanVien", nv);
        } else {
            request.setAttribute("error", "Không tìm thấy nhân viên");
        }
    }

    private void delete(HttpServletRequest request) {
        int id = ParamUtil.getInt(request, "id");
        if (id > 0) {
            nhanVienDAO.delete(id);
            request.setAttribute("message", "Đã vô hiệu hóa tài khoản nhân viên");
        }
    }
}
