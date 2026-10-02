<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.placement.model.Application" %>
<%@ page import="com.placement.model.Student" %>
<%@ page import="com.placement.model.Job" %>
<%@ page import="com.placement.model.Company" %>
<%!
    private String initials(String name) {
        if (name == null || name.isEmpty()) return "?";
        String[] parts = name.trim().split("\\s+");
        if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
        return (parts[0].charAt(0) + "" + parts[parts.length-1].charAt(0)).toUpperCase();
    }
%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) { response.sendRedirect("login.jsp"); return; }
    List<Map<String, Object>> enrichedApps = (List<Map<String, Object>>) request.getAttribute("enrichedApps");
    int totalApplications = (Integer) request.getAttribute("totalApplications");
    int pendingCount = (Integer) request.getAttribute("pendingCount");
    int shortlistedCount = (Integer) request.getAttribute("shortlistedCount");
    int selectedCount = (Integer) request.getAttribute("selectedCount");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Applications Monitor - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="js/theme.js"></script>
    <style>
        .stats-mini { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; margin-bottom: 20px; }
        .stat-mini-card { background: white; border-radius: 12px; padding: 18px; box-shadow: 0 4px 15px rgba(0,0,0,0.04); display: flex; align-items: center; gap: 15px; }
        .stat-mini-icon { width: 45px; height: 45px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 20px; color: white; }
        .stat-mini-card h4 { font-size: 22px; font-weight: 700; margin: 0; color: #1a1a2e; }
        .stat-mini-card p { font-size: 11px; color: #8892b0; margin: 0; text-transform: uppercase; letter-spacing: 1px; }
        .avatar-circle {
            width: 36px; height: 36px; border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white; display: inline-flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 13px; margin-right: 10px;
        }
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
    <a href="AdminApplicationsServlet" class="nav-item active"><i class="fas fa-file-alt"></i> Applications</a>
    <a href="AdminInterviewsServlet" class="nav-item"><i class="fas fa-calendar-check"></i> Interviews</a>
    <a href="ShortlistServlet" class="nav-item"><i class="fas fa-trophy"></i> Shortlist</a>
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
        <div>
            <h1>Applications Monitor 📊</h1>
            <p>Overview of all applications across companies. <strong>(Read-only)</strong></p>
        </div>
        <span class="readonly-badge">
            <i class="fas fa-eye"></i> Read-Only Mode
        </span>
    </div>

    <!-- STATS -->
    <div class="stats-mini animate-in">
        <div class="stat-mini-card">
            <div class="stat-mini-icon" style="background: linear-gradient(135deg, #667eea, #764ba2);"><i class="fas fa-file-alt"></i></div>
            <div><h4><%= totalApplications %></h4><p>Total</p></div>
        </div>
        <div class="stat-mini-card">
            <div class="stat-mini-icon" style="background: linear-gradient(135deg, #f6c23e, #f5576c);"><i class="fas fa-clock"></i></div>
            <div><h4><%= pendingCount %></h4><p>Pending</p></div>
        </div>
        <div class="stat-mini-card">
            <div class="stat-mini-icon" style="background: linear-gradient(135deg, #43e97b, #38f9d7);"><i class="fas fa-check-circle"></i></div>
            <div><h4><%= shortlistedCount %></h4><p>Shortlisted</p></div>
        </div>
        <div class="stat-mini-card">
            <div class="stat-mini-icon" style="background: linear-gradient(135deg, #4facfe, #00f2fe);"><i class="fas fa-trophy"></i></div>
            <div><h4><%= selectedCount %></h4><p>Selected</p></div>
        </div>
    </div>

    <!-- Info Message -->
    <div style="background:#e7e9ff;border-radius:12px;padding:15px 20px;margin-bottom:20px;display:flex;gap:12px;align-items:start;">
        <i class="fas fa-info-circle" style="color:#4c51bf;font-size:18px;margin-top:2px;"></i>
        <div>
            <strong style="color:#4c51bf;font-size:14px;">Read-Only Monitoring</strong>
            <p style="margin:5px 0 0;color:#4a5578;font-size:13px;">
                As an admin, you can monitor all applications. However, <strong>only companies can shortlist or update status</strong>. This ensures proper separation of responsibilities.
            </p>
        </div>
    </div>

    <!-- TABLE -->
    <div class="data-card animate-in">
        <div class="data-card-header">
            <h3><i class="fas fa-list"></i> All Applications (<%= enrichedApps.size() %>)</h3>
        </div>

        <% if (enrichedApps.isEmpty()) { %>
            <div style="padding: 60px; text-align: center;">
                <i class="fas fa-inbox" style="font-size: 60px; color: #d1d5e0;"></i>
                <h3 style="color: #8892b0; font-size: 18px; margin-top: 20px;">No applications yet</h3>
                <p style="color: #8892b0;">Students haven't applied to any jobs yet.</p>
            </div>
        <% } else { %>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Student</th>
                        <th>Roll No</th>
                        <th>Company</th>
                        <th>Job</th>
                        <th>CGPA</th>
                        <th>Branch</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> row : enrichedApps) {
                        Application app = (Application) row.get("app");
                        Student student = (Student) row.get("student");
                        Job job = (Job) row.get("job");
                        Company company = (Company) row.get("company");
                        if (student == null) continue;
                    %>
                    <tr>
                        <td>
                            <div style="display:flex;align-items:center;">
                                <div class="avatar-circle"><%= initials(student.getName()) %></div>
                                <strong style="color:#1a1a2e;"><%= student.getName() %></strong>
                            </div>
                        </td>
                        <td><%= student.getRollNo() != null ? student.getRollNo() : "-" %></td>
                        <td>
                            <% if (company != null) { %>
                                <span style="color:#667eea;font-weight:600;">
                                    <i class="fas fa-building me-1"></i><%= company.getName() %>
                                </span>
                            <% } else { %>
                                <span style="color:#8892b0;">-</span>
                            <% } %>
                        </td>
                        <td><%= job != null ? job.getTitle() : "-" %></td>
                        <td><span class="badge badge-green"><i class="fas fa-star me-1"></i><%= student.getCgpa() %></span></td>
                        <td><%= student.getBranch() %></td>
                        <td>
                            <% if ("PENDING".equals(app.getStatus())) { %>
                                <span class="badge badge-blue">Pending</span>
                            <% } else if ("SHORTLISTED".equals(app.getStatus())) { %>
                                <span class="badge badge-green">Shortlisted</span>
                            <% } else if ("SELECTED".equals(app.getStatus())) { %>
                                <span class="badge" style="background:#d4ecff;color:#1a5fa8;">Selected</span>
                            <% } else { %>
                                <span class="badge badge-pink">Rejected</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>

</body>
</html>