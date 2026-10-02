<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Company - Placement Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css"><script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script>
    <style>
        .form-card { background: white; border-radius: 16px; padding: 35px; box-shadow: 0 4px 20px rgba(0,0,0,0.04); max-width: 700px; }
        .form-label-modern { font-size: 13px; font-weight: 600; color: #1a1a2e; margin-bottom: 8px; display: block; }
        .form-label-modern i { color: #667eea; margin-right: 6px; }
        .form-control-modern { width: 100%; padding: 12px 16px; border: 1.5px solid #e1e5ee; border-radius: 10px; font-size: 14px; }
        .form-control-modern:focus { outline: none; border-color: #667eea; box-shadow: 0 0 0 3px rgba(102,126,234,0.1); }
        .form-row { margin-bottom: 20px; }
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
    <a href="StudentsServlet" class="nav-item"><i class="fas fa-users"></i> Students</a>
    <a href="CompaniesServlet" class="nav-item active"><i class="fas fa-building"></i> Companies</a>
    <a href="JobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> Jobs</a>
    <a href="AdminApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> Applications</a>
    <a href="ShortlistServlet" class="nav-item"><i class="fas fa-trophy"></i> Shortlist</a><a href="AdminInterviewsServlet" class="nav-item"><i class="fas fa-calendar-check"></i> Interviews</a>
    <a href="EventsServlet" class="nav-item"><i class="fas fa-calendar-alt"></i> Events</a>
    <div class="nav-section">Account</div>
    <a href="LogoutServlet" class="nav-item"><i class="fas fa-sign-out-alt"></i> Logout</a>
    <div class="spacer"></div>
    <div class="user-info">
        <div class="name"><i class="fas fa-user-shield"></i> Administrator</div>
        <div class="role">Admin Account</div>
    </div>
</div>

<div class="main-content">
    <div class="topbar">
        <div><h1>Add New Company ➕</h1><p>Register a new partner company.</p></div>
        <a href="CompaniesServlet" class="btn-primary-grad" style="background: #e1e5ee; color: #4a5578;">
            <i class="fas fa-arrow-left"></i> Back to List
        </a>
    </div>

    <div class="form-card animate-in">
        <form action="AddCompanyServlet" method="post">

            <div class="form-row">
                <label class="form-label-modern"><i class="fas fa-building"></i> Company Name</label>
                <input type="text" name="name" class="form-control-modern" placeholder="e.g., Google" required>
            </div>

            <div class="form-row">
                <label class="form-label-modern"><i class="fas fa-industry"></i> Industry</label>
                <input type="text" name="industry" class="form-control-modern" placeholder="e.g., Technology" required>
            </div>

            <div class="form-row">
                <label class="form-label-modern"><i class="fas fa-envelope"></i> Company Email (Login ID)</label>
                <input type="email" name="email" class="form-control-modern" placeholder="hr@company.com" required>
            </div>

            <div class="form-row">
                <label class="form-label-modern"><i class="fas fa-lock"></i> Password</label>
                <input type="text" name="password" class="form-control-modern" placeholder="Set company password" required>
            </div>

            <button type="submit" class="btn-primary-grad" style="width: 100%; justify-content: center; padding: 14px;">
                <i class="fas fa-save"></i> Save Company
            </button>

        </form>
    </div>
</div>
<% if ("student".equals(session.getAttribute("role"))) { %>
    <script src="js/chatbot.js"></script>
<% } %>

</body>
</html>