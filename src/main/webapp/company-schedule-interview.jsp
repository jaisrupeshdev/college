<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.placement.dao.ApplicationDAO" %>
<%@ page import="com.placement.dao.JobDAO" %>
<%@ page import="com.placement.dao.StudentDAO" %>
<%@ page import="com.placement.model.Application" %>
<%@ page import="com.placement.model.Job" %>
<%@ page import="com.placement.model.Student" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"company".equals(role)) { response.sendRedirect("login.jsp"); return; }
    int companyId = (Integer) session.getAttribute("companyId");

    // Company jobs
    List<Job> myJobs = new ArrayList<>();
    for (Job j : new JobDAO().getAllJobs()) {
        if (j.getCompanyId() == companyId) myJobs.add(j);
    }
    List<Integer> jobIds = new ArrayList<>();
    for (Job j : myJobs) jobIds.add(j.getId());

    // Company applications (shortlisted only)
    List<Application> shortlistedApps = new ArrayList<>();
    for (Application a : new ApplicationDAO().getAllApplications()) {
        if (jobIds.contains(a.getJobId()) && "SHORTLISTED".equals(a.getStatus())) {
            shortlistedApps.add(a);
        }
    }
    List<Student> students = new StudentDAO().getAllStudents();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Schedule Interview - Company</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="js/theme.js"></script>
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
    <div class="brand"><h2><i class="fas fa-graduation-cap"></i> Placement</h2><p>Company Panel</p></div>
    <div class="nav-section">Main Menu</div>
    <a href="CompanyDashboardServlet" class="nav-item"><i class="fas fa-th-large"></i> Dashboard</a>
    <a href="CompanyJobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> My Jobs</a>
    <a href="CompanyApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> Applications</a>
    <a href="CompanyInterviewsServlet" class="nav-item active"><i class="fas fa-calendar-check"></i> Interviews</a>
    <a href="CompanyJobPostServlet" class="nav-item"><i class="fas fa-plus-circle"></i> Post Job</a>
    <a href="CompanyProfileServlet" class="nav-item"><i class="fas fa-user"></i> Profile</a>
    <div class="nav-section">Account</div>
    <a href="LogoutServlet" class="nav-item"><i class="fas fa-sign-out-alt"></i> Logout</a>
    <div class="spacer"></div>
    <div class="user-info">
        <div class="name"><i class="fas fa-building"></i> <%= session.getAttribute("companyName") %></div>
        <div class="role">Company Account</div>
    </div>
</div>

<div class="main-content">
    <div class="topbar">
        <div><h1>Schedule Interview 📅</h1><p>Create an interview slot for a shortlisted student.</p></div>
        <a href="CompanyInterviewsServlet" class="btn-primary-grad" style="background:#e1e5ee;color:#4a5578;">
            <i class="fas fa-arrow-left"></i> All Interviews
        </a>
    </div>

    <div class="form-card animate-in">
        <% if (shortlistedApps.isEmpty()) { %>
            <div style="padding: 40px; text-align: center;">
                <i class="fas fa-info-circle" style="font-size: 50px; color: #d1d5e0;"></i>
                <h3 style="color: #8892b0; font-size: 18px; margin-top: 15px;">No shortlisted applications</h3>
                <p style="color: #8892b0;">Pehle applications shortlist karo, phir interview schedule kar sakte ho.</p>
                <a href="CompanyApplicationsServlet" class="btn-primary-grad" style="margin-top: 15px;">
                    <i class="fas fa-file-alt"></i> View Applications
                </a>
            </div>
        <% } else { %>
        <form action="CompanyScheduleInterviewServlet" method="post">
            <div style="margin-bottom: 20px;">
                <label class="form-label-modern"><i class="fas fa-user-check"></i> Select Shortlisted Applicant</label>
                <select name="applicationId" class="form-control-modern" required>
                    <option value="">-- Select an applicant --</option>
                    <% for (Application a : shortlistedApps) {
                        String sName = "Unknown", jTitle = "Unknown";
                        for (Student s : students) if (s.getId() == a.getStudentId()) { sName = s.getName(); break; }
                        for (Job j : myJobs) if (j.getId() == a.getJobId()) { jTitle = j.getTitle(); break; }
                    %>
                        <option value="<%= a.getId() %>"><%= sName %> → <%= jTitle %></option>
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
                    <input type="text" name="location" class="form-control-modern" placeholder="Room 201 OR Zoom link" required>
                </div>
            </div>

            <div style="margin-bottom: 25px;">
                <label class="form-label-modern"><i class="fas fa-align-left"></i> Notes (Optional)</label>
                <textarea name="notes" class="form-control-modern" rows="3" placeholder="e.g., Bring resume and ID card"></textarea>
            </div>

            <button type="submit" class="btn-primary-grad" style="width: 100%; justify-content: center; padding: 14px;">
                <i class="fas fa-calendar-plus"></i> Schedule Interview
            </button>
        </form>
        <% } %>
    </div>
</div>

</body>
</html>