package com.webbanhmi.entity;

public class NhanVien {
    private Integer id;
    private String tenDangNhap;
    private String matKhau;
    private String hoTen;
    private String dienThoai;
    private boolean vaiTro; // true = admin, false = staff
    private boolean active;

    public NhanVien() {}

    public NhanVien(Integer id, String tenDangNhap, String matKhau, String hoTen,
                    String dienThoai, boolean vaiTro, boolean active) {
        this.id = id;
        this.tenDangNhap = tenDangNhap;
        this.matKhau = matKhau;
        this.hoTen = hoTen;
        this.dienThoai = dienThoai;
        this.vaiTro = vaiTro;
        this.active = active;
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getTenDangNhap() { return tenDangNhap; }
    public void setTenDangNhap(String tenDangNhap) { this.tenDangNhap = tenDangNhap; }

    public String getMatKhau() { return matKhau; }
    public void setMatKhau(String matKhau) { this.matKhau = matKhau; }

    public String getHoTen() { return hoTen; }
    public void setHoTen(String hoTen) { this.hoTen = hoTen; }

    public String getDienThoai() { return dienThoai; }
    public void setDienThoai(String dienThoai) { this.dienThoai = dienThoai; }

    public boolean isVaiTro() { return vaiTro; }
    public void setVaiTro(boolean vaiTro) { this.vaiTro = vaiTro; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
