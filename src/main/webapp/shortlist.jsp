<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.placement.model.Job" %>
<%@ page import="com.placement.model.Student" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Job> allJobs = (List<Job>) request.getAttribute("allJobs");
    Job selectedJob = (Job) request.getAttribute("selectedJob");
    List<Student> shortlisted = (List<Student>) request.getAttribute("shortlistedStudents");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Shortlist - Placement Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css"><script src="js/theme.js"></script><script src="js/chatbot.js"></script><script src="js/chatbot.js"></script>
    <style>
        .filter-card {
            background: white; border-radius: 16px; padding: 25px 30px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04); margin-bottom: 25px;
        }
        .form-label-modern {
            font-size: 13px; font-weight: 600; color: #1a1a2e;
            margin-bottom: 8px; display: block;
        }
        .form-label-modern i { color: #667eea; margin-right: 6px; }
        .form-control-modern {
            width: 100%; padding: 12px 16px; border: 1.5px solid #e1e5ee;
            border-radius: 10px; font-size: 14px;
        }
        .form-control-modern:focus {
            outline: none; border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.1);
        }
        .job-info-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white; border-radius: 16px; padding: 25px 30px;
            margin-bottom: 25px;
        }
        .job-info-card h3 { color: white; margin-bottom: 12px; }
        .job-info-card .meta { color: rgba(255,255,255,0.9); font-size: 14px; margin: 6px 0; }
        .job-info-card .badge-white {
            background: rgba(255,255,255,0.2); color: white;
            padding: 4px 12px; border-radius: 20px; font-size: 12px;
            margin: 2px; display: inline-block;
        }
        .rank-badge {
            width: 32px; height: 32px; border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white; display: inline-flex; align-items: center;
            justify-content: center; font-weight: 700; font-size: 13px;
        }
        .empty-state {
            padding: 60px; text-align: center;
        }
        .empty-state i { font-size: 60px; color: #d1d5e0; margin-bottom: 20px; }
        .empty-state h3 { color: #8892b0; font-size: 18px; }
        .empty-state p { color: #8892b0; margin-top: 10px; }
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
    <a href="ShortlistServlet" class="nav-item active"><i class="fas fa-trophy"></i> Shortlist</a>
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
            <h1>Shortlist Students 🎯</h1>
            <p>Auto-select students based on job eligibility criteria.</p>
        </div>
    </div>

    <!-- JOB SELECTOR -->
    <div class="filter-card animate-in">
        <form action="ShortlistServlet" method="get">
            <label class="form-label-modern"><i class="fas fa-briefcase"></i> Select a Job to View Shortlist</label>
            <div style="display: flex; gap: 12px; flex-wrap: wrap;">
                <select name="jobId" class="form-control-modern" style="flex: 1; min-width: 250px;" required>
                    <option value="">-- Choose a Job --</option>
                    <% if (allJobs != null) {
                         for (Job j : allJobs) { %>
                        <option value="<%= j.getId() %>" 
                                <%= (selectedJob != null && selectedJob.getId() == j.getId()) ? "selected" : "" %>>
                            <%= j.getTitle() %> (Min CGPA: <%= j.getMinCgpa() %>)
                        </option>
                    <% } } %>
                </select>
                <button type="submit" class="btn-primary-grad" style="padding: 12px 30px;">
                    <i class="fas fa-search"></i> Show Shortlist
                </button>
            </div>
        </form>
    </div>

    <% if (selectedJob != null) { %>
        <!-- SELECTED JOB INFO -->
        <div class="job-info-card animate-in">
            <h3><i class="fas fa-briefcase me-2"></i> <%= selectedJob.getTitle() %></h3>
            <div class="meta"><i class="fas fa-star me-1"></i> Minimum CGPA: <strong><%= selectedJob.getMinCgpa() %></strong></div>
            <div class="meta">
                <i class="fas fa-graduation-cap me-1"></i> Eligible Branches: 
                <% for (String b : selectedJob.getEligibleBranches()) { %>
                    <span class="badge-white"><%= b.trim() %></span>
                <% } %>
            </div>
            <div class="meta">
                <i class="fas fa-code me-1"></i> Required Skills: 
                <% for (String s : selectedJob.getRequiredSkills()) { %>
                    <span class="badge-white"><%= s.trim() %></span>
                <% } %>
            </div>
        </div>

        <!-- SHORTLISTED STUDENTS -->
        <div class="data-card animate-in">
            <div class="data-card-header">
                <h3>
                    <i class="fas fa-trophy" style="color: #f6c23e;"></i> 
                    Shortlisted Students 
                    (<%= shortlisted != null ? shortlisted.size() : 0 %>)
                </h3>
                <% if (shortlisted != null && !shortlisted.isEmpty()) { %>
    <a href="ExportServlet?type=shortlist&jobId=<%= selectedJob.getId() %>" 
       class="btn-primary-grad" 
       style="background: linear-gradient(135deg, #43e97b, #38f9d7);">
        <i class="fas fa-download"></i> Export Shortlist
    </a>
<% } %>
            </div>

            <% if (shortlisted == null || shortlisted.isEmpty()) { %>
                <div class="empty-state">
                    <i class="fas fa-user-slash"></i>
                    <h3>No students match this job's criteria</h3>
                    <p>Try adjusting the criteria or add more students.</p>
                </div>
            <% } else { %>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Rank</th>
                            <th>Student</th>
                            <th>Roll No</th>
                            <th>Email</th>
                            <th>CGPA</th>
                            <th>Branch</th>
                            <th>Skills</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% int rank = 1;
                           for (Student s : shortlisted) { %>
                        <tr>
                            <td><span class="rank-badge"><%= rank++ %></span></td>
                            <td><strong style="color:#1a1a2e;"><%= s.getName() %></strong></td>
                            <td><%= s.getRollNo() %></td>
                            <td><%= s.getEmail() %></td>
                            <td><span class="badge badge-green"><i class="fas fa-star me-1"></i><%= s.getCgpa() %></span></td>
                            <td><%= s.getBranch() %></td>
                            <td>
                                <% if (s.getSkills() != null) {
                                     for (String skill : s.getSkills()) { %>
                                    <span class="badge badge-purple"><%= skill.trim() %></span>
                                <% } } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    <% } else if (allJobs != null && !allJobs.isEmpty()) { %>
        <div class="data-card animate-in">
            <div class="empty-state">
                <i class="fas fa-hand-point-up"></i>
                <h3>Select a job from the dropdown above</h3>
                <p>We'll auto-shortlist students who match the criteria.</p>
            </div>
        </div>
    <% } else { %>
        <div class="data-card animate-in">
            <div class="empty-state">
                <i class="fas fa-briefcase"></i>
                <h3>No jobs available</h3>
                <p>Add some jobs first to see shortlists.</p>
                <a href="add-job.jsp" class="btn-primary-grad" style="margin-top: 20px;">
                    <i class="fas fa-plus"></i> Add Job
                </a>
            </div>
        </div>
    <% } %>
</div>

</body>
</html>