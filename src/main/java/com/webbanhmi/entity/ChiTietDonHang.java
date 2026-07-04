package com.webbanhmi.entity;

import java.util.List;

public class ChiTietDonHang {
    private Integer id;
    private Integer soLuong;
    private Integer giaBan;
    private Integer orderId;
    private Integer productId;
    // Thông tin join
    private String tenSp;
    private List<Topping> toppingList;

    public ChiTietDonHang() {}

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getSoLuong() { return soLuong; }
    public void setSoLuong(Integer soLuong) { this.soLuong = soLuong; }

    public Integer getGiaBan() { return giaBan; }
    public void setGiaBan(Integer giaBan) { this.giaBan = giaBan; }

    public Integer getOrderId() { return orderId; }
    public void setOrderId(Integer orderId) { this.orderId = orderId; }

    public Integer getProductId() { return productId; }
    public void setProductId(Integer productId) { this.productId = productId; }

    public String getTenSp() { return tenSp; }
    public void setTenSp(String tenSp) { this.tenSp = tenSp; }

    public List<Topping> getToppingList() { return toppingList; }
    public void setToppingList(List<Topping> toppingList) { this.toppingList = toppingList; }
}
