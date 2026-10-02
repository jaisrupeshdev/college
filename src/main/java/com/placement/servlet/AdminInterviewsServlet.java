package com.placement.servlet;

import java.io.IOException;
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

@WebServlet("/AdminInterviewsServlet")
public class AdminInterviewsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Interview> interviews = new InterviewDAO().getAllInterviews();
        List<Student> students = new StudentDAO().getAllStudents();
        List<Job> jobs = new JobDAO().getAllJobs();

        request.setAttribute("interviewsList", interviews);
        request.setAttribute("studentsList", students);
        request.setAttribute("jobsList", jobs);
        request.getRequestDispatcher("admin-interviews.jsp").forward(request, response);
    }
}