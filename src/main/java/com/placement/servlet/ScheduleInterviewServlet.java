package com.placement.servlet;

import java.io.IOException;
import java.time.LocalDate;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.InterviewDAO;
import com.placement.dao.JobDAO;
import com.placement.dao.NotificationDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Application;
import com.placement.model.Interview;
import com.placement.model.Job;
import com.placement.model.Student;
import com.placement.utils.MailUtil;

@WebServlet("/ScheduleInterviewServlet")
public class ScheduleInterviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.getRequestDispatcher("schedule-interview.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int applicationId = Integer.parseInt(request.getParameter("applicationId"));
        String dateStr = request.getParameter("interviewDate");
        String time = request.getParameter("interviewTime");
        String mode = request.getParameter("mode");
        String location = request.getParameter("location");
        String notes = request.getParameter("notes");

        // Application details laao
        Application target = null;
        for (Application a : new ApplicationDAO().getAllApplications()) {
            if (a.getId() == applicationId) { target = a; break; }
        }

        if (target == null) {
            response.sendRedirect("AdminApplicationsServlet");
            return;
        }

        LocalDate date = LocalDate.parse(dateStr);
        Interview i = new Interview();
        i.setApplicationId(applicationId);
        i.setStudentId(target.getStudentId());
        i.setJobId(target.getJobId());
        i.setInterviewDate(date);
        i.setInterviewTime(time);
        i.setMode(mode);
        i.setLocation(location);
        i.setNotes(notes);

        new InterviewDAO().addInterview(i);

        // Email + Notification bhejo
        try {
            Student s = new StudentDAO().getStudentById(target.getStudentId());
            String jobTitle = "a job";
            for (Job j : new JobDAO().getAllJobs()) {
                if (j.getId() == target.getJobId()) { jobTitle = j.getTitle(); break; }
            }

            if (s != null) {
                // In-app notification
                String msg = "Interview scheduled for '" + jobTitle + "' on " + date + " at " + time;
                new NotificationDAO().addNotification(s.getId(), msg);

                // Email
                String subject = "Interview Scheduled: " + jobTitle;
                String body = MailUtil.interviewTemplate(s.getName(), jobTitle, date.toString(), time, mode, location, notes);
                MailUtil.sendEmail(s.getEmail(), subject, body);
                System.out.println("📧 Interview email sent to: " + s.getEmail());
            }
        } catch (Exception e) {
            System.out.println("❌ Interview email failed: " + e.getMessage());
        }

        response.sendRedirect("AdminInterviewsServlet");
    }
}