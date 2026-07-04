<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%
    com.webbanhmi.entity.NhanVien user = (com.webbanhmi.entity.NhanVien) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; }
    com.webbanhmi.entity.NhanVien currentUser = user;
    String currentUri = request.getRequestURI();
    boolean isAdmin = currentUser.isVaiTro();
%>
<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body { font-family: 'Inter', sans-serif; background: #f0f2f5; display: flex; min-height: 100vh; }

  /* SIDEBAR */
  .sidebar {
    width: 260px; background: linear-gradient(180deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
    min-height: 100vh; padding: 0; display: flex; flex-direction: column;
    position: fixed; top: 0; left: 0; height: 100vh; overflow-y: auto; z-index: 100;
    box-shadow: 4px 0 15px rgba(0,0,0,0.2);
  }
  .sidebar-logo {
    padding: 24px 20px; border-bottom: 1px solid rgba(255,255,255,0.1);
    display: flex; align-items: center; gap: 12px;
  }
  .sidebar-logo .logo-icon { font-size: 28px; }
  .sidebar-logo h2 { color: #fff; font-size: 18px; font-weight: 700; line-height: 1.2; }
  .sidebar-logo span { color: #f59e0b; font-size: 12px; font-weight: 400; }

  .sidebar-user { padding: 16px 20px; border-bottom: 1px solid rgba(255,255,255,0.1); }
  .sidebar-user .user-name { color: #fff; font-size: 14px; font-weight: 600; }
  .sidebar-user .user-role {
    color: #f59e0b; font-size: 11px; font-weight: 500;
    background: rgba(245,158,11,0.15); padding: 2px 8px; border-radius: 20px;
    display: inline-block; margin-top: 4px;
  }

  .nav-section { padding: 12px 0; }
  .nav-label { color: rgba(255,255,255,0.4); font-size: 10px; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; padding: 8px 20px 4px; }
  .nav-item { display: flex; align-items: center; gap: 12px; padding: 11px 20px; color: rgba(255,255,255,0.7); text-decoration: none; font-size: 14px; font-weight: 500; transition: all 0.2s; border-left: 3px solid transparent; }
  .nav-item:hover { background: rgba(255,255,255,0.08); color: #fff; border-left-color: #f59e0b; }
  .nav-item.active { background: rgba(245,158,11,0.15); color: #f59e0b; border-left-color: #f59e0b; font-weight: 600; }
  .nav-item i { width: 18px; text-align: center; font-size: 16px; }

  .sidebar-footer { margin-top: auto; padding: 16px 20px; border-top: 1px solid rgba(255,255,255,0.1); }
  .btn-logout { display: flex; align-items: center; gap: 10px; color: rgba(255,255,255,0.7); text-decoration: none; font-size: 14px; padding: 10px 12px; border-radius: 8px; transition: all 0.2s; }
  .btn-logout:hover { background: rgba(239,68,68,0.2); color: #ef4444; }

  /* MAIN CONTENT */
  .main-wrapper { margin-left: 260px; flex: 1; display: flex; flex-direction: column; min-height: 100vh; }
  .topbar { background: #fff; padding: 16px 28px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 1px 4px rgba(0,0,0,0.08); position: sticky; top: 0; z-index: 50; }
  .topbar-title { font-size: 20px; font-weight: 700; color: #1a1a2e; }
  .topbar-user { display: flex; align-items: center; gap: 8px; color: #555; font-size: 14px; }
  .topbar-user .avatar { width: 36px; height: 36px; background: linear-gradient(135deg, #f59e0b, #ef4444); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 700; font-size: 14px; }

  .page-content { padding: 28px; flex: 1; }

  /* CARDS */
  .card { background: #fff; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.07); overflow: hidden; margin-bottom: 24px; }
  .card-header { padding: 18px 24px; border-bottom: 1px solid #f0f0f0; display: flex; justify-content: space-between; align-items: center; }
  .card-header h5 { font-size: 16px; font-weight: 600; color: #1a1a2e; }
  .card-body { padding: 24px; }

  /* TABLES */
  .table { width: 100%; border-collapse: collapse; }
  .table th { background: #f8f9fa; color: #555; font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; padding: 12px 16px; text-align: left; }
  .table td { padding: 13px 16px; border-bottom: 1px solid #f0f0f0; font-size: 14px; color: #333; vertical-align: middle; }
  .table tr:last-child td { border-bottom: none; }
  .table tr:hover td { background: #fafafa; }

  /* BUTTONS */
  .btn { display: inline-flex; align-items: center; gap: 6px; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 500; cursor: pointer; border: none; text-decoration: none; transition: all 0.2s; }
  .btn-primary { background: linear-gradient(135deg, #f59e0b, #d97706); color: #fff; }
  .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 4px 12px rgba(245,158,11,0.4); }
  .btn-secondary { background: #f0f2f5; color: #555; }
  .btn-danger { background: #fee2e2; color: #ef4444; }
  .btn-danger:hover { background: #ef4444; color: #fff; }
  .btn-info { background: #dbeafe; color: #3b82f6; }
  .btn-info:hover { background: #3b82f6; color: #fff; }
  .btn-success { background: #dcfce7; color: #16a34a; }
  .btn-success:hover { background: #16a34a; color: #fff; }
  .btn-sm { padding: 5px 10px; font-size: 12px; }

  /* BADGES */
  .badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 600; }
  .badge-success { background: #dcfce7; color: #16a34a; }
  .badge-danger { background: #fee2e2; color: #ef4444; }
  .badge-warning { background: #fef9c3; color: #ca8a04; }

  /* ALERTS */
  .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 16px; font-size: 14px; display: flex; align-items: center; gap: 8px; }
  .alert-success { background: #dcfce7; color: #16a34a; border: 1px solid #bbf7d0; }
  .alert-danger { background: #fee2e2; color: #ef4444; border: 1px solid #fecaca; }

  /* FORMS */
  .form-group { margin-bottom: 16px; }
  .form-label { display: block; margin-bottom: 6px; font-size: 13px; font-weight: 500; color: #555; }
  .form-control { width: 100%; padding: 10px 14px; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 14px; color: #333; outline: none; transition: border-color 0.2s; }
  .form-control:focus { border-color: #f59e0b; box-shadow: 0 0 0 3px rgba(245,158,11,0.1); }

  /* STATS CARDS */
  .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 28px; }
  .stat-card { background: #fff; border-radius: 12px; padding: 20px 24px; box-shadow: 0 2px 8px rgba(0,0,0,0.07); display: flex; align-items: center; gap: 16px; }
  .stat-icon { width: 52px; height: 52px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 22px; }
  .stat-icon.orange { background: linear-gradient(135deg, #f59e0b22, #f59e0b44); color: #f59e0b; }
  .stat-icon.blue { background: linear-gradient(135deg, #3b82f622, #3b82f644); color: #3b82f6; }
  .stat-icon.green { background: linear-gradient(135deg, #22c55e22, #22c55e44); color: #22c55e; }
  .stat-icon.purple { background: linear-gradient(135deg, #a855f722, #a855f744); color: #a855f7; }
  .stat-value { font-size: 24px; font-weight: 700; color: #1a1a2e; }
  .stat-label { font-size: 12px; color: #888; font-weight: 500; margin-top: 2px; }
</style>
