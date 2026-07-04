package com.webbanhmi.dao;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.webbanhmi.entity.LoaiSanPham;
import com.webbanhmi.util.JdbcUtil;
import com.webbanhmi.util.JdbcUtil.QueryResult;

public class LoaiSanPhamDAO implements CrudDAO<LoaiSanPham, Integer> {

    @Override
    public int create(LoaiSanPham entity) {
        String sql = "INSERT INTO loai_san_pham(ten_loai, active) VALUES (?, ?)";
        try {
            return JdbcUtil.executeUpdate(sql, entity.getTenLoai(), entity.isActive());
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public int update(LoaiSanPham entity) {
        String sql = "UPDATE loai_san_pham SET ten_loai=?, active=? WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, entity.getTenLoai(), entity.isActive(), entity.getId());
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public int delete(Integer id) {
        String sql = "UPDATE loai_san_pham SET active=0 WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, id);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public List<LoaiSanPham> findAll() {
        return findBySql("SELECT * FROM loai_san_pham WHERE active=1");
    }

    @Override
    public LoaiSanPham findById(Integer id) {
        List<LoaiSanPham> list = findBySql("SELECT * FROM loai_san_pham WHERE id=?", id);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<LoaiSanPham> findBySql(String sql, Object... values) {
        List<LoaiSanPham> list = new ArrayList<>();
        try (QueryResult qr = JdbcUtil.executeQuery(sql, values)) {
            ResultSet rs = qr.getResultSet();
            while (rs.next()) {
                LoaiSanPham obj = new LoaiSanPham();
                obj.setId(rs.getInt("id"));
                obj.setTenLoai(rs.getString("ten_loai"));
                obj.setActive(rs.getBoolean("active"));
                list.add(obj);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
