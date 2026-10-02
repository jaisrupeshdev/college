<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"company".equals(role)) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Post Job - Company Panel</title>
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
    </style>
</head>
<body>

<div class="sidebar">
    <div class="brand"><h2><i class="fas fa-graduation-cap"></i> Placement</h2><p>Company Panel</p></div>
    <div class="nav-section">Main Menu</div>
    <a href="CompanyDashboardServlet" class="nav-item"><i class="fas fa-th-large"></i> Dashboard</a>
    <a href="CompanyJobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> My Jobs</a>
    <a href="CompanyApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> Applications</a>
    <a href="CompanyInterviewsServlet" class="nav-item"><i class="fas fa-calendar-check"></i> Interviews</a>
    <a href="CompanyJobPostServlet" class="nav-item active"><i class="fas fa-plus-circle"></i> Post Job</a>
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
        <div><h1>Post New Job ➕</h1><p>Create a new job opening.</p></div>
        <a href="CompanyJobsServlet" class="btn-primary-grad" style="background:#e1e5ee;color:#4a5578;">
            <i class="fas fa-arrow-left"></i> Back to Jobs
        </a>
    </div>

    <div class="form-card animate-in">
        <form action="CompanyJobPostServlet" method="post">
            <div style="margin-bottom: 20px;">
                <label class="form-label-modern"><i class="fas fa-briefcase"></i> Job Title</label>
                <input type="text" name="title" class="form-control-modern" placeholder="e.g., Software Engineer" required>
            </div>
            <div class="form-row">
                <div>
                    <label class="form-label-modern"><i class="fas fa-star"></i> Minimum CGPA</label>
                    <input type="number" name="minCgpa" step="0.01" min="0" max="10" class="form-control-modern" placeholder="e.g., 7.5" required>
                </div>
                <div>
                    <label class="form-label-modern"><i class="fas fa-graduation-cap"></i> Eligible Branches</label>
                    <input type="text" name="branches" class="form-control-modern" placeholder="Computer Science, IT" required>
                </div>
            </div>
            <div style="margin-bottom: 25px;">
                <label class="form-label-modern"><i class="fas fa-code"></i> Required Skills</label>
                <input type="text" name="skills" class="form-control-modern" placeholder="Java, SQL, Spring" required>
            </div>
            <button type="submit" class="btn-primary-grad" style="width: 100%; justify-content: center; padding: 14px;">
                <i class="fas fa-save"></i> Post Job
            </button>
        </form>
    </div>
</div>

</body>
</html>