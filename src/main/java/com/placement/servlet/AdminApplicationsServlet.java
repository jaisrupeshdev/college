package com.placement.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.CompanyDAO;
import com.placement.dao.JobDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Application;
import com.placement.model.Company;
import com.placement.model.Job;
import com.placement.model.Student;

@WebServlet("/AdminApplicationsServlet")
public class AdminApplicationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        ApplicationDAO appDAO = new ApplicationDAO();
        StudentDAO studentDAO = new StudentDAO();
        JobDAO jobDAO = new JobDAO();
        CompanyDAO companyDAO = new CompanyDAO();

        List<Application> applications = appDAO.getAllApplications();
        List<Student> students = studentDAO.getAllStudents();
        List<Job> jobs = jobDAO.getAllJobs();
        List<Company> companies = companyDAO.getAllCompanies();

        // Har application ke liye extra details (company name, job title)
        List<Map<String, Object>> enrichedApps = new ArrayList<>();
        for (Application a : applications) {
            Map<String, Object> row = new HashMap<>();
            row.put("app", a);

            // Job dhundo
            Job job = null;
            for (Job j : jobs) if (j.getId() == a.getJobId()) { job = j; break; }
            row.put("job", job);

            // Company dhundo
            Company company = null;
            if (job != null) {
                for (Company c : companies) if (c.getId() == job.getCompanyId()) { company = c; break; }
            }
            row.put("company", company);

            // Student dhundo
            Student student = null;
            for (Student s : students) if (s.getId() == a.getStudentId()) { student = s; break; }
            row.put("student", student);

            enrichedApps.add(row);
        }

        // Stats
        int total = applications.size();
        int pending = 0, shortlisted = 0, selected = 0, rejected = 0;
        for (Application a : applications) {
            if ("PENDING".equals(a.getStatus())) pending++;
            else if ("SHORTLISTED".equals(a.getStatus())) shortlisted++;
            else if ("SELECTED".equals(a.getStatus())) selected++;
            else if ("REJECTED".equals(a.getStatus())) rejected++;
        }

        request.setAttribute("enrichedApps", enrichedApps);
        request.setAttribute("totalApplications", total);
        request.setAttribute("pendingCount", pending);
        request.setAttribute("shortlistedCount", shortlisted);
        request.setAttribute("selectedCount", selected);
        request.setAttribute("rejectedCount", rejected);

        request.getRequestDispatcher("admin-applications.jsp").forward(request, response);
    }
}