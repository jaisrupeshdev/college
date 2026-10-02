<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.placement.model.Application" %>
<%@ page import="com.placement.model.Job" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"student".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Application> applications = (List<Application>) request.getAttribute("applicationsList");
    List<Job> appliedJobs = (List<Job>) request.getAttribute("appliedJobsList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Applications - Placement Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css"><script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script>
    <style>
        .app-card {
            background: white; border-radius: 16px; padding: 25px 30px;
            margin-bottom: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.04);
            transition: all 0.3s; border-left: 4px solid #667eea;
            display: flex; justify-content: space-between;
            align-items: center; flex-wrap: wrap; gap: 15px;
        }
        .app-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
        }
        .app-card h4 { font-size: 18px; font-weight: 700; color: #1a1a2e; margin-bottom: 8px; }
        .app-meta { font-size: 13px; color: #8892b0; margin-top: 5px; }
        .status-badge {
            padding: 8px 18px; border-radius: 20px;
            font-size: 13px; font-weight: 700; display: inline-flex;
            align-items: center; gap: 6px;
        }
        .status-PENDING   { background: #fff8e1; color: #b7791f; }
        .status-SHORTLISTED { background: #d4f4dd; color: #1d7a3a; }
        .status-REJECTED  { background: #fde2e4; color: #b23a48; }
        .status-SELECTED  { background: #d4ecff; color: #1a5fa8; }
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
    <a href="MyApplicationsServlet" class="nav-item active"><i class="fas fa-file-alt"></i> My Applications</a>
    <a href="EventsServlet" class="nav-item"><i class="fas fa-calendar-alt"></i> Events</a>
    <a href="NotificationsServlet" class="nav-item"><i class="fas fa-bell"></i> Notifications</a>
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
            <h1>My Applications 📄</h1>
            <p>Track the status of all your job applications.</p>
        </div>
    </div>

    <% if (applications == null || applications.isEmpty()) { %>
        <div class="data-card animate-in">
            <div style="padding: 60px; text-align: center;">
                <i class="fas fa-inbox" style="font-size: 60px; color: #d1d5e0; margin-bottom: 20px;"></i>
                <h3 style="color: #8892b0; font-size: 18px;">No applications yet</h3>
                <p style="color: #8892b0; margin-top: 10px;">Browse jobs and apply to get started!</p>
                <a href="JobsServlet" class="btn-primary-grad" style="margin-top: 20px;">
                    <i class="fas fa-briefcase"></i> Browse Jobs
                </a>
            </div>
        </div>
    <% } else { 
         for (int i = 0; i < applications.size(); i++) { 
             Application a = applications.get(i);
             Job j = (i < appliedJobs.size()) ? appliedJobs.get(i) : null;
    %>
        <div class="app-card animate-in">
            <div style="flex: 1;">
                <h4><i class="fas fa-briefcase me-2" style="color:#667eea;"></i> 
                    <%= j != null ? j.getTitle() : "Job ID: " + a.getJobId() %>
                </h4>
                <% if (j != null) { %>
                    <div class="app-meta">
                        <i class="fas fa-building me-1"></i> Company ID: <%= j.getCompanyId() %>
                        &nbsp; • &nbsp;
                        <i class="fas fa-star me-1"></i> Min CGPA: <%= j.getMinCgpa() %>
                    </div>
                <% } %>
                <div class="app-meta" style="margin-top: 10px;">
                    <i class="fas fa-calendar me-1"></i> Applied: <%= a.getAppliedDate() %>
                </div>
            </div>
            <div>
                <span class="status-badge status-<%= a.getStatus() %>">
                    <% if ("PENDING".equals(a.getStatus())) { %>
                        <i class="fas fa-clock"></i> Pending
                    <% } else if ("SHORTLISTED".equals(a.getStatus())) { %>
                        <i class="fas fa-check-circle"></i> Shortlisted
                    <% } else if ("REJECTED".equals(a.getStatus())) { %>
                        <i class="fas fa-times-circle"></i> Rejected
                    <% } else if ("SELECTED".equals(a.getStatus())) { %>
                        <i class="fas fa-trophy"></i> Selected
                    <% } %>
                </span>
            </div>
        </div>
    <% } } %>
</div>

</body>
</html>