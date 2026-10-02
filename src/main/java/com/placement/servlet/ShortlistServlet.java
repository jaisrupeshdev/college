package com.placement.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.JobDAO;
import com.placement.model.Job;
import com.placement.model.Student;
import com.placement.service.ShortlistService;

@WebServlet("/ShortlistServlet")
public class ShortlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        JobDAO jobDAO = new JobDAO();
        List<Job> allJobs = jobDAO.getAllJobs();
        request.setAttribute("allJobs", allJobs);

        String jobIdParam = request.getParameter("jobId");
        if (jobIdParam != null && !jobIdParam.isEmpty()) {
            int jobId = Integer.parseInt(jobIdParam);
            Job selectedJob = null;
            for (Job j : allJobs) {
                if (j.getId() == jobId) {
                    selectedJob = j;
                    break;
                }
            }

            if (selectedJob != null) {
                ShortlistService service = new ShortlistService();
                List<Student> shortlisted = service.getShortlistedStudents(selectedJob);
                request.setAttribute("selectedJob", selectedJob);
                request.setAttribute("shortlistedStudents", shortlisted);
            }
        }

        request.getRequestDispatcher("shortlist.jsp").forward(request, response);
    }
}