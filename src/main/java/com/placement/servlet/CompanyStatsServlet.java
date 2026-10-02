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
import com.placement.model.Application;
import com.placement.model.Company;
import com.placement.model.Job;

@WebServlet("/CompanyStatsServlet")
public class CompanyStatsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Company> companies = new CompanyDAO().getAllCompanies();
        List<Job> allJobs = new JobDAO().getAllJobs();
        List<Application> allApps = new ApplicationDAO().getAllApplications();

        // Har company ke liye stats calculate karo
        List<Map<String, Object>> statsList = new ArrayList<>();
        StringBuilder chartLabels = new StringBuilder();
        StringBuilder chartData = new StringBuilder();

        for (Company c : companies) {
            Map<String, Object> stats = new HashMap<>();
            stats.put("company", c);

            int jobCount = 0;
            List<Integer> jobIds = new ArrayList<>();
            for (Job j : allJobs) {
                if (j.getCompanyId() == c.getId()) {
                    jobCount++;
                    jobIds.add(j.getId());
                }
            }

            int appCount = 0, shortlistedCount = 0, selectedCount = 0, rejectedCount = 0;
            for (Application a : allApps) {
                if (jobIds.contains(a.getJobId())) {
                    appCount++;
                    if ("SHORTLISTED".equals(a.getStatus())) shortlistedCount++;
                    else if ("SELECTED".equals(a.getStatus())) selectedCount++;
                    else if ("REJECTED".equals(a.getStatus())) rejectedCount++;
                }
            }

            stats.put("jobCount", jobCount);
            stats.put("appCount", appCount);
            stats.put("shortlistedCount", shortlistedCount);
            stats.put("selectedCount", selectedCount);
            stats.put("rejectedCount", rejectedCount);

            statsList.add(stats);

            // Chart ke liye
            chartLabels.append("'").append(c.getName().replace("'", "\\'")).append("',");
            chartData.append(appCount).append(",");
        }

        request.setAttribute("statsList", statsList);
        request.setAttribute("chartLabels", chartLabels.toString());
        request.setAttribute("chartData", chartData.toString());
        request.getRequestDispatcher("company-stats.jsp").forward(request, response);
    }
}