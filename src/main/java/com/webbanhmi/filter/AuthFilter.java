package com.webbanhmi.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.webbanhmi.entity.NhanVien;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();

        // Bỏ qua các file tĩnh và trang login/logout
        if (uri.startsWith(contextPath + "/assets") ||
            uri.startsWith(contextPath + "/login") ||
            uri.startsWith(contextPath + "/logout") ||
            uri.endsWith(".css") || uri.endsWith(".js") || uri.endsWith(".png") || uri.endsWith(".jpg")) {
            chain.doFilter(request, response);
            return;
        }

        // Kiểm tra Authentication (Đã đăng nhập chưa)
        HttpSession session = req.getSession(false);
        NhanVien user = (session != null) ? (NhanVien) session.getAttribute("user") : null;

        if (user == null) {
            // Nếu đây là trang gốc "/" (index.jsp), thì header.jsp có xử lý redirect rồi, nhưng Filter sẽ chặn trước.
            res.sendRedirect(contextPath + "/login");
            return;
        }

        // Kiểm tra Authorization (Phân quyền Admin)
        // Các đường dẫn /manager/nhanvien và /thongke chỉ dành cho admin (vaiTro = 1 / true)
        if (uri.startsWith(contextPath + "/manager/nhanvien") || uri.startsWith(contextPath + "/thongke")) {
            if (!user.isVaiTro()) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này!");
                return;
            }
        }

        // Cho phép đi tiếp
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
