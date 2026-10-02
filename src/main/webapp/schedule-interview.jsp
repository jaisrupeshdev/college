<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.placement.dao.ApplicationDAO" %>
<%@ page import="com.placement.dao.StudentDAO" %>
<%@ page import="com.placement.dao.JobDAO" %>
<%@ page import="com.placement.model.Application" %>
<%@ page import="com.placement.model.Student" %>
<%@ page import="com.placement.model.Job" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Application> apps = new ApplicationDAO().getAllApplications();
    List<Student> students = new StudentDAO().getAllStudents();
    List<Job> jobs = new JobDAO().getAllJobs();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Schedule Interview - Placement Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script>
    <style>
        .form-card { background: white; border-radius: 16px; padding: 35px; box-shadow: 0 4px 20px rgba(0,0,0,0.04); max-width: 800px; }
        .form-label-modern { font-size: 13px; font-weight: 600; color: #1a1a2e; margin-bottom: 8px; display: block; }
        .form-label-modern i { color: #667eea; margin-right: 6px; }
        .form-control-modern { width: 100%; padding: 12px 16px; border: 1.5px solid #e1e5ee; border-radius: 10px; font-size: 14px; color: #1a1a2e; }
        .form-control-modern:focus { outline: none; border-color: #667eea; box-shadow: 0 0 0 3px rgba(102,126,234,0.1); }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px; }
        @media (max-width: 600px) { .form-row { grid-template-columns: 1fr; } }
    </style>
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
        <div><h1>Schedule Interview 📅</h1><p>Create an interview slot for a student.</p></div>
        <a href="AdminInterviewsServlet" class="btn-primary-grad" style="background: #e1e5ee; color: #4a5578;">
            <i class="fas fa-arrow-left"></i> All Interviews
        </a>
    </div>

    <div class="form-card animate-in">
        <form action="ScheduleInterviewServlet" method="post">

            <div style="margin-bottom: 20px;">
                <label class="form-label-modern"><i class="fas fa-user-check"></i> Select Applicant (Student + Job)</label>
                <select name="applicationId" class="form-control-modern" required>
                    <option value="">-- Select an application --</option>
                    <% for (Application a : apps) {
                        String sName = "Unknown", jTitle = "Unknown";
                        for (Student s : students) if (s.getId() == a.getStudentId()) { sName = s.getName(); break; }
                        for (Job j : jobs) if (j.getId() == a.getJobId()) { jTitle = j.getTitle(); break; }
                    %>
                        <option value="<%= a.getId() %>">
                            <%= sName %> → <%= jTitle %> (Status: <%= a.getStatus() %>)
                        </option>
                    <% } %>
                </select>
            </div>

            <div class="form-row">
                <div>
                    <label class="form-label-modern"><i class="fas fa-calendar"></i> Interview Date</label>
                    <input type="date" name="interviewDate" class="form-control-modern" required>
                </div>
                <div>
                    <label class="form-label-modern"><i class="fas fa-clock"></i> Time</label>
                    <input type="text" name="interviewTime" class="form-control-modern" placeholder="e.g., 10:00 AM" required>
                </div>
            </div>

            <div class="form-row">
                <div>
                    <label class="form-label-modern"><i class="fas fa-laptop"></i> Mode</label>
                    <select name="mode" class="form-control-modern" required>
                        <option value="">-- Select Mode --</option>
                        <option value="Online - Zoom">Online - Zoom</option>
                        <option value="Online - Google Meet">Online - Google Meet</option>
                        <option value="Online - Teams">Online - Microsoft Teams</option>
                        <option value="In-Person">In-Person</option>
                        <option value="Telephonic">Telephonic</option>
                    </select>
                </div>
                <div>
                    <label class="form-label-modern"><i class="fas fa-map-marker-alt"></i> Location / Link</label>
                    <input type="text" name="location" class="form-control-modern" placeholder="e.g., Room 201 OR Zoom link" required>
                </div>
            </div>

            <div style="margin-bottom: 25px;">
                <label class="form-label-modern"><i class="fas fa-align-left"></i> Notes (Optional)</label>
                <textarea name="notes" class="form-control-modern" rows="3" placeholder="e.g., Bring resume, ID card, and 2 passport photos"></textarea>
            </div>

            <button type="submit" class="btn-primary-grad" style="width: 100%; justify-content: center; padding: 14px;">
                <i class="fas fa-calendar-plus"></i> Schedule Interview
            </button>

        </form>
    </div>
</div>

</body>
</html>