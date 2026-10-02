<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forgot Password - Placement Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            background: rgba(255,255,255,0.05);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 24px;
            padding: 45px 40px;
            width: 100%;
            max-width: 440px;
            box-shadow: 0 25px 60px rgba(0,0,0,0.3);
        }
        .icon-box {
            width: 70px; height: 70px;
            background: linear-gradient(135deg, #667eea, #f093fb);
            border-radius: 20px;
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 32px; color: white; margin-bottom: 20px;
        }
        .form-control {
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            color: #fff; padding: 12px 16px; border-radius: 10px;
        }
        .form-control:focus {
            background: rgba(255,255,255,0.08);
            border-color: #667eea; color: #fff;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.15);
        }
        .form-control::placeholder { color: #4a5578; }
        .btn-login {
            width: 100%; padding: 13px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border: none; color: white; border-radius: 10px;
            font-weight: 600;
        }
        .btn-login:hover { color: white; transform: translateY(-2px); }
        .back-link {
            text-align: center; margin-top: 20px;
            color: #8892b0; font-size: 13px;
        }
        .back-link a { color: #667eea; text-decoration: none; }
        .error-msg {
            background: rgba(245,87,108,0.15);
            border: 1px solid rgba(245,87,108,0.3);
            color: #ff6b81; padding: 12px; border-radius: 10px;
            text-align: center; margin-bottom: 20px; font-size: 13px;
        }
    </style>
<script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script><script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script></head>
<body>

<div class="login-card">
    <div style="text-align:center;">
        <div class="icon-box"><i class="fas fa-key"></i></div>
        <h2 style="color:#fff;font-size:22px;font-weight:700;">Forgot Password?</h2>
        <p style="color:#8892b0;font-size:13px;margin-bottom:25px;">Enter your email, we'll send an OTP</p>
    </div>

    <% String error = (String) request.getAttribute("error");
       if (error != null) { %>
        <div class="error-msg"><i class="fas fa-exclamation-circle me-2"></i><%= error %></div>
    <% } %>

    <form action="ForgotPasswordServlet" method="post">
        <div class="mb-3">
            <label style="color:#a8b2d1;font-size:13px;">Email Address</label>
            <input type="email" name="email" class="form-control" placeholder="your.email@gmail.com" required>
        </div>
        <button type="submit" class="btn-login">
            <i class="fas fa-paper-plane me-2"></i> Send OTP
        </button>
    </form>

    <div class="back-link">
        <i class="fas fa-arrow-left me-1"></i> <a href="login.jsp">Back to Login</a>
    </div>
</div>

</body>
</html>