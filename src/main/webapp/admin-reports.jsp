<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.placement.model.Application" %>
<%@ page import="com.placement.model.Student" %>
<%@ page import="com.placement.model.Job" %>
<%@ page import="com.placement.model.Company" %>
<%!
    private Student findStudent(List<Student> s, int id) {
        for (Student x : s) if (x.getId() == id) return x;
        return null;
    }
    private Job findJob(List<Job> j, int id) {
        for (Job x : j) if (x.getId() == id) return x;
        return null;
    }
    private Company findCompany(List<Company> c, int id) {
        for (Company x : c) if (x.getId() == id) return x;
        return null;
    }
%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) { response.sendRedirect("login.jsp"); return; }

    int totalStudents = (Integer) request.getAttribute("totalStudents");
    int totalCompanies = (Integer) request.getAttribute("totalCompanies");
    int totalJobs = (Integer) request.getAttribute("totalJobs");
    int totalApplications = (Integer) request.getAttribute("totalApplications");
    int totalInterviews = (Integer) request.getAttribute("totalInterviews");
    int pending = (Integer) request.getAttribute("pending");
    int shortlisted = (Integer) request.getAttribute("shortlisted");
    int selected = (Integer) request.getAttribute("selected");
    int rejected = (Integer) request.getAttribute("rejected");
    List<Map.Entry<String, Integer>> topCompanies = (List<Map.Entry<String, Integer>>) request.getAttribute("topCompanies");
    List<Application> recentApps = (List<Application>) request.getAttribute("recentApps");
    List<Student> students = (List<Student>) request.getAttribute("allStudents");
    List<Job> jobs = (List<Job>) request.getAttribute("allJobs");
    List<Company> companies = (List<Company>) request.getAttribute("allCompanies");

    String branchLabels = (String) request.getAttribute("branchLabels");
    String branchTotalData = (String) request.getAttribute("branchTotalData");
    String branchSelectedData = (String) request.getAttribute("branchSelectedData");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Reports - Placement Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <script src="js/theme.js"></script>
    <style>
        .chart-card { background: white; border-radius: 16px; padding: 25px; box-shadow: 0 4px 20px rgba(0,0,0,0.04); margin-bottom: 20px; }
        .chart-card h4 { font-size: 16px; font-weight: 700; color: #1a1a2e; margin-bottom: 20px; }
        .chart-card h4 i { color: #667eea; margin-right: 8px; }
        .chart-wrapper { position: relative; height: 280px; }
        .stat-mini { display: grid; grid-template-columns: repeat(5, 1fr); gap: 15px; margin-bottom: 20px; }
        .stat-mini-card { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 4px 15px rgba(0,0,0,0.04); text-align: center; }
        .stat-mini-card .icon-circle {
            width: 50px; height: 50px; border-radius: 50%; margin: 0 auto 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 22px; color: white;
        }
        .stat-mini-card h4 { font-size: 24px; font-weight: 700; margin: 5px 0; color: #1a1a2e; }
        .stat-mini-card p { font-size: 11px; color: #8892b0; margin: 0; text-transform: uppercase; letter-spacing: 1px; }
        
        .progress-item { margin-bottom: 15px; }
        .progress-item .header { display: flex; justify-content: space-between; margin-bottom: 6px; }
        .progress-item .header span { font-size: 13px; color: #4a5578; font-weight: 600; }
        .progress-item .header .count { color: #667eea; font-weight: 700; }
        .progress-bar-custom { height: 8px; background: #f0f2f5; border-radius: 10px; overflow: hidden; }
        .progress-bar-custom .fill { height: 100%; background: linear-gradient(90deg, #667eea, #764ba2); border-radius: 10px; transition: width 0.5s; }
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
    <a href="AdminInterviewsServlet" class="nav-item"><i class="fas fa-calendar-check"></i> Interviews</a>
    <a href="ShortlistServlet" class="nav-item"><i class="fas fa-trophy"></i> Shortlist</a>
    <a href="CompanyStatsServlet" class="nav-item"><i class="fas fa-chart-bar"></i> Company Stats</a>
    <a href="AdminReportsServlet" class="nav-item active"><i class="fas fa-chart-line"></i> Reports</a>
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
            <h1>Reports & Analytics 📊</h1>
            <p>Complete overview of placement activities.</p>
        </div>
    </div>

    <!-- STATS -->
    <div class="stat-mini animate-in">
        <div class="stat-mini-card">
            <div class="icon-circle" style="background: linear-gradient(135deg, #667eea, #764ba2);"><i class="fas fa-users"></i></div>
            <h4><%= totalStudents %></h4>
            <p>Students</p>
        </div>
        <div class="stat-mini-card">
            <div class="icon-circle" style="background: linear-gradient(135deg, #f093fb, #f5576c);"><i class="fas fa-building"></i></div>
            <h4><%= totalCompanies %></h4>
            <p>Companies</p>
        </div>
        <div class="stat-mini-card">
            <div class="icon-circle" style="background: linear-gradient(135deg, #4facfe, #00f2fe);"><i class="fas fa-briefcase"></i></div>
            <h4><%= totalJobs %></h4>
            <p>Jobs</p>
        </div>
        <div class="stat-mini-card">
            <div class="icon-circle" style="background: linear-gradient(135deg, #43e97b, #38f9d7);"><i class="fas fa-file-alt"></i></div>
            <h4><%= totalApplications %></h4>
            <p>Applications</p>
        </div>
        <div class="stat-mini-card">
            <div class="icon-circle" style="background: linear-gradient(135deg, #f6c23e, #f5576c);"><i class="fas fa-calendar-check"></i></div>
            <h4><%= totalInterviews %></h4>
            <p>Interviews</p>
        </div>
    </div>

    <!-- STATUS OVERVIEW -->
    <div class="chart-card animate-in">
        <h4><i class="fas fa-tasks"></i> Application Status Overview</h4>
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;">
            <div>
                <div class="progress-item">
                    <div class="header"><span>Pending</span><span class="count"><%= pending %></span></div>
                    <div class="progress-bar-custom"><div class="fill" style="width: <%= totalApplications > 0 ? (pending * 100 / totalApplications) : 0 %>%; background: linear-gradient(90deg, #f6c23e, #f9a825);"></div></div>
                </div>
                <div class="progress-item">
                    <div class="header"><span>Shortlisted</span><span class="count"><%= shortlisted %></span></div>
                    <div class="progress-bar-custom"><div class="fill" style="width: <%= totalApplications > 0 ? (shortlisted * 100 / totalApplications) : 0 %>%; background: linear-gradient(90deg, #43e97b, #38f9d7);"></div></div>
                </div>
                <div class="progress-item">
                    <div class="header"><span>Selected</span><span class="count"><%= selected %></span></div>
                    <div class="progress-bar-custom"><div class="fill" style="width: <%= totalApplications > 0 ? (selected * 100 / totalApplications) : 0 %>%; background: linear-gradient(90deg, #4facfe, #00f2fe);"></div></div>
                </div>
                <div class="progress-item">
                    <div class="header"><span>Rejected</span><span class="count"><%= rejected %></span></div>
                    <div class="progress-bar-custom"><div class="fill" style="width: <%= totalApplications > 0 ? (rejected * 100 / totalApplications) : 0 %>%; background: linear-gradient(90deg, #f5576c, #f093fb);"></div></div>
                </div>
            </div>
            <div class="chart-wrapper" style="height: 220px;">
                <canvas id="statusChart"></canvas>
            </div>
        </div>
    </div>

    <!-- BRANCH-WISE PLACEMENT -->
    <div class="chart-card animate-in">
        <h4><i class="fas fa-graduation-cap"></i> Branch-wise Students & Placements</h4>
        <div class="chart-wrapper">
            <canvas id="branchChart"></canvas>
        </div>
    </div>

    <!-- TOP COMPANIES + RECENT ACTIVITY -->
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px;">
        <div class="chart-card animate-in">
            <h4><i class="fas fa-crown"></i> Top Recruiting Companies</h4>
            <% if (topCompanies == null || topCompanies.isEmpty()) { %>
                <p style="color: #8892b0; text-align: center; padding: 30px;">No data available</p>
            <% } else { 
                int maxCount = topCompanies.get(0).getValue();
                for (Map.Entry<String, Integer> entry : topCompanies) {
            %>
                <div class="progress-item">
                    <div class="header"><span><%= entry.getKey() %></span><span class="count"><%= entry.getValue() %> applications</span></div>
                    <div class="progress-bar-custom"><div class="fill" style="width: <%= maxCount > 0 ? (entry.getValue() * 100 / maxCount) : 0 %>%;"></div></div>
                </div>
            <% } } %>
        </div>

        <div class="chart-card animate-in">
            <h4><i class="fas fa-clock"></i> Recent Applications</h4>
            <% if (recentApps == null || recentApps.isEmpty()) { %>
                <p style="color: #8892b0; text-align: center; padding: 30px;">No applications yet</p>
            <% } else { 
                for (Application a : recentApps) {
                    Student s = findStudent(students, a.getStudentId());
                    Job j = findJob(jobs, a.getJobId());
                    if (s == null || j == null) continue;
            %>
                <div style="padding: 12px 0; border-bottom: 1px solid #f0f2f5; display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <strong style="color: #1a1a2e; font-size: 14px;"><%= s.getName() %></strong>
                        <p style="margin: 3px 0 0; color: #8892b0; font-size: 12px;">
                            Applied for <strong><%= j.getTitle() %></strong>
                        </p>
                    </div>
                    <span class="badge badge-<%= "PENDING".equals(a.getStatus()) ? "blue" : "SHORTLISTED".equals(a.getStatus()) ? "green" : "SELECTED".equals(a.getStatus()) ? "purple" : "pink" %>">
                        <%= a.getStatus() %>
                    </span>
                </div>
            <% } } %>
        </div>
    </div>
</div>

<script>
    // Status Chart
    new Chart(document.getElementById('statusChart'), {
        type: 'doughnut',
        data: {
            labels: ['Pending', 'Shortlisted', 'Selected', 'Rejected'],
            datasets: [{
                data: [<%= pending %>, <%= shortlisted %>, <%= selected %>, <%= rejected %>],
                backgroundColor: ['#f6c23e', '#43e97b', '#4facfe', '#f5576c'],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { position: 'bottom' } }
        }
    });

    // Branch Chart
    new Chart(document.getElementById('branchChart'), {
        type: 'bar',
        data: {
            labels: [<%= branchLabels %>],
            datasets: [
                {
                    label: 'Total Students',
                    data: [<%= branchTotalData %>],
                    backgroundColor: '#667eea',
                    borderRadius: 8
                },
                {
                    label: 'Placed Students',
                    data: [<%= branchSelectedData %>],
                    backgroundColor: '#43e97b',
                    borderRadius: 8
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { position: 'top' } },
            scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
        }
    });
</script>

</body>
</html>