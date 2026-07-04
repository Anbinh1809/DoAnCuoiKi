package com.webbanhmi.dao;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.webbanhmi.entity.NhanVien;
import com.webbanhmi.util.JdbcUtil;
import com.webbanhmi.util.JdbcUtil.QueryResult;

public class NhanVienDAO implements CrudDAO<NhanVien, Integer> {

    @Override
    public int create(NhanVien entity) {
        String sql = "INSERT INTO nhan_vien(ten_dang_nhap, mat_khau, ho_ten, dien_thoai, vai_tro, active) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            return JdbcUtil.executeUpdate(sql, entity.getTenDangNhap(), entity.getMatKhau(), entity.getHoTen(),
                    entity.getDienThoai(), entity.isVaiTro(), entity.isActive());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(NhanVien entity) {
        String sql = "UPDATE nhan_vien SET ten_dang_nhap=?, mat_khau=?, ho_ten=?, dien_thoai=?, vai_tro=?, active=? WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, entity.getTenDangNhap(), entity.getMatKhau(), entity.getHoTen(),
                    entity.getDienThoai(), entity.isVaiTro(), entity.isActive(), entity.getId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(Integer id) {
        String sql = "UPDATE nhan_vien SET active=0 WHERE id=?"; // Xóa mềm (Soft delete)
        try {
            return JdbcUtil.executeUpdate(sql, id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<NhanVien> findAll() {
        // Lấy tất cả kể cả inactive (dùng cho trang quản lý nhân viên)
        String sql = "SELECT * FROM nhan_vien";
        return findBySql(sql);
    }

    /** Chỉ lấy nhân viên đang active (dùng cho dashboard thống kê) */
    public List<NhanVien> findAllActive() {
        String sql = "SELECT * FROM nhan_vien WHERE active=1";
        return findBySql(sql);
    }

    @Override
    public NhanVien findById(Integer id) {
        String sql = "SELECT * FROM nhan_vien WHERE id=?";
        List<NhanVien> list = findBySql(sql, id);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<NhanVien> findBySql(String sql, Object... values) {
        List<NhanVien> list = new ArrayList<>();
        try (QueryResult qr = JdbcUtil.executeQuery(sql, values)) {
            ResultSet rs = qr.getResultSet();
            while (rs.next()) {
                NhanVien nv = new NhanVien();
                nv.setId(rs.getInt("id"));
                nv.setTenDangNhap(rs.getString("ten_dang_nhap"));
                nv.setMatKhau(rs.getString("mat_khau"));
                nv.setHoTen(rs.getString("ho_ten"));
                nv.setDienThoai(rs.getString("dien_thoai"));
                nv.setVaiTro(rs.getBoolean("vai_tro"));
                nv.setActive(rs.getBoolean("active"));
                list.add(nv);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public NhanVien findByTenDangNhap(String tenDangNhap) {
        String sql = "SELECT * FROM nhan_vien WHERE ten_dang_nhap = ? AND active = 1";
        List<NhanVien> list = findBySql(sql, tenDangNhap);
        return list.isEmpty() ? null : list.get(0);
    }
}
