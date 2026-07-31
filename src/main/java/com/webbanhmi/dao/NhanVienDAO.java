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
            String phone = (entity.getDienThoai() != null && !entity.getDienThoai().trim().isEmpty()) ? entity.getDienThoai().trim() : null;
            return JdbcUtil.executeUpdate(sql, entity.getTenDangNhap().trim(), entity.getMatKhau(), entity.getHoTen().trim(),
                    phone, entity.isVaiTro(), entity.isActive());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(NhanVien entity) {
        String sql = "UPDATE nhan_vien SET ten_dang_nhap=?, mat_khau=?, ho_ten=?, dien_thoai=?, vai_tro=?, active=? WHERE id=?";
        try {
            String phone = (entity.getDienThoai() != null && !entity.getDienThoai().trim().isEmpty()) ? entity.getDienThoai().trim() : null;
            return JdbcUtil.executeUpdate(sql, entity.getTenDangNhap().trim(), entity.getMatKhau(), entity.getHoTen().trim(),
                    phone, entity.isVaiTro(), entity.isActive(), entity.getId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(Integer id) {
        String sql = "UPDATE nhan_vien SET active=0 WHERE id=?"; // Xóa mềm (Soft delete / Disable)
        try {
            return JdbcUtil.executeUpdate(sql, id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int toggleActive(Integer id) {
        String sql = "UPDATE nhan_vien SET active = CASE WHEN active = 1 THEN 0 ELSE 1 END WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean hardDelete(Integer id) {
        String sql = "DELETE FROM nhan_vien WHERE id=?";
        try {
            int rows = JdbcUtil.executeUpdate(sql, id);
            return rows > 0;
        } catch (Exception e) {
            // Có ràng buộc khóa ngoại (ví dụ đã có đơn hàng) -> chuyển sang soft delete
            delete(id);
            return false;
        }
    }

    public boolean isTenDangNhapExists(String tenDangNhap, Integer excludeId) {
        if (tenDangNhap == null || tenDangNhap.trim().isEmpty()) return false;
        String sql = excludeId != null 
            ? "SELECT COUNT(*) FROM nhan_vien WHERE ten_dang_nhap = ? AND id <> ?"
            : "SELECT COUNT(*) FROM nhan_vien WHERE ten_dang_nhap = ?";
        try (QueryResult qr = excludeId != null ? JdbcUtil.executeQuery(sql, tenDangNhap.trim(), excludeId) : JdbcUtil.executeQuery(sql, tenDangNhap.trim())) {
            ResultSet rs = qr.getResultSet();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isDienThoaiExists(String dienThoai, Integer excludeId) {
        if (dienThoai == null || dienThoai.trim().isEmpty()) return false;
        String sql = excludeId != null
            ? "SELECT COUNT(*) FROM nhan_vien WHERE dien_thoai = ? AND id <> ?"
            : "SELECT COUNT(*) FROM nhan_vien WHERE dien_thoai = ?";
        try (QueryResult qr = excludeId != null ? JdbcUtil.executeQuery(sql, dienThoai.trim(), excludeId) : JdbcUtil.executeQuery(sql, dienThoai.trim())) {
            ResultSet rs = qr.getResultSet();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<NhanVien> findAll() {
        String sql = "SELECT * FROM nhan_vien ORDER BY id ASC";
        return findBySql(sql);
    }

    public List<NhanVien> findAllActive() {
        String sql = "SELECT * FROM nhan_vien WHERE active=1 ORDER BY id ASC";
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
