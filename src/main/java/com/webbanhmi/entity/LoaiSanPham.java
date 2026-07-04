package com.webbanhmi.entity;

public class LoaiSanPham {
    private Integer id;
    private String tenLoai;
    private boolean active;

    public LoaiSanPham() {}

    public LoaiSanPham(Integer id, String tenLoai, boolean active) {
        this.id = id;
        this.tenLoai = tenLoai;
        this.active = active;
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getTenLoai() { return tenLoai; }
    public void setTenLoai(String tenLoai) { this.tenLoai = tenLoai; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
