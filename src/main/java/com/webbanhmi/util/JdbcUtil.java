package com.webbanhmi.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

public class JdbcUtil {
    // Thông tin cấu hình kết nối SQL Server
    static String driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    static String dburl = "jdbc:sqlserver://localhost:1433;database=webbanhmi;encrypt=false";
    static String username = "sa";
    static String password = "123456";

    // Nạp driver khi class được khởi tạo
    static {
        try {
            Class.forName(driver);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            System.err.println("Lỗi nạp JDBC Driver: " + e.getMessage());
        }
    }

    /** Mở kết nối đến CSDL */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(dburl, username, password);
    }

    /**
     * Tạo PreparedStatement cho cả câu lệnh SQL thường hoặc Gọi Thủ tục (Stored Procedure).
     * Lưu ý: Người gọi phải tự đóng cả stmt VÀ connection sau khi dùng xong.
     */
    public static PreparedStatement createPreStmt(Connection connection, String sql, Object... values) throws SQLException {
        PreparedStatement stmt;
        if (sql.trim().startsWith("{")) {
            stmt = connection.prepareCall(sql);
        } else {
            stmt = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
        }
        for (int i = 0; i < values.length; i++) {
            if (values[i] == null) {
                stmt.setNull(i + 1, Types.INTEGER);
            } else {
                stmt.setObject(i + 1, values[i]);
            }
        }
        return stmt;
    }

    /** Dành cho thao tác Cập nhật (INSERT, UPDATE, DELETE) - tự đóng connection */
    public static int executeUpdate(String sql, Object... values) throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement stmt = createPreStmt(conn, sql, values)) {
            return stmt.executeUpdate();
        }
    }

    /**
     * Truy vấn dữ liệu (SELECT).
     * Trả về QueryResult chứa cả ResultSet lẫn Connection để đóng sau khi dùng xong.
     * Gọi result.close() sau khi đọc xong để tránh rò rỉ kết nối.
     */
    public static QueryResult executeQuery(String sql, Object... values) throws SQLException {
        Connection conn = getConnection();
        try {
            PreparedStatement stmt = createPreStmt(conn, sql, values);
            ResultSet rs = stmt.executeQuery();
            return new QueryResult(conn, stmt, rs);
        } catch (SQLException e) {
            // Nếu lỗi sau khi mở connection thì đóng ngay
            try { conn.close(); } catch (Exception ignored) {}
            throw e;
        }
    }

    /**
     * Wrapper để đóng Connection + Statement + ResultSet cùng lúc
     */
    public static class QueryResult implements AutoCloseable {
        private final Connection connection;
        private final PreparedStatement statement;
        private final ResultSet resultSet;

        public QueryResult(Connection connection, PreparedStatement statement, ResultSet resultSet) {
            this.connection = connection;
            this.statement = statement;
            this.resultSet = resultSet;
        }

        public ResultSet getResultSet() {
            return resultSet;
        }

        @Override
        public void close() {
            try { if (resultSet != null) resultSet.close(); } catch (Exception ignored) {}
            try { if (statement != null) statement.close(); } catch (Exception ignored) {}
            try { if (connection != null) connection.close(); } catch (Exception ignored) {}
        }
    }
}
