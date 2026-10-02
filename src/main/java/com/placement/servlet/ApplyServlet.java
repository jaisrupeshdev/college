package com.placement.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.CompanyDAO;
import com.placement.dao.JobDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Company;
import com.placement.model.Job;
import com.placement.model.Student;
import com.placement.utils.MailUtil;

@WebServlet("/ApplyServlet")
public class ApplyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("studentId");
        int jobId = Integer.parseInt(request.getParameter("jobId"));

        ApplicationDAO dao = new ApplicationDAO();

        if (dao.hasApplied(studentId, jobId)) {
            response.sendRedirect("JobsServlet?msg=already");
            return;
        }

        dao.applyForJob(studentId, jobId);

        // Job aur Student details laao
        Job targetJob = null;
        for (Job j : new JobDAO().getAllJobs()) {
            if (j.getId() == jobId) { targetJob = j; break; }
        }
        Student student = new StudentDAO().getStudentById(studentId);

        if (targetJob == null || student == null) {
            response.sendRedirect("JobsServlet?msg=success");
            return;
        }

        Company company = null;
        for (Company c : new CompanyDAO().getAllCompanies()) {
            if (c.getId() == targetJob.getCompanyId()) { company = c; break; }
        }
        String companyName = company != null ? company.getName() : "Company";

        // ========== 📧 EMAIL 1: COMPANY KO (Applicant details) ==========
        try {
            if (company != null && company.getEmail() != null && !company.getEmail().isEmpty()) {
                String skillsStr = student.getSkills() != null ? String.join(", ", student.getSkills()) : "";
                String subject = "New Application: " + student.getName() + " applied for " + targetJob.getTitle();
                String body = MailUtil.applicationReceivedTemplate(
                    company.getName(), student.getName(), student.getRollNo(),
                    student.getEmail(), student.getCgpa(), student.getBranch(),
                    skillsStr, targetJob.getTitle(), student.getResumePath()
                );
                MailUtil.sendEmail(company.getEmail(), subject, body);
                System.out.println("📧 Application email sent to company: " + company.getEmail());
            }
        } catch (Exception e) {
            System.out.println("❌ Company email failed: " + e.getMessage());
        }

        // ========== 📧 EMAIL 2: STUDENT KO (Confirmation) ==========
        try {
            String subject = "✅ Application Submitted: " + targetJob.getTitle();
            String body = MailUtil.applicationConfirmationTemplate(student.getName(), targetJob.getTitle(), companyName);
            MailUtil.sendEmail(student.getEmail(), subject, body);
            System.out.println("📧 Confirmation email sent to student: " + student.getEmail());
        } catch (Exception e) {
            System.out.println("❌ Student confirmation email failed: " + e.getMessage());
        }

        response.sendRedirect("JobsServlet?msg=success");
    }
}