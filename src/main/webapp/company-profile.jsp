<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.placement.model.Company" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"company".equals(role)) { response.sendRedirect("login.jsp"); return; }
    Company company = (Company) request.getAttribute("company");
    if (company == null) { response.sendRedirect("CompanyProfileServlet"); return; }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Company Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="js/theme.js"></script>
    <style>
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px; padding: 40px; color: white;
            margin-bottom: 25px; display: flex; align-items: center; gap: 25px; flex-wrap: wrap;
        }
        .avatar {
            width: 100px; height: 100px; border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex; align-items: center; justify-content: center;
            font-size: 45px; color: white; border: 4px solid rgba(255,255,255,0.3);
        }
        .profile-header h2 { color: white; margin: 0; font-size: 26px; }
        .profile-header p { color: rgba(255,255,255,0.9); margin: 5px 0 0; }
        .form-card { background: white; border-radius: 16px; padding: 35px; box-shadow: 0 4px 20px rgba(0,0,0,0.04); }
        .form-label-modern { font-size: 13px; font-weight: 600; color: #1a1a2e; margin-bottom: 8px; display: block; }
        .form-label-modern i { color: #667eea; margin-right: 6px; }
        .form-control-modern { width: 100%; padding: 12px 16px; border: 1.5px solid #e1e5ee; border-radius: 10px; font-size: 14px; color: #1a1a2e; }
        .form-control-modern:focus { outline: none; border-color: #667eea; box-shadow: 0 0 0 3px rgba(102,126,234,0.1); }
        .form-control-modern:disabled { background: #f8f9fa; color: #8892b0; }
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
    <a href="CompanyJobPostServlet" class="nav-item"><i class="fas fa-plus-circle"></i> Post Job</a>
    <a href="CompanyProfileServlet" class="nav-item active"><i class="fas fa-user"></i> Profile</a>
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
            <h1>Company Profile 🏢</h1>
            <p>View and update your company information.</p>
        </div>
    </div>

    <% if ("updated".equals(request.getParameter("msg"))) { %>
        <div class="alert-modern" style="background:#d4f4dd;color:#1d7a3a;border-left:4px solid #43e97b;">
            <i class="fas fa-check-circle"></i> Profile updated successfully!
        </div>
    <% } %>

    <div class="profile-header animate-in">
        <div class="avatar"><i class="fas fa-building"></i></div>
        <div style="flex:1;">
            <h2><%= company.getName() %></h2>
            <p><i class="fas fa-envelope me-1"></i> <%= company.getEmail() %></p>
            <div style="margin-top:12px;">
                <span style="background:rgba(255,255,255,0.2);padding:5px 12px;border-radius:20px;font-size:12px;">
                    <i class="fas fa-industry me-1"></i> <%= company.getIndustry() %>
                </span>
            </div>
        </div>
    </div>

    <div class="form-card animate-in">
        <h3 style="font-size:18px;font-weight:700;color:#1a1a2e;margin-bottom:25px;">
            <i class="fas fa-edit me-2" style="color:#667eea;"></i> Edit Profile
        </h3>

        <form action="CompanyProfileServlet" method="post">
            <div class="form-row">
                <div>
                    <label class="form-label-modern"><i class="fas fa-building"></i> Company Name</label>
                    <input type="text" name="name" class="form-control-modern" value="<%= company.getName() %>" required>
                </div>
                <div>
                    <label class="form-label-modern"><i class="fas fa-industry"></i> Industry</label>
                    <input type="text" name="industry" class="form-control-modern" value="<%= company.getIndustry() %>" required>
                </div>
            </div>

            <div class="form-row">
                <div>
                    <label class="form-label-modern"><i class="fas fa-envelope"></i> Email (Login ID)</label>
                    <input type="email" class="form-control-modern" value="<%= company.getEmail() %>" disabled>
                </div>
                <div>
                    <label class="form-label-modern"><i class="fas fa-lock"></i> New Password</label>
                    <input type="password" name="password" class="form-control-modern" 
                           placeholder="Leave blank to keep current" minlength="6">
                </div>
            </div>

            <button type="submit" class="btn-primary-grad" style="width:100%;justify-content:center;padding:14px;">
                <i class="fas fa-save"></i> Save Changes
            </button>
        </form>
    </div>
</div>

</body>
</html>