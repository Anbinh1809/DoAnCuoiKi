package com.webbanhmi.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class FixDbData {
    public static void main(String[] args) {
        System.out.println("Starting Database Data & Unicode Repair...");
        try (Connection conn = JdbcUtil.getConnection()) {
            
            // 1. Fix nhan_vien names
            String[][] staffData = {
                {"admin", "Quản Trị Viên"},
                {"staff", "Đặng Phi Hùng"},
                {"staff1", "Nguyễn Thị An"},
                {"staff2", "Trần Văn Bình"},
                {"staff3", "Lê Thị Cúc"},
                {"staff4", "Phạm Văn Dũng"},
                {"staff5", "Hoàng Thị Em"}
            };

            for (String[] st : staffData) {
                String sql = "UPDATE nhan_vien SET ho_ten = ? WHERE ten_dang_nhap = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setNString(1, st[1]);
                    stmt.setString(2, st[0]);
                    stmt.executeUpdate();
                }
            }
            System.out.println("✓ Updated nhan_vien names with correct Unicode.");

            // 2. Fix loai_san_pham names
            String[][] loaiData = {
                {"1", "Bánh Mì Thịt"},
                {"2", "Bánh Mì Chay / Món Khác"},
                {"3", "Đồ Uống"}
            };

            for (String[] l : loaiData) {
                String sql = "UPDATE loai_san_pham SET ten_loai = ? WHERE id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setNString(1, l[1]);
                    stmt.setInt(2, Integer.parseInt(l[0]));
                    stmt.executeUpdate();
                }
            }
            System.out.println("✓ Updated loai_san_pham names with correct Unicode.");

            // 3. Fix san_pham names & descriptions
            Object[][] spData = {
                {1, "Bánh mì thịt nướng", 20000, "banh-mi-thit-nuong.jpg", "Bánh mì thịt nướng truyền thống thơm ngon", 1},
                {2, "Bánh mì xíu mại", 18000, "banh-mi-xiu-mai.jpg", "Bánh mì xíu mại đậm đà sốt cà", 1},
                {3, "Trà tắc giải nhiệt", 10000, "tra-tac.jpg", "Trà tắc mát lạnh giải nhiệt mùa hè", 3},
                {4, "Bánh mì không", 5000, "banh-mi-khong.jpg", "Bánh mì giòn rụm nóng hổi", 1},
                {5, "Bánh bao 2 trứng", 20000, "banh-bao.jpg", "Bánh bao nhân thịt trứng cút thơm ngon", 2},
                {6, "Há cảo tôm", 25000, "ha-cao.jpg", "Há cảo tôm hấp mềm ngon", 2},
                {24, "Bánh mì chả lụa", 20000, "banh-mi-cha-lua.jpg", "Bánh mì chả lụa pate thơm béo", 1},
                {25, "Bánh mì gà xé", 22000, "banh-mi-ga-xe.jpg", "Bánh mì gà xé phay giòn rụm", 1},
                {26, "Bánh mì ốp la pate", 18000, "banh-mi-op-la.jpg", "Bánh mì ốp la 2 trứng dốt pate", 1},
                {27, "Bánh mì bò lá lốt", 25000, "banh-mi-bo-la-lot.jpg", "Bánh mì bò lá lốt nướng than hồng", 1},
                {28, "Bánh mì chả cá", 20000, "banh-mi-cha-ca.jpg", "Bánh mì chả cá Nha Trang nóng hổi", 1},
                {29, "Bánh mì đặc biệt", 30000, "banh-mi-dac-biet.jpg", "Bánh mì full topping đặc biệt hủ tiếu bánh mì", 1},
                {30, "Cà phê sữa đá", 15000, "ca-phe-sua.jpg", "Cà phê pha phin đậm đà chuẩn vị Việt", 3},
                {31, "Cà phê đen đá", 12000, "ca-phe-den.jpg", "Cà phê đen đá nguyên chất tỉnh táo", 3},
                {32, "Trà đào cam sả", 20000, "tra-dao-cam-sa.jpg", "Trà đào cam sả thơm ngon mọng nước", 3},
                {33, "Trà sữa truyền thống", 22000, "tra-sua.jpg", "Trà sữa nhà làm topping chân trâu", 3},
                {34, "Nước sâm dứa thạch", 12000, "nuoc-sam.jpg", "Nước sâm dứa thạch nhà nấu", 3},
                {35, "Nước ngọt (Coca/Pepsi)", 12000, "nuoc-ngot.jpg", "Nước ngọt lon mát lạnh", 3},
                {36, "Bánh bao xá xíu", 18000, "banh-bao-xa-xiu.jpg", "Bánh bao nhân xá xíu trứng cút", 2},
                {37, "Bánh bao chay", 12000, "banh-bao-chay.jpg", "Bánh bao nấm hạt nêm thanh tịnh", 2},
                {38, "Há cảo hấp (4 viên)", 20000, "ha-cao.jpg", "Há cảo tôm thịt hấp nóng hổi", 2},
                {39, "Xíu mại chén", 25000, "xiu-mai-chen.jpg", "Xíu mại chén chấm bánh mì giòn", 2}
            };

            for (Object[] sp : spData) {
                int id = (int) sp[0];
                String name = (String) sp[1];
                int price = (int) sp[2];
                String img = (String) sp[3];
                String desc = (String) sp[4];
                int idLoai = (int) sp[5];

                String checkSql = "SELECT COUNT(*) FROM san_pham WHERE id = ?";
                boolean exists = false;
                try (PreparedStatement cstmt = conn.prepareStatement(checkSql)) {
                    cstmt.setInt(1, id);
                    ResultSet rs = cstmt.executeQuery();
                    if (rs.next() && rs.getInt(1) > 0) exists = true;
                }

                if (exists) {
                    String updateSql = "UPDATE san_pham SET ten_sp = ?, gia_co_ban = ?, anh_sp = ?, mo_ta = ? WHERE id = ?";
                    try (PreparedStatement ustmt = conn.prepareStatement(updateSql)) {
                        ustmt.setNString(1, name);
                        ustmt.setInt(2, price);
                        ustmt.setString(3, img);
                        ustmt.setNString(4, desc);
                        ustmt.setInt(5, id);
                        ustmt.executeUpdate();
                    }
                } else {
                    String insertSql = "INSERT INTO san_pham (ten_sp, gia_co_ban, anh_sp, mo_ta, active, id_loai_sp) VALUES (?, ?, ?, ?, 1, ?)";
                    try (PreparedStatement istmt = conn.prepareStatement(insertSql)) {
                        istmt.setNString(1, name);
                        istmt.setInt(2, price);
                        istmt.setString(3, img);
                        istmt.setNString(4, desc);
                        istmt.setInt(5, idLoai);
                        istmt.executeUpdate();
                    }
                }
            }
            System.out.println("✓ Updated san_pham names & descriptions with correct Unicode.");

            // 4. Fix toppings table
            Object[][] toppingData = {
                {1, "Trứng ốp la", 5000, 50, "Quả"},
                {2, "Pate nhà làm", 3000, 50, "Phần"},
                {3, "Chả lụa thêm", 5000, 50, "Phần"},
                {4, "Thịt nướng thêm", 8000, 50, "Phần"},
                {11, "Phô mai Con Bò Cười", 5000, 50, "Cái"},
                {12, "Bơ béo nhà làm", 3000, 50, "Muỗng"},
                {13, "Gà xé thêm", 8000, 50, "Phần"},
                {14, "Xá xíu thêm", 8000, 50, "Phần"},
                {15, "Xúc xích Đức", 7000, 50, "Cây"},
                {16, "Kim chi ăn kèm", 4000, 30, "Hộp"}
            };

            for (Object[] top : toppingData) {
                int id = (int) top[0];
                String name = (String) top[1];
                int price = (int) top[2];
                int qty = (int) top[3];
                String unit = (String) top[4];

                String checkSql = "SELECT COUNT(*) FROM toppings WHERE id = ?";
                boolean exists = false;
                try (PreparedStatement cstmt = conn.prepareStatement(checkSql)) {
                    cstmt.setInt(1, id);
                    ResultSet rs = cstmt.executeQuery();
                    if (rs.next() && rs.getInt(1) > 0) exists = true;
                }

                if (exists) {
                    String updateSql = "UPDATE toppings SET ten_nguyen_lieu = ?, gia_cong_them = ?, so_luong_ton = ?, don_vi_tinh = ?, active = 1 WHERE id = ?";
                    try (PreparedStatement ustmt = conn.prepareStatement(updateSql)) {
                        ustmt.setNString(1, name);
                        ustmt.setInt(2, price);
                        ustmt.setInt(3, qty);
                        ustmt.setNString(4, unit);
                        ustmt.setInt(5, id);
                        ustmt.executeUpdate();
                    }
                } else {
                    String insertSql = "INSERT INTO toppings (ten_nguyen_lieu, gia_cong_them, so_luong_ton, don_vi_tinh, active) VALUES (?, ?, ?, ?, 1)";
                    try (PreparedStatement istmt = conn.prepareStatement(insertSql)) {
                        istmt.setNString(1, name);
                        istmt.setInt(2, price);
                        istmt.setInt(3, qty);
                        istmt.setNString(4, unit);
                        istmt.executeUpdate();
                    }
                }
            }
            System.out.println("✓ Updated toppings with correct Unicode and stock quantities.");

            // 5. Populate sample orders for 7 days
            int[] staffIds = {1, 5, 6, 7, 8, 9}; // admin, staff1, staff2, staff3, staff4, staff5
            String[] datesArr = {"2026-07-25", "2026-07-26", "2026-07-27", "2026-07-28", "2026-07-29", "2026-07-30", "2026-07-31"};

            int ordCount = 800;
            for (String d : datesArr) {
                for (int stId : staffIds) {
                    ordCount++;
                    String maHd = "HDFIX" + ordCount;

                    String chkOrd = "SELECT COUNT(*) FROM don_hang WHERE ma_so_don_hang = ?";
                    try (PreparedStatement cstmt = conn.prepareStatement(chkOrd)) {
                        cstmt.setString(1, maHd);
                        ResultSet rs = cstmt.executeQuery();
                        if (rs.next() && rs.getInt(1) > 0) continue;
                    }

                    int total = 45000 + (ordCount % 5) * 10000;
                    String dtStr = d + " " + String.format("%02d:%02d:00", 8 + (ordCount % 9), (ordCount * 17) % 60);

                    String insOrd = "INSERT INTO don_hang (ma_so_don_hang, tong_tien, trang_thai, id_nhan_vien, id_the, ngay_tao) VALUES (?, ?, 'COMPLETED', ?, 1, ?)";
                    try (PreparedStatement istmt = conn.prepareStatement(insOrd, Statement.RETURN_GENERATED_KEYS)) {
                        istmt.setString(1, maHd);
                        istmt.setInt(2, total);
                        istmt.setInt(3, stId);
                        istmt.setString(4, dtStr);
                        istmt.executeUpdate();

                        try (ResultSet rk = istmt.getGeneratedKeys()) {
                            if (rk.next()) {
                                int newOrdId = rk.getInt(1);
                                String insItem1 = "INSERT INTO chi_tiet_don_hang (order_id, product_id, so_luong, gia_ban) VALUES (?, 1, 2, 40000)";
                                try (PreparedStatement itmStmt1 = conn.prepareStatement(insItem1)) {
                                    itmStmt1.setInt(1, newOrdId);
                                    itmStmt1.executeUpdate();
                                }
                                String insItem2 = "INSERT INTO chi_tiet_don_hang (order_id, product_id, so_luong, gia_ban) VALUES (?, 3, 1, 10000)";
                                try (PreparedStatement itmStmt2 = conn.prepareStatement(insItem2)) {
                                    itmStmt2.setInt(1, newOrdId);
                                    itmStmt2.executeUpdate();
                                }
                            }
                        }
                    }
                }
            }
            System.out.println("✓ Updated don_hang with 7-day rich orders for all staff members.");
            System.out.println("Database Repair & Data Population Complete Success!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
