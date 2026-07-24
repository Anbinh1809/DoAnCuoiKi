<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tiệm Bánh Mì - Đậm Đà Hương Vị Truyền Thống</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;800&family=Playfair+Display:ital,wght@0,600;0,700;1,600&display=swap" rel="stylesheet">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --primary: #f59e0b;
            --primary-hover: #d97706;
            --text-dark: #1f2937;
            --text-light: #f9fafb;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Outfit', sans-serif;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            padding: 0 10%;
            position: relative;
            color: var(--text-light);
            overflow: hidden;
        }

        /* Slider Backgrounds */
        .slider-bg {
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            z-index: 0;
            background-size: cover;
            background-position: center;
            opacity: 0;
            transition: opacity 1s ease;
            animation: sliderFade 25s infinite;
        }

        /* bg-1 hiển thị ngay từ đầu */
        .bg-1 { animation-delay: 0s; }
        .bg-2 { animation-delay: 5s; }
        .bg-3 { animation-delay: 10s; }
        .bg-4 { animation-delay: 15s; }
        .bg-5 { animation-delay: 20s; }

        @keyframes sliderFade {
            0%   { opacity: 0; transform: scale(1.06); }
            4%   { opacity: 1; transform: scale(1.04); }
            20%  { opacity: 1; transform: scale(1.02); }
            24%  { opacity: 0; transform: scale(1.01); }
            100% { opacity: 0; transform: scale(1); }
        }

        /* Overlay tối đi một chút để chữ dễ đọc hơn */
        body::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(to right, rgba(0,0,0,0.7) 0%, rgba(0,0,0,0.2) 100%);
            z-index: 1;
        }

        .landing-content {
            position: absolute;
            left: 10%;
            top: 50%;
            transform: translateY(-50%);
            z-index: 2;
            max-width: 500px;
            animation: fadeSlideIn 1s ease-out forwards;
        }

        .landing-content h1 {
            font-family: 'Playfair Display', serif;
            font-size: 4rem;
            line-height: 1.1;
            margin-bottom: 20px;
            color: #fff;
            text-shadow: 2px 4px 10px rgba(0,0,0,0.5);
        }

        .landing-content h1 span {
            color: var(--primary);
        }

        .landing-content p {
            font-size: 1.1rem;
            line-height: 1.6;
            color: #e5e7eb;
            margin-bottom: 30px;
            text-shadow: 1px 2px 5px rgba(0,0,0,0.5);
        }

        /* Hiệu ứng Kính Mờ (Glassmorphism) */
        .login-glass-card {
            position: relative;
            z-index: 2;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 40px;
            border-radius: 24px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 24px 60px rgba(0,0,0,0.4);
            animation: fadeSlideUp 1s ease-out forwards;
            animation-delay: 0.3s;
            opacity: 0;
        }

        .login-glass-card h2 {
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 8px;
            color: #fff;
            text-align: center;
        }

        .login-glass-card p.subtitle {
            text-align: center;
            color: rgba(255,255,255,0.7);
            margin-bottom: 30px;
            font-size: 0.95rem;
        }

        .input-group {
            position: relative;
            margin-bottom: 24px;
        }

        .input-group i {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: rgba(255,255,255,0.6);
            transition: 0.3s;
        }

        .input-group input {
            width: 100%;
            padding: 16px 16px 16px 48px;
            background: rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            color: #fff;
            font-size: 1rem;
            font-family: 'Outfit', sans-serif;
            outline: none;
            transition: 0.3s;
        }

        .input-group input::placeholder {
            color: rgba(255,255,255,0.5);
        }

        .input-group input:focus {
            background: rgba(0, 0, 0, 0.4);
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(245, 158, 11, 0.1);
        }

        .input-group input:focus + i,
        .input-group input:not(:placeholder-shown) + i {
            color: var(--primary);
        }

        .btn-login {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, var(--primary), var(--primary-hover));
            border: none;
            color: white;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            font-family: 'Outfit', sans-serif;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 8px 20px rgba(245, 158, 11, 0.3);
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 25px rgba(245, 158, 11, 0.4);
        }
        
        .btn-login:active {
            transform: translateY(1px);
        }

        .error {
            background: rgba(239, 68, 68, 0.2);
            border-left: 4px solid #ef4444;
            color: #fca5a5;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 8px;
            animation: shake 0.5s ease-in-out;
        }

        /* Animations */
        @keyframes fadeSlideIn {
            from { opacity: 0; transform: translate(-30px, -50%); }
            to { opacity: 1; transform: translate(0, -50%); }
        }

        @keyframes fadeSlideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            50% { transform: translateX(5px); }
            75% { transform: translateX(-5px); }
        }

        /* Responsive */
        @media (max-width: 900px) {
            body {
                flex-direction: column;
                justify-content: center;
                align-items: center;
                padding: 20px;
                background-position: 70% center;
            }
            body::before {
                background: linear-gradient(to bottom, rgba(0,0,0,0.6) 0%, rgba(0,0,0,0.8) 100%);
            }
            .landing-content {
                position: relative;
                left: auto;
                top: auto;
                transform: none;
                text-align: center;
                margin-bottom: 40px;
            }
            .landing-content h1 {
                font-size: 3rem;
            }
        }
    </style>
</head>
<body>

    <!-- Background Slider -->
    <div class="slider-bg bg-1" style="background-image: url('<%= request.getContextPath() %>/assets/img/bg1.png');"></div>
    <div class="slider-bg bg-2" style="background-image: url('<%= request.getContextPath() %>/assets/img/bg2.png');"></div>
    <div class="slider-bg bg-3" style="background-image: url('<%= request.getContextPath() %>/assets/img/bg3.png');"></div>
    <div class="slider-bg bg-4" style="background-image: url('<%= request.getContextPath() %>/assets/img/bg4.png');"></div>
    <div class="slider-bg bg-5" style="background-image: url('<%= request.getContextPath() %>/assets/img/bg5.png');"></div>

    <!-- Giới thiệu tiệm -->
    <div class="landing-content">
        <h1>Bánh Mì<br><span>Đậm Đà</span></h1>
        <p>Thưởng thức hương vị truyền thống tinh tế nhất trong từng ổ bánh. Giòn rụm bên ngoài, đậm đà bên trong. Nơi lưu giữ tinh hoa ẩm thực đường phố Việt Nam.</p>
    </div>

    <!-- Form đăng nhập Glassmorphism -->
    <div class="login-glass-card">
        <h2>Đăng Nhập</h2>
        <p class="subtitle">Hệ thống quản lý bán hàng</p>

        <%
            String error = (String) request.getAttribute("error");
            if(error != null) {
        %>
            <div class="error"><i class="fas fa-exclamation-circle"></i> <%= error %></div>
        <% } %>

        <form action="<%= request.getContextPath() %>/login" method="post">
            <div class="input-group">
                <input type="text" id="username" name="username" placeholder="Tên đăng nhập" required>
                <i class="fas fa-user"></i>
            </div>
            
            <div class="input-group">
                <input type="password" id="password" name="password" placeholder="Mật khẩu" required>
                <i class="fas fa-lock"></i>
            </div>
            
            <button type="submit" class="btn-login">
                Vào Bán Hàng <i class="fas fa-arrow-right"></i>
            </button>
        </form>
    </div>

</body>
</html>
