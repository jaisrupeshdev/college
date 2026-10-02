<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.placement.model.Application" %>
<%@ page import="com.placement.model.Job" %>
<%@ page import="com.placement.model.Student" %>
<%!
    private Student findStudent(List<Student> list, int id) {
        for (Student s : list) if (s.getId() == id) return s;
        return null;
    }
    private String getJobTitle(List<Job> jobs, int id) {
        for (Job j : jobs) if (j.getId() == id) return j.getTitle();
        return "Unknown";
    }
    private String initials(String name) {
        if (name == null || name.isEmpty()) return "?";
        String[] parts = name.trim().split("\\s+");
        if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
        return (parts[0].charAt(0) + "" + parts[parts.length-1].charAt(0)).toUpperCase();
    }
%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"company".equals(role)) { response.sendRedirect("login.jsp"); return; }
    List<Application> applications = (List<Application>) request.getAttribute("applicationsList");
    List<Job> myJobs = (List<Job>) request.getAttribute("myJobs");
    List<Student> students = (List<Student>) request.getAttribute("allStudents");
    int jobCount = (Integer) request.getAttribute("jobCount");
    int totalApplications = (Integer) request.getAttribute("totalApplications");
    int shortlistedCount = (Integer) request.getAttribute("shortlistedCount");
    int selectedCount = (Integer) request.getAttribute("selectedCount");
    String search = (String) request.getAttribute("search");
    String minCgpa = (String) request.getAttribute("minCgpa");
    String sortBy = (String) request.getAttribute("sortBy");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Applications - Company Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="js/theme.js"></script>
    <style>
        .filter-card { background: white; border-radius: 16px; padding: 20px 25px; box-shadow: 0 4px 20px rgba(0,0,0,0.04); margin-bottom: 20px; }
        .filter-input { width: 100%; padding: 10px 14px; border: 1.5px solid #e1e5ee; border-radius: 10px; font-size: 14px; color: #1a1a2e; background: white; }
        .filter-input:focus { outline: none; border-color: #667eea; box-shadow: 0 0 0 3px rgba(102,126,234,0.1); }
        .filter-label { font-size: 11px; font-weight: 700; color: #8892b0; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 6px; display: block; }
        .stats-mini { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; margin-bottom: 20px; }
        .stat-mini-card { background: white; border-radius: 12px; padding: 18px; box-shadow: 0 4px 15px rgba(0,0,0,0.04); display: flex; align-items: center; gap: 15px; }
        .stat-mini-icon { width: 45px; height: 45px; border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 20px; color: white; }
        .stat-mini-card h4 { font-size: 22px; font-weight: 700; margin: 0; color: #1a1a2e; }
        .stat-mini-card p { font-size: 11px; color: #8892b0; margin: 0; text-transform: uppercase; letter-spacing: 1px; }
        .avatar-circle {
            width: 38px; height: 38px; border-radius: 50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white; display: inline-flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 13px; margin-right: 10px;
        }
        .status-select {
            padding: 5px 10px; border-radius: 20px; border: 1.5px solid #e1e5ee;
            font-size: 12px; font-weight: 600; cursor: pointer;
        }
        .status-select.PENDING { background: #fff8e1; color: #b7791f; border-color: #f6c23e; }
        .status-select.SHORTLISTED { background: #d4f4dd; color: #1d7a3a; border-color: #43e97b; }
        .status-select.SELECTED { background: #d4ecff; color: #1a5fa8; border-color: #4facfe; }
        .status-select.REJECTED { background: #fde2e4; color: #b23a48; border-color: #f5576c; }
        .row-checkbox { width: 18px; height: 18px; cursor: pointer; accent-color: #667eea; }
        .bulk-bar {
            display: none; background: linear-gradient(135deg, #667eea, #764ba2);
            color: white; padding: 12px 20px; border-radius: 12px; margin-bottom: 15px;
            align-items: center; justify-content: space-between;
        }
        .bulk-bar.show { display: flex; }
        .bulk-bar button {
            padding: 6px 15px; border-radius: 8px; border: none; cursor: pointer;
            font-weight: 600; font-size: 13px; margin-left: 8px;
        }
    </style>
</head>
<body>

<div class="sidebar">
    <div class="brand"><h2><i class="fas fa-graduation-cap"></i> Placement</h2><p>Company Panel</p></div>
    <div class="nav-section">Main Menu</div>
    <a href="CompanyDashboardServlet" class="nav-item"><i class="fas fa-th-large"></i> Dashboard</a>
    <a href="CompanyJobsServlet" class="nav-item"><i class="fas fa-briefcase"></i> My Jobs</a>
    <a href="CompanyApplicationsServlet" class="nav-item active"><i class="fas fa-file-alt"></i> Applications</a>
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
            <h1>Applications 📄</h1>
            <p>Manage all applications received for your jobs.</p>
        </div>
        <a href="ExportApplicationsServlet" class="btn-primary-grad" style="background: linear-gradient(135deg, #43e97b, #38f9d7);">
            <i class="fas fa-download"></i> Export CSV
        </a>
    </div>

    <div class="stats-mini animate-in">
        <div class="stat-mini-card">
            <div class="stat-mini-icon" style="background: linear-gradient(135deg, #667eea, #764ba2);"><i class="fas fa-briefcase"></i></div>
            <div><h4><%= jobCount %></h4><p>Jobs</p></div>
        </div>
        <div class="stat-mini-card">
            <div class="stat-mini-icon" style="background: linear-gradient(135deg, #4facfe, #00f2fe);"><i class="fas fa-file-alt"></i></div>
            <div><h4><%= totalApplications %></h4><p>Applications</p></div>
        </div>
        <div class="stat-mini-card">
            <div class="stat-mini-icon" style="background: linear-gradient(135deg, #43e97b, #38f9d7);"><i class="fas fa-check-circle"></i></div>
            <div><h4><%= shortlistedCount %></h4><p>Shortlisted</p></div>
        </div>
        <div class="stat-mini-card">
            <div class="stat-mini-icon" style="background: linear-gradient(135deg, #f6c23e, #f5576c);"><i class="fas fa-trophy"></i></div>
            <div><h4><%= selectedCount %></h4><p>Selected</p></div>
        </div>
    </div>

    <div class="filter-card animate-in">
        <form action="CompanyApplicationsServlet" method="get">
            <div style="display: grid; grid-template-columns: 2fr 1fr 1fr 1fr 1fr 1fr auto; gap: 10px; align-items: end;">
                <div>
                    <label class="filter-label">Search</label>
                    <input type="text" name="search" class="filter-input" placeholder="Name, Roll, Email..." value="<%= search != null ? search : "" %>">
                </div>
                <div>
                    <label class="filter-label">Job</label>
                    <select name="jobId" class="filter-input">
                        <option value="all">All Jobs</option>
                        <% for (Job j : myJobs) { %>
                            <option value="<%= j.getId() %>" <%= String.valueOf(j.getId()).equals(request.getAttribute("filterJob")) ? "selected" : "" %>><%= j.getTitle() %></option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label class="filter-label">Status</label>
                    <select name="status" class="filter-input">
                        <option value="all">All</option>
                        <option value="PENDING" <%= "PENDING".equals(request.getAttribute("filterStatus")) ? "selected" : "" %>>Pending</option>
                        <option value="SHORTLISTED" <%= "SHORTLISTED".equals(request.getAttribute("filterStatus")) ? "selected" : "" %>>Shortlisted</option>
                        <option value="SELECTED" <%= "SELECTED".equals(request.getAttribute("filterStatus")) ? "selected" : "" %>>Selected</option>
                        <option value="REJECTED" <%= "REJECTED".equals(request.getAttribute("filterStatus")) ? "selected" : "" %>>Rejected</option>
                    </select>
                </div>
                <div>
                    <label class="filter-label">Branch</label>
                    <select name="branch" class="filter-input">
                        <option value="all">All</option>
                        <option value="Computer Science" <%= "Computer Science".equals(request.getAttribute("filterBranch")) ? "selected" : "" %>>CS</option>
                        <option value="IT" <%= "IT".equals(request.getAttribute("filterBranch")) ? "selected" : "" %>>IT</option>
                        <option value="Electronics" <%= "Electronics".equals(request.getAttribute("filterBranch")) ? "selected" : "" %>>Electronics</option>
                        <option value="Mechanical" <%= "Mechanical".equals(request.getAttribute("filterBranch")) ? "selected" : "" %>>Mechanical</option>
                        <option value="Civil" <%= "Civil".equals(request.getAttribute("filterBranch")) ? "selected" : "" %>>Civil</option>
                    </select>
                </div>
                <div>
                    <label class="filter-label">Min CGPA</label>
                    <input type="number" name="minCgpa" step="0.1" min="0" max="10" class="filter-input" placeholder="e.g., 7.0" value="<%= minCgpa != null ? minCgpa : "" %>">
                </div>
                <div>
                    <label class="filter-label">Sort By</label>
                    <select name="sortBy" class="filter-input">
                        <option value="">Default</option>
                        <option value="cgpa_desc" <%= "cgpa_desc".equals(sortBy) ? "selected" : "" %>>CGPA (High-Low)</option>
                        <option value="cgpa_asc" <%= "cgpa_asc".equals(sortBy) ? "selected" : "" %>>CGPA (Low-High)</option>
                        <option value="name" <%= "name".equals(sortBy) ? "selected" : "" %>>Name (A-Z)</option>
                    </select>
                </div>
                <div style="display:flex;gap:6px;">
                    <button type="submit" class="btn-primary-grad" style="padding:10px 18px;">
                        <i class="fas fa-filter"></i>
                    </button>
                    <a href="CompanyApplicationsServlet" class="btn-primary-grad" style="padding:10px 14px;background:#e1e5ee;color:#4a5578;">
                        <i class="fas fa-times"></i>
                    </a>
                </div>
            </div>
        </form>
    </div>

    <form action="BulkUpdateStatusServlet" method="post">
        <div class="bulk-bar" id="bulkBar">
            <span><i class="fas fa-check-square"></i> <strong id="selectedCount">0</strong> selected</span>
            <div>
                <select name="bulkStatus" style="padding:6px 12px;border-radius:8px;border:none;font-weight:600;">
                    <option value="SHORTLISTED">Shortlist</option>
                    <option value="SELECTED">Select</option>
                    <option value="REJECTED">Reject</option>
                </select>
                <button type="submit" style="background:white;color:#667eea;">
                    <i class="fas fa-check"></i> Apply
                </button>
            </div>
        </div>

        <div class="data-card animate-in">
            <div class="data-card-header">
                <h3><i class="fas fa-file-alt"></i> Applications (<%= applications.size() %>)</h3>
            </div>

            <% if (applications.isEmpty()) { %>
                <div style="padding:60px;text-align:center;">
                    <i class="fas fa-inbox" style="font-size:60px;color:#d1d5e0;"></i>
                    <h3 style="color:#8892b0;font-size:18px;margin-top:20px;">No applications found</h3>
                </div>
            <% } else { %>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th style="width:40px;"><input type="checkbox" class="row-checkbox" id="selectAll"></th>
                            <th>Student</th>
                            <th>Roll No</th>
                            <th>Job</th>
                            <th>CGPA</th>
                            <th>Branch</th>
                            <th>Resume</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Application a : applications) {
                            Student s = findStudent(students, a.getStudentId());
                            if (s == null) continue;
                        %>
                        <tr>
                            <td><input type="checkbox" name="applicationIds" value="<%= a.getId() %>" class="row-checkbox row-select"></td>
                            <td>
                                <div style="display:flex;align-items:center;">
                                    <div class="avatar-circle"><%= initials(s.getName()) %></div>
                                    <strong style="color:#1a1a2e;"><%= s.getName() %></strong>
                                </div>
                            </td>
                            <td><%= s.getRollNo() != null ? s.getRollNo() : "-" %></td>
                            <td><%= getJobTitle(myJobs, a.getJobId()) %></td>
                            <td><span class="badge badge-green"><i class="fas fa-star me-1"></i><%= s.getCgpa() %></span></td>
                            <td><%= s.getBranch() %></td>
                            <td>
                                <% if (s.getResumePath() != null && !s.getResumePath().isEmpty()) { %>
                                    <a href="<%= request.getContextPath() %>/<%= s.getResumePath() %>" target="_blank" class="badge badge-green" style="text-decoration:none;">
                                        <i class="fas fa-file-pdf"></i> View
                                    </a>
                                <% } else { %>
                                    <span class="badge" style="background:#f0f2f5;color:#8892b0;">N/A</span>
                                <% } %>
                            </td>
                            <td>
                                <select class="status-select <%= a.getStatus() %>" onchange="updateStatus(<%= a.getId() %>, this.value)">
                                    <option value="PENDING" <%= "PENDING".equals(a.getStatus()) ? "selected" : "" %>>Pending</option>
                                    <option value="SHORTLISTED" <%= "SHORTLISTED".equals(a.getStatus()) ? "selected" : "" %>>Shortlisted</option>
                                    <option value="SELECTED" <%= "SELECTED".equals(a.getStatus()) ? "selected" : "" %>>Selected</option>
                                    <option value="REJECTED" <%= "REJECTED".equals(a.getStatus()) ? "selected" : "" %>>Rejected</option>
                                </select>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </form>
</div>

<script>
    const selectAll = document.getElementById('selectAll');
    if (selectAll) {
        selectAll.addEventListener('change', function() {
            document.querySelectorAll('.row-select').forEach(cb => cb.checked = this.checked);
            updateBulkBar();
        });
    }

    document.querySelectorAll('.row-select').forEach(cb => {
        cb.addEventListener('change', updateBulkBar);
    });

    function updateBulkBar() {
        const selected = document.querySelectorAll('.row-select:checked').length;
        document.getElementById('selectedCount').textContent = selected;
        const bar = document.getElementById('bulkBar');
        if (selected > 0) bar.classList.add('show');
        else bar.classList.remove('show');
    }

    function updateStatus(appId, newStatus) {
        if (!confirm('Change status to ' + newStatus + '?')) return;
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'UpdateStatusServlet';
        form.innerHTML = '<input name="applicationId" value="' + appId + '"><input name="status" value="' + newStatus + '">';
        document.body.appendChild(form);
        form.submit();
    }
</script>

</body>
</html>