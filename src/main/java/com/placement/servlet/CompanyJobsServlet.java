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

@WebServlet("/CompanyJobsServlet")
public class CompanyJobsServlet extends HttpServlet {
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

        // Har job ke liye application count
        Map<Integer, Integer> appCountPerJob = new HashMap<>();
        for (Job j : myJobs) {
            int count = 0;
            for (Application a : appDAO.getAllApplications()) {
                if (a.getJobId() == j.getId()) count++;
            }
            appCountPerJob.put(j.getId(), count);
        }

        request.setAttribute("myJobs", myJobs);
        request.setAttribute("appCountPerJob", appCountPerJob);
        request.getRequestDispatcher("company-jobs.jsp").forward(request, response);
    }
}