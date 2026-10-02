<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.placement.model.Company" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null) { response.sendRedirect("login.jsp"); return; }
    List<Company> companies = (List<Company>) request.getAttribute("companiesList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Companies - Placement Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css"><script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script>
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
        <a href="CompaniesServlet" class="nav-item active"><i class="fas fa-building"></i> Companies</a>
        <a href="JobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> Jobs</a>
        <a href="AdminApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> Applications</a>
        <a href="ShortlistServlet" class="nav-item"><i class="fas fa-trophy"></i> Shortlist</a><a href="AdminInterviewsServlet" class="nav-item"><i class="fas fa-calendar-check"></i> Interviews</a>
        <a href="EventsServlet" class="nav-item"><i class="fas fa-calendar-alt"></i> Events</a>
    <% } else { %>
        <a href="JobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> Browse Jobs</a>
        <a href="MyApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> My Applications</a><a href="MyInterviewsServlet" class="nav-item"><i class="fas fa-calendar-check"></i> My Interviews</a>
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
    <div class="topbar">
        <div>
            <h1>Companies 🏢</h1>
            <p>Manage all partner companies in your placement portal.</p>
        </div>
    </div>

    <div class="data-card animate-in">
        <div class="data-card-header">
            <h3><i class="fas fa-building"></i> All Companies (<%= companies != null ? companies.size() : 0 %>)</h3>
            <% if ("admin".equals(role)) { %>
                <a href="add-company.jsp" class="btn-primary-grad">
                    <i class="fas fa-plus"></i> Add Company
                </a>
            <% } %>
        </div>

        <% if (companies == null || companies.isEmpty()) { %>
            <div style="padding: 40px; text-align: center;">
                <div class="alert-modern alert-warning-modern" style="display: inline-flex;">
                    <i class="fas fa-exclamation-triangle"></i> No companies found!
                </div>
            </div>
        <% } else { %>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Company Name</th>
                        <th>Industry</th>
                        <% if ("admin".equals(role)) { %><th>Action</th><% } %>
                    </tr>
                </thead>
                <tbody>
                    <% for (Company c : companies) { %>
                    <tr>
                        <td>#<%= c.getId() %></td>
                        <td>
                            <strong style="color:#1a1a2e;">
                                <i class="fas fa-building me-2" style="color:#667eea;"></i>
                                <%= c.getName() %>
                            </strong>
                        </td>
                        <td><span class="badge badge-purple"><%= c.getIndustry() %></span></td>
                        <% if ("admin".equals(role)) { %>
                        <td>
                            <a href="DeleteServlet?type=company&id=<%= c.getId() %>"
                               class="btn-delete"
                               onclick="return confirm('Delete <%= c.getName() %>? This cannot be undone!')">
                                <i class="fas fa-trash"></i>
                            </a>
                        </td>
                        <% } %>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>

</body>
</html>