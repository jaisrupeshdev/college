<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Student - Placement Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css"><script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script>
    <style>
        .form-card {
            background: white;
            border-radius: 16px;
            padding: 35px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
            max-width: 800px;
        }
        .form-label-modern {
            font-size: 13px;
            font-weight: 600;
            color: #1a1a2e;
            margin-bottom: 8px;
            display: block;
        }
        .form-label-modern i {
            color: #667eea;
            margin-right: 6px;
        }
        .form-control-modern {
            width: 100%;
            padding: 12px 16px;
            border: 1.5px solid #e1e5ee;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s;
            color: #1a1a2e;
        }
        .form-control-modern:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        @media (max-width: 600px) {
            .form-row { grid-template-columns: 1fr; }
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
    <a href="StudentsServlet" class="nav-item active"><i class="fas fa-users"></i> Students</a>
    <a href="CompaniesServlet" class="nav-item"><i class="fas fa-building"></i> Companies</a>
    <a href="JobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> Jobs</a>
    <a href="AdminApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> Applications</a>
    <a href="ShortlistServlet" class="nav-item"><i class="fas fa-trophy"></i> Shortlist</a><a href="AdminInterviewsServlet" class="nav-item"><i class="fas fa-calendar-check"></i> Interviews</a>
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
            <h1>Add New Student ➕</h1>
            <p>Fill in the details below to register a new student.</p>
        </div>
        <a href="StudentsServlet" class="btn-primary-grad" style="background: #e1e5ee; color: #4a5578;">
            <i class="fas fa-arrow-left"></i> Back to List
        </a>
    </div>

    <div class="form-card animate-in">
        <form action="AddStudentServlet" method="post">
            
            <div class="form-row">
                <div>
                    <label class="form-label-modern"><i class="fas fa-user"></i> Full Name</label>
                    <input type="text" name="name" class="form-control-modern" placeholder="e.g., Rupesh Kumar" required>
                </div>
                <div>
                    <label class="form-label-modern"><i class="fas fa-id-card"></i> Roll Number</label>
                    <input type="text" name="rollNo" class="form-control-modern" placeholder="e.g., CS2024001" required>
                </div>
            </div>

            <div class="form-row">
                <div>
                    <label class="form-label-modern"><i class="fas fa-envelope"></i> Email</label>
                    <input type="email" name="email" class="form-control-modern" placeholder="student@example.com" required>
                </div>
                <div>
                    <label class="form-label-modern"><i class="fas fa-lock"></i> Password</label>
                    <input type="text" name="password" class="form-control-modern" placeholder="Set a password" required>
                </div>
            </div>

            <div class="form-row">
                <div>
                    <label class="form-label-modern"><i class="fas fa-star"></i> CGPA</label>
                    <input type="number" name="cgpa" step="0.01" min="0" max="10" class="form-control-modern" placeholder="e.g., 8.5" required>
                </div>
                <div>
                    <label class="form-label-modern"><i class="fas fa-graduation-cap"></i> Branch</label>
                    <select name="branch" class="form-control-modern" required>
                        <option value="">-- Select Branch --</option>
                        <option value="Computer Science">Computer Science</option>
                        <option value="IT">Information Technology</option>
                        <option value="Electronics">Electronics</option>
                        <option value="Mechanical">Mechanical</option>
                        <option value="Civil">Civil</option>
                        <option value="Electrical">Electrical</option>
                    </select>
                </div>
            </div>

            <div style="margin-bottom: 25px;">
                <label class="form-label-modern"><i class="fas fa-code"></i> Skills</label>
                <input type="text" name="skills" class="form-control-modern" placeholder="Comma separated: Java, SQL, Python" required>
                <p style="font-size: 12px; color: #8892b0; margin-top: 6px;">
                    <i class="fas fa-info-circle"></i> Skills ko comma se alag karo
                </p>
            </div>

            <button type="submit" class="btn-primary-grad" style="width: 100%; justify-content: center; padding: 14px;">
                <i class="fas fa-save"></i> Save Student
            </button>

        </form>
    </div>
</div>
<% if ("student".equals(session.getAttribute("role"))) { %>
    <script src="js/chatbot.js"></script>
<% } %>
</body>
</html>