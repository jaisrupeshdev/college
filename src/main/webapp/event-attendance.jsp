<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.placement.model.Event" %>
<%@ page import="com.placement.model.Attendance" %>
<%@ page import="com.placement.model.Student" %>
<%!
    private String getStudentName(List<Student> students, int id) {
        if (students == null) return "Unknown";
        for (Student s : students) {
            if (s.getId() == id) return s.getName();
        }
        return "Unknown";
    }
    private String getStudentRoll(List<Student> students, int id) {
        if (students == null) return "-";
        for (Student s : students) {
            if (s.getId() == id) return s.getRollNo();
        }
        return "-";
    }
%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
    Event event = (Event) request.getAttribute("event");
    List<Attendance> attendanceList = (List<Attendance>) request.getAttribute("attendanceList");
    List<Student> allStudents = (List<Student>) request.getAttribute("allStudents");

    int totalStudents = allStudents != null ? allStudents.size() : 0;
    int presentCount = attendanceList != null ? attendanceList.size() : 0;
    int percent = totalStudents > 0 ? (presentCount * 100 / totalStudents) : 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Event Attendance - Placement Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css"><script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script>
    <style>
        .event-header-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 16px;
            padding: 30px;
            margin-bottom: 25px;
        }
        .event-header-card h2 { color: white; margin-bottom: 10px; }
        .event-header-card p { color: rgba(255,255,255,0.9); margin: 5px 0; }
        .stat-mini {
            display: inline-block;
            background: rgba(255,255,255,0.2);
            padding: 10px 20px;
            border-radius: 12px;
            margin-right: 12px;
            margin-top: 12px;
        }
        .stat-mini .num { font-size: 22px; font-weight: 700; }
        .stat-mini .lbl { font-size: 12px; opacity: 0.9; }
        .progress-modern {
            height: 10px;
            background: #e1e5ee;
            border-radius: 10px;
            overflow: hidden;
            margin-top: 15px;
        }
        .progress-modern .bar {
            height: 100%;
            background: linear-gradient(90deg, #43e97b, #38f9d7);
            border-radius: 10px;
            transition: width 0.5s;
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
    <a href="StudentsServlet" class="nav-item"><i class="fas fa-users"></i> Students</a>
    <a href="CompaniesServlet" class="nav-item"><i class="fas fa-building"></i> Companies</a>
    <a href="JobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> Jobs</a>
    <a href="AdminApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> Applications</a>
    <a href="ShortlistServlet" class="nav-item"><i class="fas fa-trophy"></i> Shortlist</a><a href="AdminInterviewsServlet" class="nav-item"><i class="fas fa-calendar-check"></i> Interviews</a>
    <a href="EventsServlet" class="nav-item active"><i class="fas fa-calendar-alt"></i> Events</a>
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
            <h1>Event Attendance 📋</h1>
            <p>Track which students attended this event.</p>
        </div>
        <a href="EventsServlet" class="btn-primary-grad" style="background: #e1e5ee; color: #4a5578;">
            <i class="fas fa-arrow-left"></i> Back to Events
        </a>
    </div>

    <% if (event != null) { %>
    <div class="event-header-card animate-in">
        <h2><i class="fas fa-calendar-check me-2"></i> <%= event.getTitle() %></h2>
        <p><i class="fas fa-map-marker-alt me-1"></i> <%= event.getVenue() != null ? event.getVenue() : "TBA" %></p>
        <p><i class="fas fa-calendar me-1"></i> <%= event.getEventDate() != null ? event.getEventDate() : "-" %></p>

        <div style="margin-top: 20px;">
            <div class="stat-mini">
                <div class="num"><%= totalStudents %></div>
                <div class="lbl">Total Students</div>
            </div>
            <div class="stat-mini">
                <div class="num"><%= presentCount %></div>
                <div class="lbl">Present</div>
            </div>
            <div class="stat-mini">
                <div class="num"><%= percent %>%</div>
                <div class="lbl">Attendance Rate</div>
            </div>
        </div>

        <div class="progress-modern">
            <div class="bar" style="width: <%= percent %>%;"></div>
        </div>
    </div>
    <% } %>

    <div class="data-card animate-in">
        <div class="data-card-header">
            <h3>
                <i class="fas fa-users"></i> Attended Students 
                (<%= attendanceList != null ? attendanceList.size() : 0 %>)
            </h3>
        </div>

        <% if (attendanceList == null || attendanceList.isEmpty()) { %>
            <div style="padding: 60px; text-align: center;">
                <i class="fas fa-user-slash" style="font-size: 60px; color: #d1d5e0;"></i>
                <h3 style="color: #8892b0; font-size: 18px; margin-top: 20px;">No attendance recorded yet</h3>
                <p style="color: #8892b0;">Students need to mark attendance from their Events page.</p>
            </div>
        <% } else { %>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Student</th>
                        <th>Roll No</th>
                        <th>Status</th>
                        <th>Marked At</th>
                    </tr>
                </thead>
                <tbody>
                    <% int i = 1;
                       for (Attendance a : attendanceList) { %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><strong style="color:#1a1a2e;"><%= getStudentName(allStudents, a.getStudentId()) %></strong></td>
                        <td><%= getStudentRoll(allStudents, a.getStudentId()) %></td>
                        <td><span class="badge badge-green"><i class="fas fa-check-circle me-1"></i><%= a.getStatus() %></span></td>
                        <td><%= a.getMarkedAt() != null ? a.getMarkedAt().toString().replace("T", " ").substring(0, 16) : "-" %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>

</body>
</html>