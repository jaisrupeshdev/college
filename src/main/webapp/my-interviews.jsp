<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.placement.model.Interview" %>
<%@ page import="com.placement.model.Job" %>
<%!
    private String getJobTitle(List<Job> jobs, int id) {
        for (Job j : jobs) if (j.getId() == id) return j.getTitle();
        return "Unknown";
    }
%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"student".equals(role)) { response.sendRedirect("login.jsp"); return; }
    List<Interview> interviews = (List<Interview>) request.getAttribute("interviewsList");
    List<Job> jobs = (List<Job>) request.getAttribute("jobsList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Interviews</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script>
    <style>
        .interview-card {
            background: white; border-radius: 16px; padding: 25px 30px;
            margin-bottom: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.04);
            transition: all 0.3s; border-left: 4px solid #667eea;
            display: flex; gap: 20px; align-items: start; flex-wrap: wrap;
        }
        .interview-card:hover { transform: translateY(-3px); box-shadow: 0 8px 30px rgba(0,0,0,0.08); }
        .date-box {
            min-width: 80px; text-align: center;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white; border-radius: 12px; padding: 12px 10px;
        }
        .date-box .day { font-size: 26px; font-weight: 800; line-height: 1; }
        .date-box .month { font-size: 12px; text-transform: uppercase; letter-spacing: 1px; opacity: 0.9; }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="brand"><h2><i class="fas fa-graduation-cap"></i> Placement</h2><p>Management System</p></div>
    <div class="nav-section">Main Menu</div>
    <a href="DashboardServlet" class="nav-item"><i class="fas fa-th-large"></i> Dashboard</a>
    <a href="JobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> Browse Jobs</a>
    <a href="MyApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> My Applications</a><a href="MyInterviewsServlet" class="nav-item"><i class="fas fa-calendar-check"></i> My Interviews</a>
    <a href="MyInterviewsServlet" class="nav-item active"><i class="fas fa-calendar-check"></i> My Interviews</a>
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
        <div><h1>My Interviews 📅</h1><p>All your scheduled interviews at one place.</p></div>
    </div>

    <% if (interviews == null || interviews.isEmpty()) { %>
        <div class="data-card animate-in">
            <div style="padding: 60px; text-align: center;">
                <i class="fas fa-calendar-times" style="font-size: 60px; color: #d1d5e0;"></i>
                <h3 style="color: #8892b0; font-size: 18px; margin-top: 20px;">No interviews scheduled</h3>
                <p style="color: #8892b0;">Once you get shortlisted, your interview will appear here.</p>
            </div>
        </div>
    <% } else {
         for (Interview i : interviews) {
             java.time.LocalDate d = i.getInterviewDate();
    %>
        <div class="interview-card animate-in">
            <div class="date-box">
                <div class="day"><%= d != null ? d.getDayOfMonth() : "--" %></div>
                <div class="month"><%= d != null ? d.getMonth().toString().substring(0,3) : "---" %></div>
            </div>
            <div style="flex: 1;">
                <h4 style="color:#1a1a2e;font-weight:700;margin-bottom:10px;">
                    <i class="fas fa-briefcase me-2" style="color:#667eea;"></i>
                    <%= getJobTitle(jobs, i.getJobId()) %>
                </h4>
                <div style="font-size:13px;color:#4a5578;margin:5px 0;">
                    <i class="fas fa-clock me-2" style="color:#667eea;"></i>
                    <strong><%= i.getInterviewTime() %></strong>
                </div>
                <div style="font-size:13px;color:#4a5578;margin:5px 0;">
                    <i class="fas fa-laptop me-2" style="color:#667eea;"></i>
                    <%= i.getMode() %>
                </div>
                <div style="font-size:13px;color:#4a5578;margin:5px 0;">
                    <i class="fas fa-map-marker-alt me-2" style="color:#667eea;"></i>
                    <%= i.getLocation() %>
                </div>
                <% if (i.getNotes() != null && !i.getNotes().isEmpty()) { %>
                    <div style="background:#fff8e1;padding:12px;border-radius:10px;margin-top:12px;border-left:4px solid #f6c23e;">
                        <strong style="color:#4a5578;font-size:12px;">📝 NOTES:</strong>
                        <p style="margin:5px 0 0;color:#4a5578;font-size:13px;"><%= i.getNotes() %></p>
                    </div>
                <% } %>
            </div>
            <div>
                <span class="badge badge-green"><i class="fas fa-check-circle me-1"></i><%= i.getStatus() %></span>
            </div>
        </div>
    <% } } %>
</div>

</body>
</html>