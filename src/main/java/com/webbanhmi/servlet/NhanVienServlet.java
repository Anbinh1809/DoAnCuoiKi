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
        boolean isUpdatedSuccessfully = false;

        if (uri.contains("/add")) {
            create(request);
        } else if (uri.contains("/edit")) {
            isUpdatedSuccessfully = update(request);
        } else if (uri.contains("/delete")) {
            delete(request);
        } else if (uri.contains("/toggle")) {
            toggle(request);
        }

        int id = ParamUtil.getInt(request, "id");
        if (id > 0 && !uri.contains("/delete") && !uri.contains("/toggle") && !isUpdatedSuccessfully) {
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
            request.setAttribute("error", "Vui lòng nhập đầy đủ các thông tin bắt buộc (*)");
            return;
        }

        if (nhanVienDAO.isTenDangNhapExists(tenDangNhap, null)) {
            request.setAttribute("error", "Tên đăng nhập [" + tenDangNhap + "] đã tồn tại trong hệ thống");
            return;
        }

        if (!dienThoai.trim().isEmpty() && nhanVienDAO.isDienThoaiExists(dienThoai, null)) {
            request.setAttribute("error", "Số điện thoại [" + dienThoai + "] đã được đăng ký bởi nhân viên khác");
            return;
        }

        NhanVien nv = new NhanVien(null, tenDangNhap, matKhau, hoTen, dienThoai, vaiTro, active);
        int rs = nhanVienDAO.create(nv);
        if (rs > 0) {
            request.setAttribute("message", "Thêm nhân viên [" + hoTen + "] thành công");
        } else {
            request.setAttribute("error", "Thêm nhân viên thất bại. Vui lòng kiểm tra lại thông tin!");
        }
    }

    private boolean update(HttpServletRequest request) {
        int id = ParamUtil.getInt(request, "id");
        String hoTen = ParamUtil.getString(request, "hoTen");
        String dienThoai = ParamUtil.getString(request, "dienThoai");

        if (id <= 0) {
            request.setAttribute("error", "Không xác định được mã nhân viên cần sửa");
            return false;
        }

        if (hoTen.isEmpty()) {
            request.setAttribute("error", "Họ và tên không được để trống");
            return false;
        }

        if (!dienThoai.trim().isEmpty() && nhanVienDAO.isDienThoaiExists(dienThoai, id)) {
            request.setAttribute("error", "Số điện thoại [" + dienThoai + "] đã trùng với nhân viên khác");
            return false;
        }

        NhanVien nv = nhanVienDAO.findById(id);
        if (nv != null) {
            nv.setHoTen(hoTen);
            nv.setDienThoai(dienThoai);
            nv.setVaiTro("1".equals(request.getParameter("vaiTro")));
            nv.setActive("1".equals(ParamUtil.getString(request, "active", nv.isActive() ? "1" : "0")));

            String matKhauMoi = ParamUtil.getString(request, "matKhau");
            if (!matKhauMoi.isEmpty()) {
                nv.setMatKhau(matKhauMoi);
            }

            int rs = nhanVienDAO.update(nv);
            if (rs > 0) {
                request.setAttribute("message", "Đã cập nhật thông tin nhân viên [" + hoTen + "] thành công!");
                return true;
            } else {
                request.setAttribute("error", "Cập nhật nhân viên thất bại");
                request.setAttribute("nhanVien", nv);
                return false;
            }
        } else {
            request.setAttribute("error", "Không tìm thấy thông tin nhân viên trong CSDL");
            return false;
        }
    }

    private void delete(HttpServletRequest request) {
        int id = ParamUtil.getInt(request, "id");
        if (id > 0) {
            NhanVien nv = nhanVienDAO.findById(id);
            String name = (nv != null) ? nv.getHoTen() : "";
            boolean isHardDeleted = nhanVienDAO.hardDelete(id);
            if (isHardDeleted) {
                request.setAttribute("message", "Đã xóa vĩnh viễn nhân viên [" + name + "] khỏi hệ thống");
            } else {
                request.setAttribute("message", "Nhân viên [" + name + "] đã có lịch sử đơn hàng nên hệ thống đã chuyển sang trạng thái Vô Hiệu Hóa (Inactive)");
            }
        }
    }

    private void toggle(HttpServletRequest request) {
        int id = ParamUtil.getInt(request, "id");
        if (id > 0) {
            NhanVien nv = nhanVienDAO.findById(id);
            int rs = nhanVienDAO.toggleActive(id);
            if (rs > 0 && nv != null) {
                String statusStr = nv.isActive() ? "Vô Hiệu Hóa (Inactive)" : "Kích Hoạt (Active)";
                request.setAttribute("message", "Đã chuyển trạng thái tài khoản [" + nv.getHoTen() + "] sang " + statusStr);
            }
        }
    }
}
