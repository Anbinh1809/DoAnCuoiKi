package com.webbanhmi.util;

import jakarta.servlet.http.HttpServletRequest;

public class ParamUtil {

    /**
     * Đọc chuỗi tham số an toàn
     */
    public static String getString(HttpServletRequest request, String name, String defaultValue) {
        String value = request.getParameter(name);
        return value != null ? value.trim() : defaultValue;
    }

    /**
     * Đọc chuỗi tham số (mặc định rỗng nếu không có)
     */
    public static String getString(HttpServletRequest request, String name) {
        return getString(request, name, "");
    }

    /**
     * Đọc số nguyên an toàn
     */
    public static int getInt(HttpServletRequest request, String name, int defaultValue) {
        String value = request.getParameter(name);
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Đọc số nguyên (mặc định 0)
     */
    public static int getInt(HttpServletRequest request, String name) {
        return getInt(request, name, 0);
    }

    /**
     * Đọc giá trị boolean (true/false)
     */
    public static boolean getBoolean(HttpServletRequest request, String name, boolean defaultValue) {
        String value = request.getParameter(name);
        return value != null ? Boolean.parseBoolean(value) : defaultValue;
    }

    /**
     * Đọc boolean (mặc định false)
     */
    public static boolean getBoolean(HttpServletRequest request, String name) {
        return getBoolean(request, name, false);
    }
}
