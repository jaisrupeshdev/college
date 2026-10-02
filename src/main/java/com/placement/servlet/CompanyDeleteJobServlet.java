package com.placement.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.JobDAO;
import com.placement.model.Job;

@WebServlet("/CompanyDeleteJobServlet")
public class CompanyDeleteJobServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"company".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int companyId = (Integer) session.getAttribute("companyId");
        int jobId = Integer.parseInt(request.getParameter("id"));

        // Verify karo job company ki hai
        JobDAO dao = new JobDAO();
        Job target = null;
        for (Job j : dao.getAllJobs()) {
            if (j.getId() == jobId && j.getCompanyId() == companyId) {
                target = j;
                break;
            }
        }

        if (target != null) {
            dao.deleteJob(jobId);
            System.out.println("✅ Job deleted by company: " + target.getTitle());
        }

        response.sendRedirect("CompanyJobsServlet");
    }
}