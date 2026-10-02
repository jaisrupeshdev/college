package com.placement.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

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

@WebServlet("/MyApplicationsServlet")
public class MyApplicationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("studentId");

        ApplicationDAO appDAO = new ApplicationDAO();
        JobDAO jobDAO = new JobDAO();

        List<Application> applications = appDAO.getApplicationsByStudent(studentId);
        List<Job> appliedJobs = new ArrayList<>();

        for (Application a : applications) {
            for (Job j : jobDAO.getAllJobs()) {
                if (j.getId() == a.getJobId()) {
                    appliedJobs.add(j);
                    break;
                }
            }
        }

        request.setAttribute("applicationsList", applications);
        request.setAttribute("appliedJobsList", appliedJobs);
        request.getRequestDispatcher("my-applications.jsp").forward(request, response);
    }
}