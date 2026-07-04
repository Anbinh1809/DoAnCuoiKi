package com.webbanhmi.dao;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.webbanhmi.entity.SanPham;
import com.webbanhmi.util.JdbcUtil;
import com.webbanhmi.util.JdbcUtil.QueryResult;

public class SanPhamDAO implements CrudDAO<SanPham, Integer> {

    @Override
    public int create(SanPham entity) {
        String sql = "INSERT INTO san_pham(ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            return JdbcUtil.executeUpdate(sql, entity.getTenSp(), entity.getGiaCoBan(), entity.getAnhSp(),
                    entity.getMoTa(), entity.isActive(), entity.getIdLoaiSp());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int update(SanPham entity) {
        String sql = "UPDATE san_pham SET ten_sp=?, gia_co_ban=?, anh_sp=?, mo_ta=?, active=?, id_loai_sp=? WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, entity.getTenSp(), entity.getGiaCoBan(), entity.getAnhSp(),
                    entity.getMoTa(), entity.isActive(), entity.getIdLoaiSp(), entity.getId());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int delete(Integer id) {
        String sql = "UPDATE san_pham SET active=0 WHERE id=?"; // Soft delete
        try {
            return JdbcUtil.executeUpdate(sql, id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<SanPham> findAll() {
        String sql = "SELECT sp.*, lsp.ten_loai FROM san_pham sp " +
                     "LEFT JOIN loai_san_pham lsp ON sp.id_loai_sp = lsp.id WHERE sp.active=1";
        return findBySql(sql);
    }

    @Override
    public SanPham findById(Integer id) {
        String sql = "SELECT sp.*, lsp.ten_loai FROM san_pham sp " +
                     "LEFT JOIN loai_san_pham lsp ON sp.id_loai_sp = lsp.id WHERE sp.id=?";
        List<SanPham> list = findBySql(sql, id);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<SanPham> findBySql(String sql, Object... values) {
        List<SanPham> list = new ArrayList<>();
        try (QueryResult qr = JdbcUtil.executeQuery(sql, values)) {
            ResultSet rs = qr.getResultSet();
            while (rs.next()) {
                SanPham sp = new SanPham();
                sp.setId(rs.getInt("id"));
                sp.setTenSp(rs.getString("ten_sp"));
                sp.setGiaCoBan(rs.getInt("gia_co_ban"));
                sp.setAnhSp(rs.getString("anh_sp"));
                sp.setMoTa(rs.getString("mo_ta"));
                sp.setActive(rs.getBoolean("active"));
                sp.setIdLoaiSp(rs.getInt("id_loai_sp"));
                // Đọc tên loại sản phẩm (từ JOIN)
                try { sp.setTenLoaiSp(rs.getString("ten_loai")); } catch (Exception ignored) {}
                list.add(sp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
