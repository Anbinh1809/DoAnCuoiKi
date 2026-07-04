package com.webbanhmi.dao;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.webbanhmi.entity.Topping;
import com.webbanhmi.util.JdbcUtil;
import com.webbanhmi.util.JdbcUtil.QueryResult;

public class ToppingDAO implements CrudDAO<Topping, Integer> {

    @Override
    public int create(Topping entity) {
        String sql = "INSERT INTO toppings(ten_nguyen_lieu, gia_cong_them, active) VALUES (?, ?, ?)";
        try {
            return JdbcUtil.executeUpdate(sql, entity.getTenNguyenLieu(), entity.getGiaCongThem(), entity.isActive());
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public int update(Topping entity) {
        String sql = "UPDATE toppings SET ten_nguyen_lieu=?, gia_cong_them=?, active=? WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, entity.getTenNguyenLieu(), entity.getGiaCongThem(), entity.isActive(), entity.getId());
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public int delete(Integer id) {
        String sql = "UPDATE toppings SET active=0 WHERE id=?";
        try {
            return JdbcUtil.executeUpdate(sql, id);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public List<Topping> findAll() {
        return findBySql("SELECT * FROM toppings WHERE active=1");
    }

    @Override
    public Topping findById(Integer id) {
        List<Topping> list = findBySql("SELECT * FROM toppings WHERE id=?", id);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<Topping> findBySql(String sql, Object... values) {
        List<Topping> list = new ArrayList<>();
        try (QueryResult qr = JdbcUtil.executeQuery(sql, values)) {
            ResultSet rs = qr.getResultSet();
            while (rs.next()) {
                Topping t = new Topping();
                t.setId(rs.getInt("id"));
                t.setTenNguyenLieu(rs.getString("ten_nguyen_lieu"));
                t.setGiaCongThem(rs.getInt("gia_cong_them"));
                t.setActive(rs.getBoolean("active"));
                list.add(t);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
