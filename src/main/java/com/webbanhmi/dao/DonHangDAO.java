package com.webbanhmi.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.webbanhmi.entity.DonHang;
import com.webbanhmi.util.JdbcUtil;
import com.webbanhmi.util.JdbcUtil.QueryResult;

public class DonHangDAO implements CrudDAO<DonHang, Integer> {

    @Override
    public int create(DonHang entity) {
        String sql = "INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (?, ?, ?, ?, ?)";
        try {
            return JdbcUtil.executeUpdate(sql, entity.getMaSoDonHang(), entity.getTongTien(),
                    entity.getTrangThai(), entity.getIdNhanVien(), entity.getIdThe());
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public int update(DonHang entity) {
        String sql = "UPDATE don_hang SET tong_tien=?, trang_thai=?, id_the=? WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, entity.getTongTien(), entity.getTrangThai(), entity.getIdThe(), entity.getId());
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public int delete(Integer id) { return 0; }

    @Override
    public List<DonHang> findAll() {
        String sql = "SELECT dh.id, dh.ma_so_don_hang, dh.ngay_tao, " +
                     "ISNULL(SUM(ct.gia_ban), dh.tong_tien) AS tong_tien, " +
                     "dh.trang_thai, dh.id_nhan_vien, dh.id_the, " +
                     "nv.ho_ten as ten_nhan_vien, ttt.ten_loai_the " +
                     "FROM don_hang dh " +
                     "LEFT JOIN nhan_vien nv ON dh.id_nhan_vien = nv.id " +
                     "LEFT JOIN the_thanh_toan ttt ON dh.id_the = ttt.id " +
                     "LEFT JOIN chi_tiet_don_hang ct ON ct.order_id = dh.id " +
                     "GROUP BY dh.id, dh.ma_so_don_hang, dh.ngay_tao, dh.tong_tien, " +
                     "dh.trang_thai, dh.id_nhan_vien, dh.id_the, nv.ho_ten, ttt.ten_loai_the " +
                     "ORDER BY dh.ngay_tao DESC";
        return findBySql(sql);
    }

    @Override
    public DonHang findById(Integer id) {
        String sql = "SELECT dh.id, dh.ma_so_don_hang, dh.ngay_tao, " +
                     "ISNULL(SUM(ct.gia_ban), dh.tong_tien) AS tong_tien, " +
                     "dh.trang_thai, dh.id_nhan_vien, dh.id_the, " +
                     "nv.ho_ten as ten_nhan_vien, ttt.ten_loai_the " +
                     "FROM don_hang dh " +
                     "LEFT JOIN nhan_vien nv ON dh.id_nhan_vien = nv.id " +
                     "LEFT JOIN the_thanh_toan ttt ON dh.id_the = ttt.id " +
                     "LEFT JOIN chi_tiet_don_hang ct ON ct.order_id = dh.id " +
                     "WHERE dh.id=? " +
                     "GROUP BY dh.id, dh.ma_so_don_hang, dh.ngay_tao, dh.tong_tien, " +
                     "dh.trang_thai, dh.id_nhan_vien, dh.id_the, nv.ho_ten, ttt.ten_loai_the";
        List<DonHang> list = findBySql(sql, id);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<DonHang> findBySql(String sql, Object... values) {
        List<DonHang> list = new ArrayList<>();
        try (QueryResult qr = JdbcUtil.executeQuery(sql, values)) {
            ResultSet rs = qr.getResultSet();
            while (rs.next()) {
                DonHang dh = new DonHang();
                dh.setId(rs.getInt("id"));
                dh.setMaSoDonHang(rs.getString("ma_so_don_hang"));
                dh.setNgayTao(rs.getTimestamp("ngay_tao"));
                dh.setTongTien(rs.getInt("tong_tien"));
                dh.setTrangThai(rs.getString("trang_thai"));
                dh.setIdNhanVien(rs.getInt("id_nhan_vien"));
                // Sửa lỗi: dùng getObject để đọc đúng giá trị NULL cho id_the
                dh.setIdThe(rs.getObject("id_the", Integer.class));
                try { dh.setTenNhanVien(rs.getString("ten_nhan_vien")); } catch (Exception ignored) {}
                try { dh.setTenLoaiThe(rs.getString("ten_loai_the")); } catch (Exception ignored) {}
                list.add(dh);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public int createAndGetId(DonHang entity) {
        String sql = "INSERT INTO don_hang(ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = JdbcUtil.getConnection();
             PreparedStatement stmt = JdbcUtil.createPreStmt(conn, sql,
                entity.getMaSoDonHang(), entity.getTongTien(),
                entity.getTrangThai(), entity.getIdNhanVien(), entity.getIdThe())) {
            stmt.executeUpdate();
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public List<DonHang> thongKeTheoNgay(String tuNgay, String denNgay) {
        String sql = "SELECT dh.id, dh.ma_so_don_hang, dh.ngay_tao, " +
                     "ISNULL(SUM(ct.gia_ban), dh.tong_tien) AS tong_tien, " +
                     "dh.trang_thai, dh.id_nhan_vien, dh.id_the, " +
                     "nv.ho_ten as ten_nhan_vien, ttt.ten_loai_the " +
                     "FROM don_hang dh " +
                     "LEFT JOIN nhan_vien nv ON dh.id_nhan_vien = nv.id " +
                     "LEFT JOIN the_thanh_toan ttt ON dh.id_the = ttt.id " +
                     "LEFT JOIN chi_tiet_don_hang ct ON ct.order_id = dh.id " +
                     "WHERE CAST(dh.ngay_tao AS DATE) BETWEEN ? AND ? " +
                     "GROUP BY dh.id, dh.ma_so_don_hang, dh.ngay_tao, dh.tong_tien, " +
                     "dh.trang_thai, dh.id_nhan_vien, dh.id_the, nv.ho_ten, ttt.ten_loai_the " +
                     "ORDER BY dh.ngay_tao DESC";
        return findBySql(sql, tuNgay, denNgay);
    }
}
