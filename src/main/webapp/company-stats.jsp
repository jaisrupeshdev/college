<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.placement.model.Company" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Map<String, Object>> statsList = (List<Map<String, Object>>) request.getAttribute("statsList");
    String chartLabels = (String) request.getAttribute("chartLabels");
    String chartData = (String) request.getAttribute("chartData");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Company Stats - Placement Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css"><script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        .chart-card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
            margin-bottom: 25px;
        }
        .chart-card h4 {
            font-size: 16px;
            font-weight: 700;
            color: #1a1a2e;
            margin-bottom: 20px;
        }
        .chart-wrapper { position: relative; height: 320px; }
        .mini-stat {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin: 2px;
        }
        .mini-green { background: #d4f4dd; color: #1d7a3a; }
        .mini-yellow { background: #fff8e1; color: #b7791f; }
        .mini-blue { background: #d4ecff; color: #1a5fa8; }
        .mini-red { background: #fde2e4; color: #b23a48; }
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
    <a href="CompanyStatsServlet" class="nav-item active"><i class="fas fa-chart-bar"></i> Company Stats</a>
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
            <h1>Company-wise Statistics 📊</h1>
            <p>Analyze applications, jobs, and hiring per company.</p>
        </div>
    </div>

    <!-- CHART -->
    <div class="chart-card animate-in">
        <h4><i class="fas fa-chart-bar me-2" style="color:#667eea;"></i> Applications Received per Company</h4>
        <div class="chart-wrapper">
            <canvas id="companyChart"></canvas>
        </div>
    </div>

    <!-- TABLE -->
    <div class="data-card animate-in">
        <div class="data-card-header">
            <h3><i class="fas fa-building"></i> Detailed Breakdown</h3>
        </div>

        <% if (statsList == null || statsList.isEmpty()) { %>
            <div style="padding: 40px; text-align: center;">
                <div class="alert-modern alert-warning-modern" style="display: inline-flex;">
                    <i class="fas fa-exclamation-triangle"></i> No companies found!
                </div>
            </div>
        <% } else { %>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Company</th>
                        <th>Industry</th>
                        <th>Jobs Posted</th>
                        <th>Applications</th>
                        <th>Status Breakdown</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Map<String, Object> stat : statsList) {
                        Company c = (Company) stat.get("company");
                        int jobCount = (int) stat.get("jobCount");
                        int appCount = (int) stat.get("appCount");
                        int shortlistedCount = (int) stat.get("shortlistedCount");
                        int selectedCount = (int) stat.get("selectedCount");
                        int rejectedCount = (int) stat.get("rejectedCount");
                    %>
                    <tr>
                        <td><strong style="color:#1a1a2e;"><i class="fas fa-building me-2" style="color:#667eea;"></i><%= c.getName() %></strong></td>
                        <td><span class="badge badge-purple"><%= c.getIndustry() %></span></td>
                        <td><span class="badge badge-blue"><%= jobCount %></span></td>
                        <td><span class="badge badge-green"><%= appCount %></span></td>
                        <td>
                            <% if (appCount > 0) { %>
                                <span class="mini-stat mini-yellow"><i class="fas fa-clock"></i> Pending: <%= appCount - shortlistedCount - selectedCount - rejectedCount %></span>
                                <span class="mini-stat mini-blue"><i class="fas fa-check-circle"></i> Shortlisted: <%= shortlistedCount %></span>
                                <span class="mini-stat mini-green"><i class="fas fa-trophy"></i> Selected: <%= selectedCount %></span>
                                <span class="mini-stat mini-red"><i class="fas fa-times-circle"></i> Rejected: <%= rejectedCount %></span>
                            <% } else { %>
                                <span style="color:#8892b0;font-size:13px;">No applications</span>
                            <% } %>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>

<script>
    const labels = [<%= chartLabels %>];
    const data = [<%= chartData %>];

    new Chart(document.getElementById('companyChart'), {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Applications',
                data: data,
                backgroundColor: ['#667eea','#f093fb','#4facfe','#43e97b','#f5576c','#f6c23e','#764ba2'],
                borderRadius: 10,
                borderSkipped: false
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, ticks: { stepSize: 1 } }
            }
        }
    });
</script>

</body>
</html>