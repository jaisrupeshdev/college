<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.placement.model.Interview" %>
<%@ page import="com.placement.model.Student" %>
<%@ page import="com.placement.model.Job" %>
<%!
    private String getStudentName(List<Student> s, int id) {
        for (Student x : s) if (x.getId() == id) return x.getName();
        return "Unknown";
    }
    private String getJobTitle(List<Job> j, int id) {
        for (Job x : j) if (x.getId() == id) return x.getTitle();
        return "Unknown";
    }
%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) { response.sendRedirect("login.jsp"); return; }
    List<Interview> interviews = (List<Interview>) request.getAttribute("interviewsList");
    List<Student> students = (List<Student>) request.getAttribute("studentsList");
    List<Job> jobs = (List<Job>) request.getAttribute("jobsList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Interviews Monitor - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="js/theme.js"></script>
    <style>
        .readonly-badge {
            background: #e7e9ff; color: #4c51bf; padding: 6px 14px;
            border-radius: 20px; font-size: 12px; font-weight: 700;
            display: inline-flex; align-items: center; gap: 6px;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="brand">
        <h2><i class="fas fa-graduation-cap"></i> Placement</h2>
        <p>Management System</p>
    </div>
    <div class="nav-section">Main Menu</div>
    <a href="DashboardServlet" class="nav-item"><i class="fas fa-th-large"></i> Dashboard</a>
    <a href="StudentsServlet" class="nav-item"><i class="fas fa-users"></i> Students</a>
    <a href="CompaniesServlet" class="nav-item"><i class="fas fa-building"></i> Companies</a>
    <a href="JobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> Jobs</a>
    <a href="AdminApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> Applications</a>
    <a href="AdminInterviewsServlet" class="nav-item active"><i class="fas fa-calendar-check"></i> Interviews</a>
    <a href="ShortlistServlet" class="nav-item"><i class="fas fa-trophy"></i> Shortlist</a>
    <a href="CompanyStatsServlet" class="nav-item"><i class="fas fa-chart-bar"></i> Company Stats</a>
    <a href="AdminReportsServlet" class="nav-item"><i class="fas fa-chart-line"></i> Reports</a>
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
        <div>
            <h1>Interviews Monitor 📅</h1>
            <p>Scheduled interviews across all companies. <strong>(Read-only)</strong></p>
        </div>
        <span class="readonly-badge">
            <i class="fas fa-eye"></i> Read-Only Mode
        </span>
    </div>

    <div style="background:#e7e9ff;border-radius:12px;padding:15px 20px;margin-bottom:20px;display:flex;gap:12px;align-items:start;">
        <i class="fas fa-info-circle" style="color:#4c51bf;font-size:18px;margin-top:2px;"></i>
        <div>
            <strong style="color:#4c51bf;font-size:14px;">Read-Only Monitoring</strong>
            <p style="margin:5px 0 0;color:#4a5578;font-size:13px;">
                Companies schedule interviews for their shortlisted students. As admin, you can monitor all scheduled interviews here.
            </p>
        </div>
    </div>

    <% if (interviews == null || interviews.isEmpty()) { %>
        <div class="data-card animate-in">
            <div style="padding: 60px; text-align: center;">
                <i class="fas fa-calendar-times" style="font-size: 60px; color: #d1d5e0;"></i>
                <h3 style="color: #8892b0; font-size: 18px; margin-top: 20px;">No interviews scheduled yet</h3>
                <p style="color: #8892b0;">Companies will schedule interviews for shortlisted students.</p>
            </div>
        </div>
    <% } else { %>
        <div class="data-card animate-in">
            <div class="data-card-header">
                <h3><i class="fas fa-calendar-check"></i> All Interviews (<%= interviews.size() %>)</h3>
            </div>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Student</th>
                        <th>Job</th>
                        <th>Mode</th>
                        <th>Location</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Interview i : interviews) { %>
                    <tr>
                        <td><strong><%= i.getInterviewDate() %></strong></td>
                        <td><%= i.getInterviewTime() %></td>
                        <td><%= getStudentName(students, i.getStudentId()) %></td>
                        <td><%= getJobTitle(jobs, i.getJobId()) %></td>
                        <td><span class="badge badge-purple"><%= i.getMode() %></span></td>
                        <td><%= i.getLocation() %></td>
                        <td><span class="badge badge-green"><%= i.getStatus() %></span></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
</div>

</body>
</html>