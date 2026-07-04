package com.webbanhmi.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.webbanhmi.dao.ToppingDAO;
import com.webbanhmi.entity.Topping;
import com.webbanhmi.util.ParamUtil;

@WebServlet({"/manager/topping", "/manager/topping/add",
             "/manager/topping/edit", "/manager/topping/delete"})
public class ToppingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ToppingDAO toppingDAO = new ToppingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = ParamUtil.getInt(request, "id");
        if (id > 0) request.setAttribute("topping", toppingDAO.findById(id));
        request.setAttribute("list", toppingDAO.findAll());
        request.getRequestDispatcher("/views/topping/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.contains("add")) create(request);
        else if (uri.contains("edit")) update(request);
        else if (uri.contains("delete")) delete(request);
        request.setAttribute("list", toppingDAO.findAll());
        request.getRequestDispatcher("/views/topping/list.jsp").forward(request, response);
    }

    private void create(HttpServletRequest request) {
        String ten = ParamUtil.getString(request, "tenNguyenLieu");
        int gia = ParamUtil.getInt(request, "giaCongThem");
        if (ten.isEmpty()) { request.setAttribute("error", "Tên nguyên liệu không được để trống"); return; }
        int rs = toppingDAO.create(new Topping(null, ten, gia, true));
        if (rs > 0) request.setAttribute("message", "Thêm nguyên liệu thành công");
        else request.setAttribute("error", "Thêm nguyên liệu thất bại");
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
            t.setActive(!"0".equals(request.getParameter("active")));
            int rs = toppingDAO.update(t);
            if (rs > 0) request.setAttribute("message", "Cập nhật thành công");
            else request.setAttribute("error", "Cập nhật thất bại");
            request.setAttribute("topping", t);
        }
    }

    private void delete(HttpServletRequest request) {
        int id = ParamUtil.getInt(request, "id");
        if (id > 0) { toppingDAO.delete(id); request.setAttribute("message", "Đã xóa nguyên liệu"); }
    }
}
