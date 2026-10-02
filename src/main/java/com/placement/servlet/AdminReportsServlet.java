package com.placement.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
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
import com.placement.dao.InterviewDAO;
import com.placement.dao.JobDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Application;
import com.placement.model.Company;
import com.placement.model.Interview;
import com.placement.model.Job;
import com.placement.model.Student;

@WebServlet("/AdminReportsServlet")
public class AdminReportsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Data fetch karo
        List<Student> students = new StudentDAO().getAllStudents();
        List<Company> companies = new CompanyDAO().getAllCompanies();
        List<Job> jobs = new JobDAO().getAllJobs();
        List<Application> applications = new ApplicationDAO().getAllApplications();
        List<Interview> interviews = new InterviewDAO().getAllInterviews();

        // ===== Stats =====
        int totalStudents = students.size();
        int totalCompanies = companies.size();
        int totalJobs = jobs.size();
        int totalApplications = applications.size();
        int totalInterviews = interviews.size();

        int pending = 0, shortlisted = 0, selected = 0, rejected = 0;
        for (Application a : applications) {
            if ("PENDING".equals(a.getStatus())) pending++;
            else if ("SHORTLISTED".equals(a.getStatus())) shortlisted++;
            else if ("SELECTED".equals(a.getStatus())) selected++;
            else if ("REJECTED".equals(a.getStatus())) rejected++;
        }

        // ===== Company-wise applications =====
        Map<String, Integer> companyApps = new LinkedHashMap<>();
        Map<String, Integer> companySelected = new LinkedHashMap<>();
        for (Company c : companies) {
            int appCount = 0, selCount = 0;
            for (Job j : jobs) {
                if (j.getCompanyId() == c.getId()) {
                    for (Application a : applications) {
                        if (a.getJobId() == j.getId()) {
                            appCount++;
                            if ("SELECTED".equals(a.getStatus())) selCount++;
                        }
                    }
                }
            }
            companyApps.put(c.getName(), appCount);
            companySelected.put(c.getName(), selCount);
        }

        // ===== Branch-wise placement =====
        Map<String, Integer> branchTotal = new HashMap<>();
        Map<String, Integer> branchSelected = new HashMap<>();
        for (Student s : students) {
            String b = s.getBranch() != null ? s.getBranch() : "Unknown";
            branchTotal.put(b, branchTotal.getOrDefault(b, 0) + 1);

            // Check karo student selected hai kisi application me
            boolean isSelected = false;
            for (Application a : applications) {
                if (a.getStudentId() == s.getId() && "SELECTED".equals(a.getStatus())) {
                    isSelected = true;
                    break;
                }
            }
            if (isSelected) {
                branchSelected.put(b, branchSelected.getOrDefault(b, 0) + 1);
            }
        }

        // ===== Top 5 companies by applications =====
        List<Map.Entry<String, Integer>> topCompanies = new ArrayList<>(companyApps.entrySet());
        topCompanies.sort((e1, e2) -> e2.getValue().compareTo(e1.getValue()));
        if (topCompanies.size() > 5) topCompanies = topCompanies.subList(0, 5);

        // ===== Recent applications (last 5) =====
        List<Application> recentApps = new ArrayList<>(applications);
        recentApps.sort((a1, a2) -> {
            if (a1.getAppliedDate() == null) return 1;
            if (a2.getAppliedDate() == null) return -1;
            return a2.getAppliedDate().compareTo(a1.getAppliedDate());
        });
        if (recentApps.size() > 5) recentApps = recentApps.subList(0, 5);

        // Chart data
        StringBuilder branchLabels = new StringBuilder();
        StringBuilder branchTotalData = new StringBuilder();
        StringBuilder branchSelectedData = new StringBuilder();
        for (String b : branchTotal.keySet()) {
            branchLabels.append("'").append(b.replace("'", "\\'")).append("',");
            branchTotalData.append(branchTotal.get(b)).append(",");
            branchSelectedData.append(branchSelected.getOrDefault(b, 0)).append(",");
        }

        // Set attributes
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("totalCompanies", totalCompanies);
        request.setAttribute("totalJobs", totalJobs);
        request.setAttribute("totalApplications", totalApplications);
        request.setAttribute("totalInterviews", totalInterviews);
        request.setAttribute("pending", pending);
        request.setAttribute("shortlisted", shortlisted);
        request.setAttribute("selected", selected);
        request.setAttribute("rejected", rejected);
        request.setAttribute("topCompanies", topCompanies);
        request.setAttribute("branchLabels", branchLabels.toString());
        request.setAttribute("branchTotalData", branchTotalData.toString());
        request.setAttribute("branchSelectedData", branchSelectedData.toString());
        request.setAttribute("recentApps", recentApps);
        request.setAttribute("allStudents", students);
        request.setAttribute("allJobs", jobs);
        request.setAttribute("allCompanies", companies);

        request.getRequestDispatcher("admin-reports.jsp").forward(request, response);
    }
}