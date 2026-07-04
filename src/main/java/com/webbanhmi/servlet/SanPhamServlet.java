package com.webbanhmi.servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.webbanhmi.dao.LoaiSanPhamDAO;
import com.webbanhmi.dao.SanPhamDAO;
import com.webbanhmi.entity.SanPham;
import com.webbanhmi.util.ParamUtil;

@WebServlet({"/sanpham", "/sanpham/add", "/sanpham/edit", "/sanpham/delete"})
public class SanPhamServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SanPhamDAO sanPhamDAO = new SanPhamDAO();
    private LoaiSanPhamDAO loaiDAO = new LoaiSanPhamDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = ParamUtil.getInt(request, "id");
        if (id > 0) {
            request.setAttribute("sanPham", sanPhamDAO.findById(id));
        }
        request.setAttribute("list", sanPhamDAO.findAll());
        request.setAttribute("listLoai", loaiDAO.findAll());
        request.getRequestDispatcher("/views/sanpham/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.contains("add")) create(request);
        else if (uri.contains("edit")) update(request);
        else if (uri.contains("delete")) delete(request);
        request.setAttribute("list", sanPhamDAO.findAll());
        request.setAttribute("listLoai", loaiDAO.findAll());
        request.getRequestDispatcher("/views/sanpham/list.jsp").forward(request, response);
    }

    private void create(HttpServletRequest request) {
        String tenSp = ParamUtil.getString(request, "tenSp");
        int giaCoBan = ParamUtil.getInt(request, "giaCoBan");
        int idLoai = ParamUtil.getInt(request, "idLoaiSp");
        String anhSp = ParamUtil.getString(request, "anhSp");
        String moTa = ParamUtil.getString(request, "moTa");
        if (tenSp.isEmpty() || giaCoBan <= 0) {
            request.setAttribute("error", "Tên sản phẩm và giá không được để trống");
            return;
        }
        SanPham sp = new SanPham(null, tenSp, giaCoBan, anhSp, moTa, true, idLoai);
        int rs = sanPhamDAO.create(sp);
        if (rs > 0) request.setAttribute("message", "Thêm sản phẩm thành công");
        else request.setAttribute("error", "Thêm sản phẩm thất bại");
    }

    private void update(HttpServletRequest request) {
        int id = ParamUtil.getInt(request, "id");
        String tenSp = ParamUtil.getString(request, "tenSp");
        int giaCoBan = ParamUtil.getInt(request, "giaCoBan");
        
        if (tenSp.isEmpty() || giaCoBan <= 0) {
            request.setAttribute("error", "Tên sản phẩm và giá không hợp lệ");
            return;
        }

        SanPham sp = sanPhamDAO.findById(id);
        if (sp != null) {
            sp.setTenSp(tenSp);
            sp.setGiaCoBan(giaCoBan);
            sp.setIdLoaiSp(ParamUtil.getInt(request, "idLoaiSp"));
            sp.setAnhSp(ParamUtil.getString(request, "anhSp"));
            sp.setMoTa(ParamUtil.getString(request, "moTa"));
            sp.setActive(!"0".equals(request.getParameter("active")));
            int rs = sanPhamDAO.update(sp);
            if (rs > 0) request.setAttribute("message", "Cập nhật thành công");
            else request.setAttribute("error", "Cập nhật thất bại");
            request.setAttribute("sanPham", sp);
        }
    }

    private void delete(HttpServletRequest request) {
        int id = ParamUtil.getInt(request, "id");
        if (id > 0) {
            sanPhamDAO.delete(id);
            request.setAttribute("message", "Đã ẩn sản phẩm");
        }
    }
}
