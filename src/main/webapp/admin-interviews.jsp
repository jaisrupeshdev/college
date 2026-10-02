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
    <title>Interviews - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script>
</head>
<body>

<div class="sidebar">
    <div class="brand"><h2><i class="fas fa-graduation-cap"></i> Placement</h2><p>Management System</p></div>
    <div class="nav-section">Main Menu</div>
    <a href="DashboardServlet" class="nav-item"><i class="fas fa-th-large"></i> Dashboard</a>
    <a href="StudentsServlet" class="nav-item"><i class="fas fa-users"></i> Students</a>
    <a href="CompaniesServlet" class="nav-item"><i class="fas fa-building"></i> Companies</a>
    <a href="JobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> Jobs</a>
    <a href="AdminApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> Applications</a>
    <a href="AdminInterviewsServlet" class="nav-item active"><i class="fas fa-calendar-check"></i> Interviews</a>
    <a href="ShortlistServlet" class="nav-item"><i class="fas fa-trophy"></i> Shortlist</a><a href="AdminInterviewsServlet" class="nav-item"><i class="fas fa-calendar-check"></i> Interviews</a>
    <a href="CompanyStatsServlet" class="nav-item"><i class="fas fa-chart-bar"></i> Company Stats</a>
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
        <div><h1>Interview Schedule 📅</h1><p>Manage all scheduled interviews.</p></div>
        <a href="ScheduleInterviewServlet" class="btn-primary-grad">
            <i class="fas fa-plus"></i> Schedule Interview
        </a>
    </div>

    <% if (interviews == null || interviews.isEmpty()) { %>
        <div class="data-card animate-in">
            <div style="padding: 60px; text-align: center;">
                <i class="fas fa-calendar-times" style="font-size: 60px; color: #d1d5e0;"></i>
                <h3 style="color: #8892b0; font-size: 18px; margin-top: 20px;">No interviews scheduled</h3>
                <a href="ScheduleInterviewServlet" class="btn-primary-grad" style="margin-top: 20px;">
                    <i class="fas fa-plus"></i> Schedule First Interview
                </a>
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
                        <th>Action</th>
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
                        <td>
                            <a href="DeleteInterviewServlet?id=<%= i.getId() %>" 
                               class="btn-delete"
                               onclick="return confirm('Delete this interview?')">
                                <i class="fas fa-trash"></i>
                            </a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } %>
</div>

</body>
</html>