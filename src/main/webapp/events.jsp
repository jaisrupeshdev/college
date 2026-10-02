<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.placement.model.Event" %>
<%@ page import="com.placement.model.Company" %>
<%!
    private String getCompanyName(List<Company> companies, int id) {
        if (companies == null) return "N/A";
        for (Company c : companies) {
            if (c.getId() == id) return c.getName();
        }
        return "N/A";
    }
%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null) { response.sendRedirect("login.jsp"); return; }
    List<Event> events = (List<Event>) request.getAttribute("eventsList");
    List<Company> companies = (List<Company>) request.getAttribute("companiesList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Events - Placement Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css"><script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script>
    <style>
        .event-card {
            background: white;
            border-radius: 16px;
            padding: 25px 30px;
            margin-bottom: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
            transition: all 0.3s;
            border-left: 4px solid #f093fb;
            display: flex;
            justify-content: space-between;
            align-items: start;
            gap: 20px;
            flex-wrap: wrap;
        }
        .event-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
        }
        .event-date-box {
            min-width: 80px;
            text-align: center;
            background: linear-gradient(135deg, #f093fb, #f5576c);
            color: white;
            border-radius: 12px;
            padding: 12px 10px;
        }
        .event-date-box .day { font-size: 26px; font-weight: 800; line-height: 1; }
        .event-date-box .month { font-size: 12px; text-transform: uppercase; letter-spacing: 1px; opacity: 0.9; }
        .event-card h4 { font-size: 18px; font-weight: 700; color: #1a1a2e; margin-bottom: 10px; }
        .event-meta { font-size: 13px; color: #4a5578; margin: 5px 0; }
        .event-meta i { color: #f093fb; width: 18px; }
        .event-desc { color: #8892b0; font-size: 13px; margin-top: 10px; line-height: 1.5; }
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
    <% if ("admin".equals(role)) { %>
        <a href="StudentsServlet" class="nav-item"><i class="fas fa-users"></i> Students</a>
        <a href="CompaniesServlet" class="nav-item"><i class="fas fa-building"></i> Companies</a>
        <a href="JobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> Jobs</a>
        <a href="AdminApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> Applications</a>
        <a href="ShortlistServlet" class="nav-item"><i class="fas fa-trophy"></i> Shortlist</a><a href="AdminInterviewsServlet" class="nav-item"><i class="fas fa-calendar-check"></i> Interviews</a>
        <a href="EventsServlet" class="nav-item active"><i class="fas fa-calendar-alt"></i> Events</a>
    <% } else { %>
        <a href="JobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> Browse Jobs</a>
        <a href="MyApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> My Applications</a><a href="MyInterviewsServlet" class="nav-item"><i class="fas fa-calendar-check"></i> My Interviews</a>
        <a href="EventsServlet" class="nav-item active"><i class="fas fa-calendar-alt"></i> Events</a>
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
        if ("marked".equals(msg)) {
    %>
        <div class="alert-modern" style="background: #d4f4dd; color: #1d7a3a; border-left: 4px solid #43e97b;">
            <i class="fas fa-check-circle"></i> Attendance marked successfully!
        </div>
    <% } else if ("already".equals(msg)) { %>
        <div class="alert-modern" style="background: #fff8e1; color: #b7791f; border-left: 4px solid #f6c23e;">
            <i class="fas fa-exclamation-triangle"></i> You have already marked attendance for this event!
        </div>
    <% } %>

    <div class="topbar">
        <div>
            <h1>Placement Events 📅</h1>
            <p>Upcoming drives, workshops, and placement activities.</p>
        </div>
        <% if ("admin".equals(role)) { %>
            <a href="create-event.jsp" class="btn-primary-grad">
                <i class="fas fa-plus"></i> Create Event
            </a>
        <% } %>
    </div>

    <% if (events == null || events.isEmpty()) { %>
        <div class="data-card animate-in">
            <div style="padding: 60px; text-align: center;">
                <i class="fas fa-calendar-times" style="font-size: 60px; color: #d1d5e0;"></i>
                <h3 style="color: #8892b0; font-size: 18px; margin-top: 20px;">No events scheduled</h3>
                <p style="color: #8892b0;">Check back later for upcoming placement activities.</p>
            </div>
        </div>
    <% } else {
         for (Event e : events) {
             java.time.LocalDate d = e.getEventDate();
    %>
        <div class="event-card animate-in">
            <div style="display: flex; gap: 20px; flex: 1; align-items: start;">
                <div class="event-date-box">
                    <div class="day"><%= d != null ? d.getDayOfMonth() : "--" %></div>
                    <div class="month"><%= d != null ? d.getMonth().toString().substring(0,3) : "---" %></div>
                </div>
                <div style="flex: 1;">
                    <h4><i class="fas fa-calendar-check me-2" style="color:#f093fb;"></i> <%= e.getTitle() %></h4>
                    <div class="event-meta"><i class="fas fa-map-marker-alt"></i> <strong>Venue:</strong> <%= e.getVenue() != null ? e.getVenue() : "TBA" %></div>
                    <div class="event-meta"><i class="fas fa-building"></i> <strong>Company:</strong> <%= getCompanyName(companies, e.getCompanyId()) %></div>
                    <% if (e.getDescription() != null && !e.getDescription().isEmpty()) { %>
                        <div class="event-desc"><%= e.getDescription() %></div>
                    <% } %>
                </div>
            </div>
            <div style="display: flex; gap: 10px; align-items: flex-start; flex-wrap: wrap;">
                <% if ("student".equals(role)) { %>
                    <%
                        com.placement.dao.AttendanceDAO _attDAO = new com.placement.dao.AttendanceDAO();
                        int _sid = (Integer) session.getAttribute("studentId");
                        boolean _marked = _attDAO.hasMarked(e.getId(), _sid);
                    %>
                    <% if (_marked) { %>
                        <span class="btn-primary-grad" style="background: #d4f4dd; color: #1d7a3a; cursor: default;">
                            <i class="fas fa-check-circle"></i> Marked
                        </span>
                    <% } else { %>
                        <a href="MarkAttendanceServlet?eventId=<%= e.getId() %>"
                           class="btn-primary-grad"
                           onclick="return confirm('Mark attendance for <%= e.getTitle() %>?')">
                            <i class="fas fa-user-check"></i> Mark Attendance
                        </a>
                    <% } %>
                <% } %>
                <% if ("admin".equals(role)) { %>
                    <a href="EventAttendanceServlet?eventId=<%= e.getId() %>"
                       class="btn-primary-grad"
                       style="background: linear-gradient(135deg, #4facfe, #00f2fe);">
                        <i class="fas fa-list-check"></i> View Attendance
                    </a>
                    <a href="DeleteEventServlet?id=<%= e.getId() %>"
                       class="btn-delete"
                       onclick="return confirm('Delete event <%= e.getTitle() %>?')">
                        <i class="fas fa-trash"></i>
                    </a>
                <% } %>
            </div>
        </div>
    <% } } %>
</div>

</body>
</html>