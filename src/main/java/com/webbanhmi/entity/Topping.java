package com.webbanhmi.entity;

public class Topping {
    private Integer id;
    private String tenNguyenLieu;
    private Integer giaCongThem;
    private Integer soLuongTon;
    private String donViTinh;
    private boolean active;

    public Topping() {}

    public Topping(Integer id, String tenNguyenLieu, Integer giaCongThem, boolean active) {
        this.id = id;
        this.tenNguyenLieu = tenNguyenLieu;
        this.giaCongThem = giaCongThem;
        this.active = active;
        this.soLuongTon = 50;
        this.donViTinh = "Phần";
    }

    public Topping(Integer id, String tenNguyenLieu, Integer giaCongThem, Integer soLuongTon, String donViTinh, boolean active) {
        this.id = id;
        this.tenNguyenLieu = tenNguyenLieu;
        this.giaCongThem = giaCongThem;
        this.soLuongTon = soLuongTon;
        this.donViTinh = donViTinh;
        this.active = active;
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getTenNguyenLieu() { return tenNguyenLieu; }
    public void setTenNguyenLieu(String tenNguyenLieu) { this.tenNguyenLieu = tenNguyenLieu; }

    public Integer getGiaCongThem() { return giaCongThem; }
    public void setGiaCongThem(Integer giaCongThem) { this.giaCongThem = giaCongThem; }

    public Integer getSoLuongTon() { return soLuongTon != null ? soLuongTon : 0; }
    public void setSoLuongTon(Integer soLuongTon) { this.soLuongTon = soLuongTon; }

    public String getDonViTinh() { return donViTinh != null ? donViTinh : "Phần"; }
    public void setDonViTinh(String donViTinh) { this.donViTinh = donViTinh; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
