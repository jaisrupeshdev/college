package com.placement.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.JobDAO;
import com.placement.dao.NotificationDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Application;
import com.placement.model.Job;
import com.placement.model.Student;
import com.placement.utils.MailUtil;

@WebServlet("/UpdateStatusServlet")
public class UpdateStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 🔥 ONLY COMPANY CAN UPDATE STATUS (Real-world rule)
        String role = (String) session.getAttribute("role");
        if (!"company".equals(role)) {
            System.out.println("❌ Blocked: Only companies can update application status");
            response.sendRedirect("login.jsp");
            return;
        }

        int applicationId = Integer.parseInt(request.getParameter("applicationId"));
        String newStatus = request.getParameter("status");

        ApplicationDAO appDAO = new ApplicationDAO();

        // Application dhundo
        Application target = null;
        for (Application a : appDAO.getAllApplications()) {
            if (a.getId() == applicationId) { target = a; break; }
        }

        appDAO.updateStatus(applicationId, newStatus);

        if (target != null) {
            // Job title dhundo
            String jobTitle = "a job";
            JobDAO jobDAO = new JobDAO();
            for (Job j : jobDAO.getAllJobs()) {
                if (j.getId() == target.getJobId()) { jobTitle = j.getTitle(); break; }
            }

            // Student dhundo
            Student student = new StudentDAO().getStudentById(target.getStudentId());

            if (student != null) {
                // In-app notification
                String message = "Your application for '" + jobTitle + "' is now " + newStatus + ".";
                new NotificationDAO().addNotification(target.getStudentId(), message);

                // Email notification
                try {
                    String subject = "Application Update: " + newStatus + " — " + jobTitle;
                    String body = MailUtil.statusUpdateTemplate(student.getName(), jobTitle, newStatus);
                    MailUtil.sendEmail(student.getEmail(), subject, body);
                    System.out.println("📧 Status update email sent to: " + student.getEmail());
                } catch (Exception e) {
                    System.out.println("❌ Email failed: " + e.getMessage());
                }
            }
        }

        // Company ke applications page pe redirect
        response.sendRedirect("CompanyApplicationsServlet");
    }
}