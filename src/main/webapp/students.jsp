<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.placement.model.Student" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null) { response.sendRedirect("login.jsp"); return; }
    List<Student> students = (List<Student>) request.getAttribute("studentsList");
    String searchName = (String) request.getAttribute("searchName");
    String searchBranch = (String) request.getAttribute("searchBranch");
    String minCgpa = (String) request.getAttribute("minCgpa");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Students - Placement Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css"><script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script>
    <style>
        .search-box {
            background: white;
            border-radius: 16px;
            padding: 20px 25px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
            margin-bottom: 20px;
        }
        .search-input {
            padding: 11px 16px;
            border: 1.5px solid #e1e5ee;
            border-radius: 10px;
            font-size: 14px;
            width: 100%;
        }
        .search-input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
        }
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
        <a href="StudentsServlet" class="nav-item active"><i class="fas fa-users"></i> Students</a>
        <a href="CompaniesServlet" class="nav-item"><i class="fas fa-building"></i> Companies</a>
        <a href="JobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> Jobs</a>
        <a href="AdminApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> Applications</a>
        <a href="ShortlistServlet" class="nav-item"><i class="fas fa-trophy"></i> Shortlist</a><a href="AdminInterviewsServlet" class="nav-item"><i class="fas fa-calendar-check"></i> Interviews</a>
        <a href="EventsServlet" class="nav-item"><i class="fas fa-calendar-alt"></i> Events</a>
    <% } else { %>
        <a href="JobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> Browse Jobs</a>
        <a href="MyApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> My Applications</a><a href="MyInterviewsServlet" class="nav-item"><i class="fas fa-calendar-check"></i> My Interviews</a>
        <a href="EventsServlet" class="nav-item"><i class="fas fa-calendar-alt"></i> Events</a>
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
    <div class="topbar">
        <div>
            <h1>Students 👥</h1>
            <p>Manage all registered students in the placement portal.</p>
        </div>
    </div>

    <!-- SEARCH FILTER -->
    <div class="search-box animate-in">
        <form action="StudentsServlet" method="get">
            <div style="display: grid; grid-template-columns: 2fr 1fr 1fr auto; gap: 12px; align-items: end;">
                <div>
                    <label style="font-size: 12px; font-weight: 600; color: #8892b0; margin-bottom: 6px; display: block;">
                        <i class="fas fa-search me-1"></i> Search
                    </label>
                    <input type="text" name="search" class="search-input" 
                           placeholder="Name, Roll No, or Email..." 
                           value="<%= searchName != null ? searchName : "" %>">
                </div>
                <div>
                    <label style="font-size: 12px; font-weight: 600; color: #8892b0; margin-bottom: 6px; display: block;">
                        <i class="fas fa-graduation-cap me-1"></i> Branch
                    </label>
                    <select name="branch" class="search-input">
                        <option value="">All Branches</option>
                        <option value="Computer Science" <%= "Computer Science".equals(searchBranch) ? "selected" : "" %>>Computer Science</option>
                        <option value="IT" <%= "IT".equals(searchBranch) ? "selected" : "" %>>IT</option>
                        <option value="Electronics" <%= "Electronics".equals(searchBranch) ? "selected" : "" %>>Electronics</option>
                        <option value="Mechanical" <%= "Mechanical".equals(searchBranch) ? "selected" : "" %>>Mechanical</option>
                        <option value="Civil" <%= "Civil".equals(searchBranch) ? "selected" : "" %>>Civil</option>
                        <option value="Electrical" <%= "Electrical".equals(searchBranch) ? "selected" : "" %>>Electrical</option>
                    </select>
                </div>
                <div>
                    <label style="font-size: 12px; font-weight: 600; color: #8892b0; margin-bottom: 6px; display: block;">
                        <i class="fas fa-star me-1"></i> Min CGPA
                    </label>
                    <input type="number" name="minCgpa" step="0.1" min="0" max="10" class="search-input" 
                           placeholder="e.g., 7.0" value="<%= minCgpa != null ? minCgpa : "" %>">
                </div>
                <div style="display: flex; gap: 8px;">
                    <button type="submit" class="btn-primary-grad">
                        <i class="fas fa-filter"></i> Filter
                    </button>
                    <a href="StudentsServlet" class="btn-primary-grad" style="background: #e1e5ee; color: #4a5578;">
                        <i class="fas fa-times"></i>
                    </a>
                </div>
            </div>
        </form>
    </div>

    <div class="data-card animate-in">
        <div class="data-card-header">
            <h3>
                <i class="fas fa-users"></i> 
                Students (<%= students != null ? students.size() : 0 %>)
                <% if ((searchName != null && !searchName.isEmpty()) || 
                       (searchBranch != null && !searchBranch.isEmpty()) || 
                       (minCgpa != null && !minCgpa.isEmpty())) { %>
                    <span class="badge badge-green" style="margin-left: 10px;">
                        <i class="fas fa-filter me-1"></i> Filtered
                    </span>
                <% } %>
            </h3>
            <% if ("admin".equals(role)) { %>
                <div style="display: flex; gap: 10px;">
                    <a href="ExportServlet?type=students" class="btn-primary-grad" style="background: linear-gradient(135deg, #43e97b, #38f9d7);">
                        <i class="fas fa-download"></i> Export CSV
                    </a>
                    <a href="add-student.jsp" class="btn-primary-grad">
                        <i class="fas fa-plus"></i> Add Student
                    </a>
                </div>
            <% } %>
        </div>

        <% if (students == null || students.isEmpty()) { %>
            <div style="padding: 60px; text-align: center;">
                <i class="fas fa-search" style="font-size: 50px; color: #d1d5e0;"></i>
                <h3 style="color: #8892b0; font-size: 18px; margin-top: 15px;">No students found</h3>
                <p style="color: #8892b0;">Try changing the filters or add new students.</p>
            </div>
        <% } else { %>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Student</th>
                        <th>Roll No</th>
                        <th>Email</th>
                        <th>Resume</th>
                        <th>CGPA</th>
                        <th>Branch</th>
                        <th>Skills</th>
                        <% if ("admin".equals(role)) { %><th>Action</th><% } %>
                    </tr>
                </thead>
                <tbody>
                    <% for (Student s : students) { %>
                    <tr>
                        <td>#<%= s.getId() %></td>
                        <td><strong style="color:#1a1a2e;"><%= s.getName() %></strong></td>
                        <td><%= s.getRollNo() %></td>
                        <td><%= s.getEmail() %></td>
                        <td>
                            <% if (s.getResumePath() != null && !s.getResumePath().isEmpty()) { %>
                                <a href="<%= s.getResumePath() %>" target="_blank" class="badge badge-green" style="text-decoration: none;">
                                    <i class="fas fa-file-pdf me-1"></i> View
                                </a>
                            <% } else { %>
                                <span class="badge" style="background: #f0f2f5; color: #8892b0;">N/A</span>
                            <% } %>
                        </td>
                        <td><span class="badge badge-green"><i class="fas fa-star me-1"></i><%= s.getCgpa() %></span></td>
                        <td><%= s.getBranch() %></td>
                        <td>
                            <% if (s.getSkills() != null) {
                                 for (String skill : s.getSkills()) { %>
                                <span class="badge badge-purple"><%= skill.trim() %></span>
                            <% } } %>
                        </td>
                        <% if ("admin".equals(role)) { %>
                        <td>
                            <a href="DeleteServlet?type=student&id=<%= s.getId() %>"
                               class="btn-delete"
                               onclick="return confirm('Delete <%= s.getName() %>? This cannot be undone!')">
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