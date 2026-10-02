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
import com.placement.dao.JobDAO;
import com.placement.model.Application;
import com.placement.model.Job;

@WebServlet("/CompanyDashboardServlet")
public class CompanyDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"company".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int companyId = (Integer) session.getAttribute("companyId");
        JobDAO jobDAO = new JobDAO();
        ApplicationDAO appDAO = new ApplicationDAO();

        // Company ki jobs
        List<Job> myJobs = new ArrayList<>();
        for (Job j : jobDAO.getAllJobs()) {
            if (j.getCompanyId() == companyId) myJobs.add(j);
        }

        // Job IDs
        List<Integer> jobIds = new ArrayList<>();
        for (Job j : myJobs) jobIds.add(j.getId());

        // Applications for company's jobs
        List<Application> companyApps = new ArrayList<>();
        for (Application a : appDAO.getAllApplications()) {
            if (jobIds.contains(a.getJobId())) companyApps.add(a);
        }

        // Stats
        int pendingCount = 0, shortlistedCount = 0, selectedCount = 0, rejectedCount = 0;
        for (Application a : companyApps) {
            if ("PENDING".equals(a.getStatus())) pendingCount++;
            else if ("SHORTLISTED".equals(a.getStatus())) shortlistedCount++;
            else if ("SELECTED".equals(a.getStatus())) selectedCount++;
            else if ("REJECTED".equals(a.getStatus())) rejectedCount++;
        }

        // Applications per job (for chart)
        Map<String, Integer> appsPerJob = new HashMap<>();
        for (Job j : myJobs) {
            int count = 0;
            for (Application a : companyApps) {
                if (a.getJobId() == j.getId()) count++;
            }
            appsPerJob.put(j.getTitle(), count);
        }

        request.setAttribute("myJobs", myJobs);
        request.setAttribute("jobCount", myJobs.size());
        request.setAttribute("appCount", companyApps.size());
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("shortlistedCount", shortlistedCount);
        request.setAttribute("selectedCount", selectedCount);
        request.setAttribute("rejectedCount", rejectedCount);
        request.setAttribute("appsPerJob", appsPerJob);

        request.getRequestDispatcher("company-dashboard.jsp").forward(request, response);
    }
}