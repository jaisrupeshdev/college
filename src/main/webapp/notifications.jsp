<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.placement.model.Notification" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"student".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Notification> notifications = (List<Notification>) request.getAttribute("notificationsList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Notifications - Placement Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css"><script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script>
    <style>
        .notif-item {
            background: white;
            border-radius: 14px;
            padding: 20px 25px;
            margin-bottom: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.04);
            display: flex;
            gap: 18px;
            align-items: start;
            transition: all 0.3s;
            border-left: 4px solid #667eea;
        }
        .notif-item.unread {
            background: linear-gradient(90deg, #f0f3ff 0%, white 100%);
            border-left-color: #667eea;
        }
        .notif-item.read {
            border-left-color: #d1d5e0;
            opacity: 0.85;
        }
        .notif-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        }
        .notif-icon {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: white;
            background: linear-gradient(135deg, #667eea, #764ba2);
            flex-shrink: 0;
        }
        .notif-icon.read-icon {
            background: #e1e5ee;
            color: #8892b0;
        }
        .notif-msg {
            font-size: 14px;
            color: #1a1a2e;
            font-weight: 500;
            line-height: 1.5;
        }
        .notif-time {
            font-size: 12px;
            color: #8892b0;
            margin-top: 6px;
        }
        .new-badge {
            background: #667eea;
            color: white;
            font-size: 10px;
            padding: 3px 8px;
            border-radius: 10px;
            font-weight: 700;
            letter-spacing: 0.5px;
            margin-left: 8px;
        }
    </style>
<script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script><script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script></head>
<body>

<div class="sidebar">
    <div class="brand">
        <h2><i class="fas fa-graduation-cap"></i> Placement</h2>
        <p>Management System</p>
    </div>
    <div class="nav-section">Main Menu</div>
    <a href="DashboardServlet" class="nav-item"><i class="fas fa-th-large"></i> Dashboard</a>
    <a href="JobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> Browse Jobs</a>
    <a href="MyApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> My Applications</a><a href="MyInterviewsServlet" class="nav-item"><i class="fas fa-calendar-check"></i> My Interviews</a>
    <a href="EventsServlet" class="nav-item"><i class="fas fa-calendar-alt"></i> Events</a>
    <a href="NotificationsServlet" class="nav-item active"><i class="fas fa-bell"></i> Notifications</a>
    <a href="ProfileServlet" class="nav-item"><i class="fas fa-user"></i> My Profile</a>
    <div class="nav-section">Account</div>
    <a href="LogoutServlet" class="nav-item"><i class="fas fa-sign-out-alt"></i> Logout</a>
    <div class="spacer"></div>
    <div class="user-info">
        <div class="name"><i class="fas fa-user-graduate"></i> <%= session.getAttribute("studentName") %></div>
        <div class="role">Student Account</div>
    </div>
</div>

<div class="main-content">
    <div class="topbar">
        <div>
            <h1>Notifications 🔔</h1>
            <p>Stay updated with your placement activities.</p>
        </div>
    </div>

    <% if (notifications == null || notifications.isEmpty()) { %>
        <div class="data-card animate-in">
            <div style="padding: 60px; text-align: center;">
                <i class="fas fa-bell-slash" style="font-size: 60px; color: #d1d5e0;"></i>
                <h3 style="color: #8892b0; font-size: 18px; margin-top: 20px;">No notifications</h3>
                <p style="color: #8892b0;">You're all caught up!</p>
            </div>
        </div>
    <% } else {
         for (Notification n : notifications) { %>
        <div class="notif-item animate-in <%= n.isRead() ? "read" : "unread" %>">
            <div class="notif-icon <%= n.isRead() ? "read-icon" : "" %>">
                <i class="fas fa-<%= n.isRead() ? "check" : "bell" %>"></i>
            </div>
            <div style="flex: 1;">
                <div class="notif-msg">
                    <%= n.getMessage() %>
                    <% if (!n.isRead()) { %>
                        <span class="new-badge">NEW</span>
                    <% } %>
                </div>
                <div class="notif-time">
                    <i class="fas fa-clock me-1"></i>
                    <%= n.getCreatedAt() != null ? n.getCreatedAt().toString().replace("T", " ").substring(0, 16) : "-" %>
                </div>
            </div>
        </div>
    <% } } %>
</div>

</body>
</html>