package com.webbanhmi.servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.webbanhmi.dao.ToppingDAO;
import com.webbanhmi.entity.Topping;
import com.webbanhmi.util.ParamUtil;

@WebServlet({"/manager/topping", "/manager/topping/add",
             "/manager/topping/edit", "/manager/topping/delete",
             "/manager/topping/nhapkho", "/manager/topping/xuatkho"})
public class ToppingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ToppingDAO toppingDAO = new ToppingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = ParamUtil.getInt(request, "id");
        if (id > 0) request.setAttribute("topping", toppingDAO.findById(id));
        renderList(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.contains("add")) create(request);
        else if (uri.contains("edit")) update(request);
        else if (uri.contains("delete")) delete(request);
        else if (uri.contains("nhapkho")) nhapKho(request);
        else if (uri.contains("xuatkho")) xuatKho(request);
        renderList(request, response);
    }

    private void renderList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Topping> list = toppingDAO.findAll();
        
        int tongMatHang = list.size();
        long sapHet = list.stream().filter(t -> t.getSoLuongTon() > 0 && t.getSoLuongTon() <= 20).count();
        long daHet = list.stream().filter(t -> t.getSoLuongTon() <= 0).count();

        request.setAttribute("list", list);
        request.setAttribute("tongMatHang", tongMatHang);
        request.setAttribute("sapHet", sapHet);
        request.setAttribute("daHet", daHet);
        request.getRequestDispatcher("/views/topping/list.jsp").forward(request, response);
    }

    private void create(HttpServletRequest request) {
        String ten = ParamUtil.getString(request, "tenNguyenLieu");
        int gia = ParamUtil.getInt(request, "giaCongThem");
        int soLuong = ParamUtil.getInt(request, "soLuongTon");
        String donVi = ParamUtil.getString(request, "donViTinh");
        if (donVi.isEmpty()) donVi = "Phần";
        if (soLuong <= 0) soLuong = 50;

        if (ten.isEmpty()) { request.setAttribute("error", "Tên nguyên liệu không được để trống"); return; }
        int rs = toppingDAO.create(new Topping(null, ten, gia, soLuong, donVi, true));
        if (rs > 0) request.setAttribute("message", "Thêm nguyên liệu kho thành công");
        else request.setAttribute("error", "Thêm nguyên liệu kho thất bại");
    }

    private void update(HttpServletRequest request) {
        int id = ParamUtil.getInt(request, "id");
        String ten = ParamUtil.getString(request, "tenNguyenLieu");
        if (ten.isEmpty()) {
            request.setAttribute("error", "Tên nguyên liệu không hợp lệ");
            return;
        }

        Topping t = toppingDAO.findById(id);
        if (t != null) {
            t.setTenNguyenLieu(ten);
            t.setGiaCongThem(ParamUtil.getInt(request, "giaCongThem"));
            t.setSoLuongTon(ParamUtil.getInt(request, "soLuongTon"));
            String donVi = ParamUtil.getString(request, "donViTinh");
            if (!donVi.isEmpty()) t.setDonViTinh(donVi);
            t.setActive(!"0".equals(request.getParameter("active")));
            int rs = toppingDAO.update(t);
            if (rs > 0) request.setAttribute("message", "Cập nhật kho thành công");
            else request.setAttribute("error", "Cập nhật thất bại");
            request.setAttribute("topping", t);
        }
    }

    private void nhapKho(HttpServletRequest request) {
        int id = ParamUtil.getInt(request, "id");
        int soLuong = ParamUtil.getInt(request, "soLuongNhap");
        if (id > 0 && soLuong > 0) {
            int rs = toppingDAO.nhapKho(id, soLuong);
            if (rs > 0) request.setAttribute("message", "Đã nhập kho thành công +" + soLuong);
            else request.setAttribute("error", "Nhập kho thất bại");
        } else {
            request.setAttribute("error", "Số lượng nhập phải lớn hơn 0");
        }
    }

    private void xuatKho(HttpServletRequest request) {
        int id = ParamUtil.getInt(request, "id");
        int soLuong = ParamUtil.getInt(request, "soLuongXuat");
        if (id > 0 && soLuong > 0) {
            int rs = toppingDAO.xuatKho(id, soLuong);
            if (rs > 0) request.setAttribute("message", "Đã xuất kho thành công -" + soLuong);
            else request.setAttribute("error", "Xuất kho thất bại");
        } else {
            request.setAttribute("error", "Số lượng xuất phải lớn hơn 0");
        }
    }

    private void delete(HttpServletRequest request) {
        int id = ParamUtil.getInt(request, "id");
        if (id > 0) { toppingDAO.delete(id); request.setAttribute("message", "Đã xóa nguyên liệu khỏi kho"); }
    }
}
