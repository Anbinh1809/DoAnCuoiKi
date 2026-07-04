package com.webbanhmi.entity;

public class SanPham {
    private Integer id;
    private String tenSp;
    private Integer giaCoBan;
    private String anhSp;
    private String moTa;
    private boolean active;
    private Integer idLoaiSp;
    // Thông tin join
    private String tenLoaiSp;

    public SanPham() {}

    public SanPham(Integer id, String tenSp, Integer giaCoBan, String anhSp,
                   String moTa, boolean active, Integer idLoaiSp) {
        this.id = id;
        this.tenSp = tenSp;
        this.giaCoBan = giaCoBan;
        this.anhSp = anhSp;
        this.moTa = moTa;
        this.active = active;
        this.idLoaiSp = idLoaiSp;
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getTenSp() { return tenSp; }
    public void setTenSp(String tenSp) { this.tenSp = tenSp; }

    public Integer getGiaCoBan() { return giaCoBan; }
    public void setGiaCoBan(Integer giaCoBan) { this.giaCoBan = giaCoBan; }

    public String getAnhSp() { return anhSp; }
    public void setAnhSp(String anhSp) { this.anhSp = anhSp; }

    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public Integer getIdLoaiSp() { return idLoaiSp; }
    public void setIdLoaiSp(Integer idLoaiSp) { this.idLoaiSp = idLoaiSp; }

    public String getTenLoaiSp() { return tenLoaiSp; }
    public void setTenLoaiSp(String tenLoaiSp) { this.tenLoaiSp = tenLoaiSp; }
}
