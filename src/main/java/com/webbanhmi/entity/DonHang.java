package com.webbanhmi.entity;

import java.util.Date;
import java.util.List;

public class DonHang {
    private Integer id;
    private String maSoDonHang;
    private Date ngayTao;
    private Integer tongTien;
    private String trangThai;
    private Integer idNhanVien;
    private Integer idThe;
    // Thông tin join
    private String tenNhanVien;
    private String tenLoaiThe;
    private List<ChiTietDonHang> chiTietList;

    public DonHang() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public String getMaSoDonHang() { return maSoDonHang; }
    public void setMaSoDonHang(String maSoDonHang) { this.maSoDonHang = maSoDonHang; }

    public Date getNgayTao() { return ngayTao; }
    public void setNgayTao(Date ngayTao) { this.ngayTao = ngayTao; }

    public Integer getTongTien() { return tongTien; }
    public void setTongTien(Integer tongTien) { this.tongTien = tongTien; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }

    public Integer getIdNhanVien() { return idNhanVien; }
    public void setIdNhanVien(Integer idNhanVien) { this.idNhanVien = idNhanVien; }

    public Integer getIdThe() { return idThe; }
    public void setIdThe(Integer idThe) { this.idThe = idThe; }

    public String getTenNhanVien() { return tenNhanVien; }
    public void setTenNhanVien(String tenNhanVien) { this.tenNhanVien = tenNhanVien; }

    public String getTenLoaiThe() { return tenLoaiThe; }
    public void setTenLoaiThe(String tenLoaiThe) { this.tenLoaiThe = tenLoaiThe; }

    public List<ChiTietDonHang> getChiTietList() { return chiTietList; }
    public void setChiTietList(List<ChiTietDonHang> chiTietList) { this.chiTietList = chiTietList; }
}
