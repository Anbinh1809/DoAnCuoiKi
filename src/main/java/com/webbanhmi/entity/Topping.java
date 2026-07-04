package com.webbanhmi.entity;

public class Topping {
    private Integer id;
    private String tenNguyenLieu;
    private Integer giaCongThem;
    private boolean active;

    public Topping() {}

    public Topping(Integer id, String tenNguyenLieu, Integer giaCongThem, boolean active) {
        this.id = id;
        this.tenNguyenLieu = tenNguyenLieu;
        this.giaCongThem = giaCongThem;
        this.active = active;
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getTenNguyenLieu() { return tenNguyenLieu; }
    public void setTenNguyenLieu(String tenNguyenLieu) { this.tenNguyenLieu = tenNguyenLieu; }

    public Integer getGiaCongThem() { return giaCongThem; }
    public void setGiaCongThem(Integer giaCongThem) { this.giaCongThem = giaCongThem; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
