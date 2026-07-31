package com.webbanhmi.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.webbanhmi.dao.NhanVienDAO;
import com.webbanhmi.entity.NhanVien;
import com.webbanhmi.util.ParamUtil;

@WebServlet({"/manager/nhanvien", "/manager/nhanvien/add",
             "/manager/nhanvien/edit", "/manager/nhanvien/delete", "/manager/nhanvien/toggle"})
public class NhanVienServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NhanVienDAO nhanVienDAO = new NhanVienDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String uri = request.getRequestURI();
        
        if (uri.contains("/add")) {
            create(request);
        } else if (uri.contains("/edit")) {
            update(request);
        } else if (uri.contains("/delete")) {
            delete(request);
        } else if (uri.contains("/toggle")) {
            toggle(request);
        }

        int id = ParamUtil.getInt(request, "id");
        if (id > 0 && !uri.contains("/delete") && !uri.contains("/toggle")) {
            NhanVien nv = nhanVienDAO.findById(id);
            if (nv != null) {
                request.setAttribute("nhanVien", nv);
            }
        }

        request.setAttribute("list", nhanVienDAO.findAll());
        request.getRequestDispatcher("/views/nhanvien/list.jsp").forward(request, response);
    }

    private void create(HttpServletRequest request) {
        String tenDangNhap = ParamUtil.getString(request, "tenDangNhap");
        String matKhau = ParamUtil.getString(request, "matKhau");
        String hoTen = ParamUtil.getString(request, "hoTen");
        String dienThoai = ParamUtil.getString(request, "dienThoai");
        boolean vaiTro = "1".equals(request.getParameter("vaiTro"));
        boolean active = "1".equals(ParamUtil.getString(request, "active", "1"));

        if (tenDangNhap.isEmpty() || matKhau.isEmpty() || hoTen.isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin bắt buộc");
            return;
        }
        NhanVien nv = new NhanVien(null, tenDangNhap, matKhau, hoTen, dienThoai, vaiTro, active);
        int rs = nhanVienDAO.create(nv);
        if (rs > 0) {
            request.setAttribute("message", "Thêm nhân viên thành công");
        } else {
            request.setAttribute("error", "Thêm nhân viên thất bại (tên đăng nhập hoặc SĐT có thể đã tồn tại)");
        }
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
            nv.setActive("1".equals(ParamUtil.getString(request, "active", nv.isActive() ? "1" : "0")));
            
            String matKhauMoi = ParamUtil.getString(request, "matKhau");
            if (!matKhauMoi.isEmpty()) {
                nv.setMatKhau(matKhauMoi);
            }
            int rs = nhanVienDAO.update(nv);
            if (rs > 0) {
                request.setAttribute("message", "Cập nhật nhân viên thành công");
            } else {
                request.setAttribute("error", "Cập nhật nhân viên thất bại");
            }
            request.setAttribute("nhanVien", nv);
        } else {
            request.setAttribute("error", "Không tìm thấy thông tin nhân viên");
        }
    }

    private void delete(HttpServletRequest request) {
        int id = ParamUtil.getInt(request, "id");
        if (id > 0) {
            boolean isHardDeleted = nhanVienDAO.hardDelete(id);
            if (isHardDeleted) {
                request.setAttribute("message", "Đã xóa vĩnh viễn nhân viên khỏi hệ thống");
            } else {
                request.setAttribute("message", "Nhân viên đã có lịch sử hóa đơn nên hệ thống đã chuyển sang trạng thái Vô Hiệu Hóa (Inactive)");
            }
        }
    }

    private void toggle(HttpServletRequest request) {
        int id = ParamUtil.getInt(request, "id");
        if (id > 0) {
            int rs = nhanVienDAO.toggleActive(id);
            if (rs > 0) {
                request.setAttribute("message", "Đã thay đổi trạng thái hoạt động của nhân viên");
            }
        }
    }
}
