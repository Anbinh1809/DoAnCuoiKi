package com.webbanhmi.entity;

public class TheThanhToan {
    private Integer id;
    private String tenLoaiThe;
    private boolean active;

    public TheThanhToan() {}

    public TheThanhToan(Integer id, String tenLoaiThe, boolean active) {
        this.id = id;
        this.tenLoaiThe = tenLoaiThe;
        this.active = active;
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getTenLoaiThe() { return tenLoaiThe; }
    public void setTenLoaiThe(String tenLoaiThe) { this.tenLoaiThe = tenLoaiThe; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
