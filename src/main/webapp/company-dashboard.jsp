<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="com.placement.model.Job" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"company".equals(role)) { response.sendRedirect("login.jsp"); return; }
    
    int jobCount = (Integer) request.getAttribute("jobCount");
    int appCount = (Integer) request.getAttribute("appCount");
    int pendingCount = (Integer) request.getAttribute("pendingCount");
    int shortlistedCount = (Integer) request.getAttribute("shortlistedCount");
    int selectedCount = (Integer) request.getAttribute("selectedCount");
    int rejectedCount = (Integer) request.getAttribute("rejectedCount");
    Map<String, Integer> appsPerJob = (Map<String, Integer>) request.getAttribute("appsPerJob");

    StringBuilder chartLabels = new StringBuilder();
    StringBuilder chartData = new StringBuilder();
    if (appsPerJob != null) {
        for (Map.Entry<String, Integer> e : appsPerJob.entrySet()) {
            chartLabels.append("'").append(e.getKey().replace("'", "\\'")).append("',");
            chartData.append(e.getValue()).append(",");
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Company Dashboard - Placement Portal</title>
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
    </style>
</head>
<body>

<div class="sidebar">
    <div class="brand"><h2><i class="fas fa-graduation-cap"></i> Placement</h2><p>Company Panel</p></div>
    <div class="nav-section">Main Menu</div>
    <a href="CompanyDashboardServlet" class="nav-item active"><i class="fas fa-th-large"></i> Dashboard</a>
    <a href="CompanyJobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> My Jobs</a>
    <a href="CompanyApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> Applications</a>
    <a href="CompanyInterviewsServlet" class="nav-item"><i class="fas fa-calendar-check"></i> Interviews</a>
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
        <div>
            <h1>Welcome, <%= session.getAttribute("companyName") %>! 🏢</h1>
            <p>Manage your job postings and applications.</p>
        </div>
    </div>

    <div class="stats-grid animate-in">
        <div class="stat-card">
            <div class="stat-icon purple"><i class="fas fa-briefcase"></i></div>
            <h3><%= jobCount %></h3>
            <p>Jobs Posted</p>
        </div>
        <div class="stat-card">
            <div class="stat-icon blue"><i class="fas fa-file-alt"></i></div>
            <h3><%= appCount %></h3>
            <p>Total Applications</p>
        </div>
        <div class="stat-card">
            <div class="stat-icon green"><i class="fas fa-check-circle"></i></div>
            <h3><%= shortlistedCount %></h3>
            <p>Shortlisted</p>
        </div>
        <div class="stat-card">
            <div class="stat-icon pink"><i class="fas fa-trophy"></i></div>
            <h3><%= selectedCount %></h3>
            <p>Selected</p>
        </div>
    </div>

    <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 20px; margin-bottom: 20px;">
        <div class="chart-card animate-in">
            <h4><i class="fas fa-chart-bar"></i> Applications per Job</h4>
            <div class="chart-wrapper">
                <canvas id="appsChart"></canvas>
            </div>
        </div>
        <div class="chart-card animate-in">
            <h4><i class="fas fa-chart-pie"></i> Status Breakdown</h4>
            <div class="chart-wrapper">
                <canvas id="statusChart"></canvas>
            </div>
        </div>
    </div>

    <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 20px; color: #1a1a2e;">
        <i class="fas fa-bolt me-2" style="color: #667eea;"></i> Quick Actions
    </h3>

    <div class="menu-grid animate-in">
        <a href="CompanyJobPostServlet" class="menu-card">
            <i class="fas fa-arrow-right arrow"></i>
            <div class="card-icon"><i class="fas fa-plus-circle"></i></div>
            <h4>Post New Job</h4>
            <p>Create a new job opening with eligibility criteria.</p>
        </a>
        <a href="CompanyJobsServlet" class="menu-card">
            <i class="fas fa-arrow-right arrow"></i>
            <div class="card-icon" style="background: linear-gradient(135deg, #f093fb, #f5576c);">
                <i class="fas fa-briefcase"></i>
            </div>
            <h4>My Jobs</h4>
            <p>View and manage all your posted jobs.</p>
        </a>
        <a href="CompanyApplicationsServlet" class="menu-card">
            <i class="fas fa-arrow-right arrow"></i>
            <div class="card-icon" style="background: linear-gradient(135deg, #4facfe, #00f2fe);">
                <i class="fas fa-file-alt"></i>
            </div>
            <h4>View Applications</h4>
            <p>See all applications received for your jobs.</p>
        </a>
        <a href="CompanyInterviewsServlet" class="menu-card">
            <i class="fas fa-arrow-right arrow"></i>
            <div class="card-icon" style="background: linear-gradient(135deg, #43e97b, #38f9d7);">
                <i class="fas fa-calendar-check"></i>
            </div>
            <h4>Interviews</h4>
            <p>Schedule and manage interviews.</p>
        </a>
    </div>
</div>

<script>
    new Chart(document.getElementById('appsChart'), {
        type: 'bar',
        data: {
            labels: [<%= chartLabels.toString() %>],
            datasets: [{
                label: 'Applications',
                data: [<%= chartData.toString() %>],
                backgroundColor: ['#667eea','#f093fb','#4facfe','#43e97b','#f5576c','#f6c23e'],
                borderRadius: 8,
                borderSkipped: false
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
        }
    });

    new Chart(document.getElementById('statusChart'), {
        type: 'doughnut',
        data: {
            labels: ['Pending','Shortlisted','Selected','Rejected'],
            datasets: [{
                data: [<%= pendingCount %>, <%= shortlistedCount %>, <%= selectedCount %>, <%= rejectedCount %>],
                backgroundColor: ['#f6c23e','#43e97b','#4facfe','#f5576c'],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { position: 'bottom' } }
        }
    });
</script>

</body>
</html>