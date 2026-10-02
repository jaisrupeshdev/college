<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Placement Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css"><script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script>
    <style>
        body {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }
        body::before {
            content: '';
            position: absolute;
            width: 500px; height: 500px;
            background: radial-gradient(circle, rgba(102,126,234,0.3), transparent 70%);
            top: -200px; right: -200px;
            border-radius: 50%;
        }
        body::after {
            content: '';
            position: absolute;
            width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(240,147,251,0.2), transparent 70%);
            bottom: -150px; left: -150px;
            border-radius: 50%;
        }
        .login-container { position: relative; z-index: 1; width: 100%; max-width: 440px; padding: 20px; }
        .login-card {
            background: rgba(255,255,255,0.05);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 24px;
            padding: 45px 40px;
            box-shadow: 0 25px 60px rgba(0,0,0,0.3);
        }
        .login-logo { text-align: center; margin-bottom: 30px; }
        .login-logo .icon-box {
            width: 70px; height: 70px;
            background: linear-gradient(135deg, #667eea, #f093fb);
            border-radius: 20px;
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 32px; color: white; margin-bottom: 20px;
            box-shadow: 0 10px 30px rgba(102,126,234,0.4);
        }
        .login-logo h2 { color: #fff; font-size: 24px; font-weight: 700; margin-bottom: 6px; }
        .login-logo p { color: #8892b0; font-size: 13px; }
        .form-label { color: #a8b2d1; font-size: 13px; font-weight: 500; margin-bottom: 8px; }
        .form-control, .form-select {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            color: #fff; padding: 12px 16px; border-radius: 10px; font-size: 14px;
        }
        .form-control:focus, .form-select:focus {
            background: rgba(255,255,255,0.08);
            border-color: #667eea; color: #fff;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.15);
        }
        .form-control::placeholder { color: #4a5578; }
        .form-select option { background: #1a1a2e; color: #fff; }
        .btn-login {
            width: 100%; padding: 13px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none; color: white; border-radius: 10px;
            font-weight: 600; font-size: 15px; margin-top: 10px;
            box-shadow: 0 10px 25px rgba(102,126,234,0.3);
        }
        .btn-login:hover { transform: translateY(-2px); color: white; }
        .error-msg {
            background: rgba(245,87,108,0.15);
            border: 1px solid rgba(245,87,108,0.3);
            color: #ff6b81; padding: 12px 16px; border-radius: 10px;
            text-align: center; margin-bottom: 20px; font-size: 13px;
        }
        .footer-text { text-align: center; color: #4a5578; font-size: 12px; margin-top: 25px; }
    </style>
<script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script><script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script></head>
<body>

<div class="login-container">
    <div class="login-card animate-in">
        <div class="login-logo">
            <div class="icon-box"><i class="fas fa-graduation-cap"></i></div>
            <h2>Placement Portal</h2>
            <p>Your gateway to campus placements</p>
        </div>

        <% String error = (String) request.getAttribute("error");
           if (error != null) { %>
            <div class="error-msg"><i class="fas fa-exclamation-circle me-2"></i><%= error %></div>
        <% } %>

        <form action="LoginServlet" method="post">
            <div class="mb-3">
                <label class="form-label"><i class="fas fa-user-tag me-1"></i> Login As</label>
                <select name="role" class="form-select" required>
                    <option value="student">🎓 Student</option>
                    <option value="admin">👨‍💼 Admin</option>
                    <option value="company">🏢 Company</option>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label"><i class="fas fa-envelope me-1"></i> Email / Username</label>
                <input type="text" name="username" class="form-control" placeholder="Enter your email or username" required>
            </div>
            <div class="mb-3">
                <label class="form-label"><i class="fas fa-lock me-1"></i> Password</label>
                <input type="password" name="password" class="form-control" placeholder="Enter your password" required>
            </div>
            <button type="submit" class="btn-login">
                <i class="fas fa-sign-in-alt me-2"></i> Sign In
            </button>
        </form>
		<div style="text-align: center; margin-top: 15px;">
    <a href="forgot-password.jsp" style="color: #8892b0; font-size: 13px; text-decoration: none;">
        <i class="fas fa-key me-1"></i> Forgot Password?
    </a>
</div>
        <div class="footer-text">© 2026 Placement Portal • All rights reserved</div>
    </div>
</div>

</body>
</html>