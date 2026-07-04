package com.webbanhmi.dao;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.webbanhmi.entity.TheThanhToan;
import com.webbanhmi.util.JdbcUtil;
import com.webbanhmi.util.JdbcUtil.QueryResult;

public class TheThanhToanDAO implements CrudDAO<TheThanhToan, Integer> {

    @Override
    public int create(TheThanhToan entity) {
        String sql = "INSERT INTO the_thanh_toan(ten_loai_the, active) VALUES (?, ?)";
        try {
            return JdbcUtil.executeUpdate(sql, entity.getTenLoaiThe(), entity.isActive());
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public int update(TheThanhToan entity) {
        String sql = "UPDATE the_thanh_toan SET ten_loai_the=?, active=? WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, entity.getTenLoaiThe(), entity.isActive(), entity.getId());
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public int delete(Integer id) {
        String sql = "UPDATE the_thanh_toan SET active=0 WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, id);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public List<TheThanhToan> findAll() {
        return findBySql("SELECT * FROM the_thanh_toan WHERE active=1");
    }

    @Override
    public TheThanhToan findById(Integer id) {
        List<TheThanhToan> list = findBySql("SELECT * FROM the_thanh_toan WHERE id=?", id);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<TheThanhToan> findBySql(String sql, Object... values) {
        List<TheThanhToan> list = new ArrayList<>();
        try (QueryResult qr = JdbcUtil.executeQuery(sql, values)) {
            ResultSet rs = qr.getResultSet();
            while (rs.next()) {
                TheThanhToan t = new TheThanhToan();
                t.setId(rs.getInt("id"));
                t.setTenLoaiThe(rs.getString("ten_loai_the"));
                t.setActive(rs.getBoolean("active"));
                list.add(t);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
