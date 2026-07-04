package com.webbanhmi.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.webbanhmi.entity.ChiTietDonHang;
import com.webbanhmi.entity.Topping;
import com.webbanhmi.util.JdbcUtil;
import com.webbanhmi.util.JdbcUtil.QueryResult;

public class ChiTietDonHangDAO {

    public int create(ChiTietDonHang entity) {
        String sql = "INSERT INTO chi_tiet_don_hang(so_luong, gia_ban, order_id, product_id) VALUES (?, ?, ?, ?)";
        try {
            return JdbcUtil.executeUpdate(sql, entity.getSoLuong(), entity.getGiaBan(), entity.getOrderId(), entity.getProductId());
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int createAndGetId(ChiTietDonHang entity) {
        String sql = "INSERT INTO chi_tiet_don_hang(so_luong, gia_ban, order_id, product_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = JdbcUtil.getConnection();
             PreparedStatement stmt = JdbcUtil.createPreStmt(conn, sql,
                entity.getSoLuong(), entity.getGiaBan(), entity.getOrderId(), entity.getProductId())) {
            stmt.executeUpdate();
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int addTopping(int orderItemId, int toppingId, int soLuong) {
        String sql = "INSERT INTO chi_tiet_topping_don_hang(so_luong, order_item_id, topping_id) VALUES (?, ?, ?)";
        try {
            return JdbcUtil.executeUpdate(sql, soLuong, orderItemId, toppingId);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public List<ChiTietDonHang> findByOrderId(int orderId) {
        List<ChiTietDonHang> list = new ArrayList<>();
        String sql = "SELECT ct.*, sp.ten_sp FROM chi_tiet_don_hang ct " +
                     "JOIN san_pham sp ON ct.product_id = sp.id WHERE ct.order_id = ?";
        try (QueryResult qr = JdbcUtil.executeQuery(sql, orderId)) {
            ResultSet rs = qr.getResultSet();
            while (rs.next()) {
                ChiTietDonHang ct = new ChiTietDonHang();
                ct.setId(rs.getInt("id"));
                ct.setSoLuong(rs.getInt("so_luong"));
                ct.setGiaBan(rs.getInt("gia_ban"));
                ct.setOrderId(rs.getInt("order_id"));
                ct.setProductId(rs.getInt("product_id"));
                ct.setTenSp(rs.getString("ten_sp"));
                // Load toppings for this item
                ct.setToppingList(findToppingsByOrderItemId(ct.getId()));
                list.add(ct);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Topping> findToppingsByOrderItemId(int orderItemId) {
        List<Topping> list = new ArrayList<>();
        String sql = "SELECT t.* FROM chi_tiet_topping_don_hang ctt " +
                     "JOIN toppings t ON ctt.topping_id = t.id WHERE ctt.order_item_id = ?";
        try (QueryResult qr = JdbcUtil.executeQuery(sql, orderItemId)) {
            ResultSet rs = qr.getResultSet();
            while (rs.next()) {
                Topping t = new Topping();
                t.setId(rs.getInt("id"));
                t.setTenNguyenLieu(rs.getString("ten_nguyen_lieu"));
                t.setGiaCongThem(rs.getInt("gia_cong_them"));
                list.add(t);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
