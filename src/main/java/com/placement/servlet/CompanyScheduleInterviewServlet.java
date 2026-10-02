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

@WebServlet("/CompanyScheduleInterviewServlet")
public class CompanyScheduleInterviewServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"company".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.getRequestDispatcher("company-schedule-interview.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"company".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int companyId = (Integer) session.getAttribute("companyId");
        int applicationId = Integer.parseInt(request.getParameter("applicationId"));
        String dateStr = request.getParameter("interviewDate");
        String time = request.getParameter("interviewTime");
        String mode = request.getParameter("mode");
        String location = request.getParameter("location");
        String notes = request.getParameter("notes");

        // Application dhundo + verify karo ki company ki hai
        Application target = null;
        for (Application a : new ApplicationDAO().getAllApplications()) {
            if (a.getId() == applicationId) { target = a; break; }
        }

        if (target == null) {
            response.sendRedirect("CompanyApplicationsServlet");
            return;
        }

        // Verify karo job company ki hai
        boolean isCompanyJob = false;
        String jobTitle = "a job";
        for (Job j : new JobDAO().getAllJobs()) {
            if (j.getId() == target.getJobId() && j.getCompanyId() == companyId) {
                isCompanyJob = true;
                jobTitle = j.getTitle();
                break;
            }
        }

        if (!isCompanyJob) {
            response.sendRedirect("CompanyApplicationsServlet");
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

        // Email + Notification
        try {
            Student s = new StudentDAO().getStudentById(target.getStudentId());
            if (s != null) {
                String msg = "Interview scheduled for '" + jobTitle + "' on " + date + " at " + time;
                new NotificationDAO().addNotification(s.getId(), msg);

                String subject = "Interview Scheduled: " + jobTitle;
                String body = MailUtil.interviewTemplate(s.getName(), jobTitle, date.toString(), time, mode, location, notes);
                MailUtil.sendEmail(s.getEmail(), subject, body);
                System.out.println("📧 Interview email sent to: " + s.getEmail());
            }
        } catch (Exception e) {
            System.out.println("❌ Interview email failed: " + e.getMessage());
        }

        response.sendRedirect("CompanyInterviewsServlet");
    }
}