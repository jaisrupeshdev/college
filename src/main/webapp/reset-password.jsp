<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String email = (String) session.getAttribute("resetEmail");
    if (email == null) {
        response.sendRedirect("forgot-password.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reset Password - Placement Portal</title>
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
            background: linear-gradient(135deg, #43e97b, #38f9d7);
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
            border-color: #43e97b; color: #fff;
            box-shadow: 0 0 0 3px rgba(67,233,123,0.15);
        }
        .form-control::placeholder { color: #4a5578; }
        .otp-input {
            text-align: center; font-size: 24px; letter-spacing: 8px;
            font-weight: 700; color: #43e97b !important;
        }
        .btn-login {
            width: 100%; padding: 13px;
            background: linear-gradient(135deg, #43e97b, #38f9d7);
            border: none; color: white; border-radius: 10px;
            font-weight: 600;
        }
        .btn-login:hover { color: white; transform: translateY(-2px); }
        .error-msg {
            background: rgba(245,87,108,0.15);
            border: 1px solid rgba(245,87,108,0.3);
            color: #ff6b81; padding: 12px; border-radius: 10px;
            text-align: center; margin-bottom: 20px; font-size: 13px;
        }
        .info-msg {
            background: rgba(102,126,234,0.15);
            border: 1px solid rgba(102,126,234,0.3);
            color: #a8b2d1; padding: 12px; border-radius: 10px;
            text-align: center; margin-bottom: 20px; font-size: 13px;
        }
    </style>
<script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script><script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script></head>
<body>

<div class="login-card">
    <div style="text-align:center;">
        <div class="icon-box"><i class="fas fa-lock-open"></i></div>
        <h2 style="color:#fff;font-size:22px;font-weight:700;">Reset Password</h2>
        <p style="color:#8892b0;font-size:13px;margin-bottom:25px;">Enter OTP and new password</p>
    </div>

    <div class="info-msg">
        <i class="fas fa-envelope me-1"></i> OTP bheja gaya: <strong><%= email %></strong>
    </div>

    <% String error = (String) request.getAttribute("error");
       if (error != null) { %>
        <div class="error-msg"><i class="fas fa-exclamation-circle me-2"></i><%= error %></div>
    <% } %>

    <form action="ResetPasswordServlet" method="post">
        <div class="mb-3">
            <label style="color:#a8b2d1;font-size:13px;">Enter OTP (6 digits)</label>
            <input type="text" name="otp" class="form-control otp-input" 
                   placeholder="------" maxlength="6" pattern="[0-9]{6}" required>
        </div>
        <div class="mb-3">
            <label style="color:#a8b2d1;font-size:13px;">New Password</label>
            <input type="password" name="newPassword" class="form-control" 
                   placeholder="Enter new password" minlength="6" required>
        </div>
        <div class="mb-3">
            <label style="color:#a8b2d1;font-size:13px;">Confirm Password</label>
            <input type="password" name="confirmPassword" class="form-control" 
                   placeholder="Confirm new password" minlength="6" required>
        </div>
        <button type="submit" class="btn-login">
            <i class="fas fa-check-circle me-2"></i> Reset Password
        </button>
    </form>
</div>

</body>
</html>