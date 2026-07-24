package com.webbanhmi.servlet;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.webbanhmi.dao.ChiTietDonHangDAO;
import com.webbanhmi.dao.DonHangDAO;
import com.webbanhmi.entity.ChiTietDonHang;
import com.webbanhmi.entity.DonHang;
import com.webbanhmi.util.ParamUtil;

@WebServlet("/thongke/detail")
public class InvoiceDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DonHangDAO donHangDAO = new DonHangDAO();
    private ChiTietDonHangDAO chiTietDAO = new ChiTietDonHangDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int orderId = ParamUtil.getInt(request, "id");
        if (orderId <= 0) {
            response.setStatus(400);
            return;
        }

        DonHang dh = donHangDAO.findById(orderId);
        if (dh == null) {
            response.setStatus(404);
            return;
        }

        List<ChiTietDonHang> chiTietList = chiTietDAO.findByOrderId(orderId);
        dh.setChiTietList(chiTietList);
        
        request.setAttribute("donHang", dh);
        request.getRequestDispatcher("/views/thongke/invoiceDetail.jsp").forward(request, response);
    }
}
