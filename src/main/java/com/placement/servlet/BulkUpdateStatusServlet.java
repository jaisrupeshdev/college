package com.placement.servlet;

import java.io.IOException;
import java.util.List;

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

@WebServlet("/BulkUpdateStatusServlet")
public class BulkUpdateStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"company".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String[] ids = request.getParameterValues("applicationIds");
        String newStatus = request.getParameter("bulkStatus");

        if (ids == null || ids.length == 0 || newStatus == null || newStatus.isEmpty()) {
            response.sendRedirect("CompanyApplicationsServlet");
            return;
        }

        ApplicationDAO appDAO = new ApplicationDAO();
        List<Application> allApps = appDAO.getAllApplications();

        for (String idStr : ids) {
            try {
                int id = Integer.parseInt(idStr);
                Application target = null;
                for (Application a : allApps) if (a.getId() == id) { target = a; break; }
                
                if (target == null) continue;

                appDAO.updateStatus(id, newStatus);

                // Notification + Email
                Student s = new StudentDAO().getStudentById(target.getStudentId());
                String jobTitle = "a job";
                for (Job j : new JobDAO().getAllJobs()) {
                    if (j.getId() == target.getJobId()) { jobTitle = j.getTitle(); break; }
                }

                if (s != null) {
                    new NotificationDAO().addNotification(s.getId(),
                        "Your application for '" + jobTitle + "' is now " + newStatus + ".");
                    try {
                        MailUtil.sendEmail(s.getEmail(),
                            "Application Update: " + newStatus,
                            MailUtil.statusUpdateTemplate(s.getName(), jobTitle, newStatus));
                    } catch (Exception e) {}
                }
            } catch (Exception e) {}
        }

        response.sendRedirect("CompanyApplicationsServlet");
    }
}