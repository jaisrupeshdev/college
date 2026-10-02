<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.placement.model.Job" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null) { response.sendRedirect("login.jsp"); return; }
    List<Job> jobs = (List<Job>) request.getAttribute("jobsList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Jobs - Placement Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css"><script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script>
<script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script><script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script></head>
<body>

<div class="sidebar">
    <div class="brand">
        <h2><i class="fas fa-graduation-cap"></i> Placement</h2>
        <p>Management System</p>
    </div>
    <div class="nav-section">Main Menu</div>
    <a href="DashboardServlet" class="nav-item"><i class="fas fa-th-large"></i> Dashboard</a>
    <% if ("admin".equals(role)) { %>
        <a href="StudentsServlet" class="nav-item"><i class="fas fa-users"></i> Students</a>
        <a href="CompaniesServlet" class="nav-item"><i class="fas fa-building"></i> Companies</a>
        <a href="JobsServlet" class="nav-item active"><i class="fas fa-briefcase"></i> Jobs</a>
        <a href="AdminApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> Applications</a>
        <a href="ShortlistServlet" class="nav-item"><i class="fas fa-trophy"></i> Shortlist</a><a href="AdminInterviewsServlet" class="nav-item"><i class="fas fa-calendar-check"></i> Interviews</a>
        <a href="EventsServlet" class="nav-item"><i class="fas fa-calendar-alt"></i> Events</a>
    <% } else { %>
        <a href="JobsServlet" class="nav-item active"><i class="fas fa-briefcase"></i> Browse Jobs</a>
        <a href="MyApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> My Applications</a><a href="MyInterviewsServlet" class="nav-item"><i class="fas fa-calendar-check"></i> My Interviews</a>
        <a href="EventsServlet" class="nav-item"><i class="fas fa-calendar-alt"></i> Events</a>
        <a href="NotificationsServlet" class="nav-item"><i class="fas fa-bell"></i> Notifications</a>
        <a href="ProfileServlet" class="nav-item"><i class="fas fa-user"></i> My Profile</a>
    <% } %>
    <div class="nav-section">Account</div>
    <a href="LogoutServlet" class="nav-item"><i class="fas fa-sign-out-alt"></i> Logout</a>
    <div class="spacer"></div>
    <div class="user-info">
        <div class="name">
            <% if ("admin".equals(role)) { %>
                <i class="fas fa-user-shield"></i> Administrator
            <% } else { %>
                <i class="fas fa-user-graduate"></i> <%= session.getAttribute("studentName") %>
            <% } %>
        </div>
        <div class="role">
            <% if ("admin".equals(role)) { %>Admin Account<% } else { %>Student Account<% } %>
        </div>
    </div>
</div>

<div class="main-content">
    <%
        String msg = request.getParameter("msg");
        if ("success".equals(msg)) {
    %>
        <div class="alert-modern" style="background: #d4f4dd; color: #1d7a3a; border-left: 4px solid #43e97b;">
            <i class="fas fa-check-circle"></i> Application submitted successfully!
        </div>
    <% } else if ("already".equals(msg)) { %>
        <div class="alert-modern" style="background: #fff8e1; color: #b7791f; border-left: 4px solid #f6c23e;">
            <i class="fas fa-exclamation-triangle"></i> You have already applied for this job!
        </div>
    <% } %>

    <div class="topbar">
        <div>
            <h1>Job Openings 💼</h1>
            <p>Explore all available job opportunities.</p>
        </div>
        <% if ("admin".equals(role)) { %>
            <a href="add-job.jsp" class="btn-primary-grad">
                <i class="fas fa-plus"></i> Add Job
            </a>
        <% } %>
    </div>

    <% if (jobs == null || jobs.isEmpty()) { %>
        <div class="data-card animate-in">
            <div style="padding: 40px; text-align: center;">
                <div class="alert-modern alert-warning-modern" style="display: inline-flex;">
                    <i class="fas fa-exclamation-triangle"></i> No jobs available!
                </div>
            </div>
        </div>
    <% } else { %>
        <% for (Job j : jobs) { %>
        <div class="job-card-modern animate-in">
            <div style="display: flex; justify-content: space-between; align-items: start; flex-wrap: wrap; gap: 15px;">
                <div style="flex: 1;">
                    <h4><i class="fas fa-briefcase me-2" style="color:#667eea;"></i> <%= j.getTitle() %></h4>

                    <div class="job-meta">
                        <span><i class="fas fa-building"></i> Company ID: <strong><%= j.getCompanyId() %></strong></span>
                        <span><i class="fas fa-star"></i> Min CGPA: <strong><%= j.getMinCgpa() %></strong></span>
                    </div>

                    <div style="margin-bottom: 12px;">
                        <div style="font-size: 12px; color: #8892b0; margin-bottom: 6px; font-weight: 600;">
                            <i class="fas fa-graduation-cap me-1"></i> ELIGIBLE BRANCHES
                        </div>
                        <% for (String b : j.getEligibleBranches()) { %>
                            <span class="badge badge-blue"><%= b.trim() %></span>
                        <% } %>
                    </div>

                    <div>
                        <div style="font-size: 12px; color: #8892b0; margin-bottom: 6px; font-weight: 600;">
                            <i class="fas fa-code me-1"></i> REQUIRED SKILLS
                        </div>
                        <% for (String s : j.getRequiredSkills()) { %>
                            <span class="badge badge-purple"><%= s.trim() %></span>
                        <% } %>
                    </div>
                </div>

                <div style="display: flex; gap: 10px; align-items: flex-start;">
                    <% if ("student".equals(role)) { %>
                        <a href="ApplyServlet?jobId=<%= j.getId() %>"
                           class="btn-primary-grad"
                           onclick="return confirm('Apply for <%= j.getTitle() %>?')">
                            <i class="fas fa-paper-plane"></i> Apply Now
                        </a>
                    <% } %>
                    <% if ("admin".equals(role)) { %>
                        <a href="DeleteServlet?type=job&id=<%= j.getId() %>"
                           class="btn-delete"
                           onclick="return confirm('Delete job <%= j.getTitle() %>? This cannot be undone!')">
                            <i class="fas fa-trash"></i>
                        </a>
                    <% } %>
                </div>
            </div>
        </div>
        <% } %>
    <% } %>
</div>

</body>
</html>