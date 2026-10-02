<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.placement.model.Student" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"student".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
    Student student = (Student) request.getAttribute("student");
    if (student == null) {
        response.sendRedirect("ProfileServlet");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Profile - Placement Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script>
    <style>
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            padding: 40px;
            color: white;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 25px;
            flex-wrap: wrap;
        }
        .avatar {
            width: 100px; height: 100px; border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex; align-items: center; justify-content: center;
            font-size: 45px; color: white;
            border: 4px solid rgba(255,255,255,0.3);
        }
        .profile-header h2 { color: white; margin: 0; font-size: 26px; }
        .profile-header p { color: rgba(255,255,255,0.9); margin: 5px 0 0; }
        .profile-header .badge-white {
            background: rgba(255,255,255,0.2);
            padding: 5px 12px; border-radius: 20px;
            font-size: 12px; margin-right: 5px;
        }
        .form-card {
            background: white; border-radius: 16px; padding: 35px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
        }
        .form-label-modern {
            font-size: 13px; font-weight: 600; color: #1a1a2e;
            margin-bottom: 8px; display: block;
        }
        .form-label-modern i { color: #667eea; margin-right: 6px; }
        .form-control-modern {
            width: 100%; padding: 12px 16px;
            border: 1.5px solid #e1e5ee; border-radius: 10px;
            font-size: 14px; transition: all 0.3s; color: #1a1a2e;
        }
        .form-control-modern:focus {
            outline: none; border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
        }
        .form-control-modern:disabled { background: #f8f9fa; color: #8892b0; }
        .form-row {
            display: grid; grid-template-columns: 1fr 1fr;
            gap: 20px; margin-bottom: 20px;
        }
        @media (max-width: 600px) { .form-row { grid-template-columns: 1fr; } }
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
    <a href="JobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> Browse Jobs</a>
    <a href="MyApplicationsServlet" class="nav-item"><i class="fas fa-file-alt"></i> My Applications</a>
    <a href="MyInterviewsServlet" class="nav-item"><i class="fas fa-calendar-check"></i> My Interviews</a>
    <a href="EventsServlet" class="nav-item"><i class="fas fa-calendar-alt"></i> Events</a>
    <a href="NotificationsServlet" class="nav-item"><i class="fas fa-bell"></i> Notifications</a>
    <a href="ProfileServlet" class="nav-item active"><i class="fas fa-user"></i> My Profile</a>
    <div class="nav-section">Account</div>
    <a href="LogoutServlet" class="nav-item"><i class="fas fa-sign-out-alt"></i> Logout</a>
    <div class="spacer"></div>
    <div class="user-info">
        <div class="name"><i class="fas fa-user-graduate"></i> <%= session.getAttribute("studentName") %></div>
        <div class="role">Student Account</div>
    </div>
</div>

<div class="main-content">
    <div class="topbar">
        <div>
            <h1>My Profile 👤</h1>
            <p>View and update your personal information.</p>
        </div>
    </div>

    <%
        String msg = request.getParameter("msg");
        if ("updated".equals(msg)) {
    %>
        <div class="alert-modern" style="background: #d4f4dd; color: #1d7a3a; border-left: 4px solid #43e97b;">
            <i class="fas fa-check-circle"></i> Profile updated successfully!
        </div>
    <% } else if ("resumeuploaded".equals(msg)) { %>
        <div class="alert-modern" style="background: #d4f4dd; color: #1d7a3a; border-left: 4px solid #43e97b;">
            <i class="fas fa-check-circle"></i> Resume uploaded successfully!
        </div>
    <% } else if ("nofile".equals(msg)) { %>
        <div class="alert-modern" style="background: #fff8e1; color: #b7791f; border-left: 4px solid #f6c23e;">
            <i class="fas fa-exclamation-triangle"></i> Please select a file!
        </div>
    <% } else if ("invalidtype".equals(msg)) { %>
        <div class="alert-modern" style="background: #fde2e4; color: #b23a48; border-left: 4px solid #f5576c;">
            <i class="fas fa-times-circle"></i> Only PDF files allowed!
        </div>
    <% } %>

    <!-- PROFILE HEADER -->
    <div class="profile-header animate-in">
        <div class="avatar"><i class="fas fa-user-graduate"></i></div>
        <div style="flex: 1;">
            <h2><%= student.getName() %></h2>
            <p><i class="fas fa-envelope me-1"></i> <%= student.getEmail() %></p>
            <div style="margin-top: 12px;">
                <span class="badge-white"><i class="fas fa-id-card me-1"></i> <%= student.getRollNo() %></span>
                <span class="badge-white"><i class="fas fa-star me-1"></i> CGPA: <%= student.getCgpa() %></span>
                <span class="badge-white"><i class="fas fa-graduation-cap me-1"></i> <%= student.getBranch() %></span>
            </div>
        </div>
    </div>

    <!-- RESUME UPLOAD -->
    <div class="form-card animate-in" style="margin-bottom: 20px;">
        <h3 style="font-size: 18px; font-weight: 700; color: #1a1a2e; margin-bottom: 20px;">
            <i class="fas fa-file-pdf me-2" style="color: #f5576c;"></i> My Resume
        </h3>

        <% if (student.getResumePath() != null && !student.getResumePath().isEmpty()) { %>
            <div style="padding: 15px 20px; background: #d4f4dd; border-radius: 12px; margin-bottom: 20px; border-left: 4px solid #43e97b; display: flex; justify-content: space-between; align-items: center;">
                <div>
                    <i class="fas fa-check-circle" style="color: #1d7a3a;"></i>
                    <strong style="color: #1d7a3a;">Resume uploaded</strong>
                </div>
                <a href="<%= student.getResumePath() %>" target="_blank" class="btn-primary-grad" style="padding: 6px 14px; font-size: 12px;">
                    <i class="fas fa-eye"></i> View
                </a>
            </div>
        <% } else { %>
            <p style="color: #8892b0; font-size: 13px; margin-bottom: 15px;">
                <i class="fas fa-info-circle"></i> You haven't uploaded a resume yet. Upload a PDF (max 5 MB).
            </p>
        <% } %>

        <form action="UploadResumeServlet" method="post" enctype="multipart/form-data">
            <div style="display: flex; gap: 12px; align-items: center; flex-wrap: wrap;">
                <input type="file" name="resume" accept=".pdf" required
                       style="flex: 1; min-width: 250px; padding: 10px; border: 1.5px dashed #e1e5ee; border-radius: 10px; font-size: 13px;">
                <button type="submit" class="btn-primary-grad" style="padding: 12px 24px;">
                    <i class="fas fa-upload"></i> Upload
                </button>
            </div>
        </form>
    </div>

    <!-- EDIT FORM -->
    <div class="form-card animate-in">
        <h3 style="font-size: 18px; font-weight: 700; color: #1a1a2e; margin-bottom: 25px;">
            <i class="fas fa-edit me-2" style="color: #667eea;"></i> Edit Profile
        </h3>

        <form action="ProfileServlet" method="post">
            <div class="form-row">
                <div>
                    <label class="form-label-modern"><i class="fas fa-user"></i> Full Name</label>
                    <input type="text" name="name" class="form-control-modern" value="<%= student.getName() %>" required>
                </div>
                <div>
                    <label class="form-label-modern"><i class="fas fa-id-card"></i> Roll Number</label>
                    <input type="text" class="form-control-modern" value="<%= student.getRollNo() %>" disabled>
                </div>
            </div>

            <div class="form-row">
                <div>
                    <label class="form-label-modern"><i class="fas fa-envelope"></i> Email</label>
                    <input type="email" name="email" class="form-control-modern" value="<%= student.getEmail() %>" required>
                </div>
                <div>
                    <label class="form-label-modern"><i class="fas fa-lock"></i> Password</label>
                    <input type="password" name="password" class="form-control-modern" 
                           placeholder="Leave blank to keep current" minlength="6">
                    <p style="font-size: 12px; color: #8892b0; margin-top: 6px;">
                        <i class="fas fa-info-circle"></i> Khali chhodo agar change nahi karna
                    </p>
                </div>
            </div>

            <div class="form-row">
                <div>
                    <label class="form-label-modern"><i class="fas fa-star"></i> CGPA</label>
                    <input type="number" name="cgpa" step="0.01" min="0" max="10" class="form-control-modern" value="<%= student.getCgpa() %>" required>
                </div>
                <div>
                    <label class="form-label-modern"><i class="fas fa-graduation-cap"></i> Branch</label>
                    <select name="branch" class="form-control-modern" required>
                        <option value="Computer Science" <%= "Computer Science".equals(student.getBranch()) ? "selected" : "" %>>Computer Science</option>
                        <option value="IT" <%= "IT".equals(student.getBranch()) ? "selected" : "" %>>Information Technology</option>
                        <option value="Electronics" <%= "Electronics".equals(student.getBranch()) ? "selected" : "" %>>Electronics</option>
                        <option value="Mechanical" <%= "Mechanical".equals(student.getBranch()) ? "selected" : "" %>>Mechanical</option>
                        <option value="Civil" <%= "Civil".equals(student.getBranch()) ? "selected" : "" %>>Civil</option>
                        <option value="Electrical" <%= "Electrical".equals(student.getBranch()) ? "selected" : "" %>>Electrical</option>
                    </select>
                </div>
            </div>

            <div style="margin-bottom: 25px;">
                <label class="form-label-modern"><i class="fas fa-code"></i> Skills</label>
                <input type="text" name="skills" class="form-control-modern" 
                       value="<%= student.getSkills() != null ? String.join(", ", student.getSkills()) : "" %>" required>
                <p style="font-size: 12px; color: #8892b0; margin-top: 6px;">
                    <i class="fas fa-info-circle"></i> Comma se alag karo (e.g., Java, SQL, Python)
                </p>
            </div>

            <button type="submit" class="btn-primary-grad" style="width: 100%; justify-content: center; padding: 14px;">
                <i class="fas fa-save"></i> Save Changes
            </button>
        </form>
    </div>
</div>

</body>
</html>