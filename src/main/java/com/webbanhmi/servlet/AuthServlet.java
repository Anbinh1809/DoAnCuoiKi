package com.webbanhmi.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.webbanhmi.dao.NhanVienDAO;
import com.webbanhmi.entity.NhanVien;
import com.webbanhmi.util.ParamUtil;

@WebServlet({"/login", "/logout"})
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NhanVienDAO nhanVienDAO = new NhanVienDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.contains("logout")) {
            // Xóa session
            request.getSession().invalidate();
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        // Trả về trang đăng nhập
        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.contains("login")) {
            String tenDangNhap = ParamUtil.getString(request, "username");
            String matKhau = ParamUtil.getString(request, "password");

            if (tenDangNhap.isEmpty() || matKhau.isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
                return;
            }

            NhanVien nv = nhanVienDAO.findByTenDangNhap(tenDangNhap);
            if (nv != null && nv.getMatKhau().equals(matKhau)) {
                // Đăng nhập thành công, lưu vào session
                HttpSession session = request.getSession();
                session.setAttribute("user", nv);
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            }
        }
    }
}
