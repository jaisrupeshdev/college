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

import com.placement.dao.InterviewDAO;
import com.placement.dao.JobDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Interview;
import com.placement.model.Job;
import com.placement.model.Student;

@WebServlet("/CompanyInterviewsServlet")
public class CompanyInterviewsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"company".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int companyId = (Integer) session.getAttribute("companyId");

        // Company jobs
        List<Job> myJobs = new ArrayList<>();
        for (Job j : new JobDAO().getAllJobs()) {
            if (j.getCompanyId() == companyId) myJobs.add(j);
        }
        List<Integer> jobIds = new ArrayList<>();
        for (Job j : myJobs) jobIds.add(j.getId());

        // Company interviews
        List<Interview> interviews = new ArrayList<>();
        for (Interview i : new InterviewDAO().getAllInterviews()) {
            if (jobIds.contains(i.getJobId())) interviews.add(i);
        }

        List<Student> students = new StudentDAO().getAllStudents();

        request.setAttribute("interviewsList", interviews);
        request.setAttribute("myJobs", myJobs);
        request.setAttribute("studentsList", students);
        request.getRequestDispatcher("company-interviews.jsp").forward(request, response);
    }
}