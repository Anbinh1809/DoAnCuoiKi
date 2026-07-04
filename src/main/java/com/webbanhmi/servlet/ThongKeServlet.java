package com.webbanhmi.servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.webbanhmi.dao.DonHangDAO;
import com.webbanhmi.entity.DonHang;
import com.webbanhmi.util.ParamUtil;

@WebServlet("/thongke")
public class ThongKeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DonHangDAO donHangDAO = new DonHangDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String tuNgay = ParamUtil.getString(request, "tuNgay");
        String denNgay = ParamUtil.getString(request, "denNgay");

        List<DonHang> list;
        if (!tuNgay.isEmpty() && !denNgay.isEmpty()) {
            list = donHangDAO.thongKeTheoNgay(tuNgay, denNgay);
        } else {
            list = donHangDAO.findAll();
        }

        int tongDoanhThu = list.stream().mapToInt(d -> d.getTongTien() != null ? d.getTongTien() : 0).sum();
        request.setAttribute("list", list);
        request.setAttribute("tongDoanhThu", tongDoanhThu);
        request.setAttribute("tuNgay", tuNgay);
        request.setAttribute("denNgay", denNgay);
        request.getRequestDispatcher("/views/thongke/report.jsp").forward(request, response);
    }
}
