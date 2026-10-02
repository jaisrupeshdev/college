package com.placement.servlet;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.CompanyDAO;
import com.placement.dao.JobDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Company;
import com.placement.model.Job;
import com.placement.model.Student;
import com.placement.utils.MailUtil;

@WebServlet("/AddJobServlet")
public class AddJobServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int companyId = Integer.parseInt(request.getParameter("companyId"));
        String title = request.getParameter("title");
        double minCgpa = Double.parseDouble(request.getParameter("minCgpa"));
        String branchesInput = request.getParameter("branches");
        String skillsInput = request.getParameter("skills");

        List<String> branches = Arrays.asList(branchesInput.split(","));
        List<String> skills = Arrays.asList(skillsInput.split(","));

        Job job = new Job(companyId, title, minCgpa, branches, skills);

        JobDAO dao = new JobDAO();
        dao.addJob(job);

        // Company details laao
        Company company = null;
        for (Company c : new CompanyDAO().getAllCompanies()) {
            if (c.getId() == companyId) { company = c; break; }
        }
        String companyName = company != null ? company.getName() : "Company";
        String companyEmail = company != null ? company.getEmail() : null;

        // ========== 📧 EMAIL 1: COMPANY KO NOTIFICATION ==========
        try {
            if (companyEmail != null && !companyEmail.isEmpty()) {
                String subject = "📢 Job Posted: " + title;
                String body = "<div style='font-family:Inter,Arial,sans-serif;max-width:600px;margin:auto;border:1px solid #e1e5ee;border-radius:12px;overflow:hidden;'>" +
                             "<div style='background:linear-gradient(135deg,#4facfe,#00f2fe);padding:30px;text-align:center;'>" +
                             "<h1 style='color:white;margin:0;'>Job Posted Successfully</h1></div>" +
                             "<div style='padding:30px;'>" +
                             "<h2 style='color:#1a1a2e;'>Hello " + companyName + ",</h2>" +
                             "<p style='color:#4a5578;'>A new job has been posted on your behalf:</p>" +
                             "<div style='background:#f8f9fa;padding:20px;border-radius:10px;border-left:5px solid #4facfe;margin:20px 0;'>" +
                             "<p style='margin:0;color:#8892b0;font-size:13px;'>JOB TITLE</p>" +
                             "<p style='margin:5px 0 0;color:#1a1a2e;font-size:20px;font-weight:700;'>" + title + "</p>" +
                             "<p style='margin:10px 0 0;color:#4a5578;font-size:13px;'>Min CGPA: " + minCgpa + "</p>" +
                             "<p style='margin:5px 0 0;color:#4a5578;font-size:13px;'>Branches: " + branchesInput + "</p>" +
                             "<p style='margin:5px 0 0;color:#4a5578;font-size:13px;'>Skills: " + skillsInput + "</p>" +
                             "</div></div></div>";
                MailUtil.sendEmail(companyEmail, subject, body);
                System.out.println("📧 Job notification sent to company: " + companyEmail);
            }
        } catch (Exception e) {
            System.out.println("❌ Company notification failed: " + e.getMessage());
        }

        // ========== 📧 EMAIL 2: SAARE ELIGIBLE STUDENTS KO ==========
        try {
            List<Student> allStudents = new StudentDAO().getAllStudents();
            int count = 0;
            for (Student s : allStudents) {
                boolean cgpaOK = s.getCgpa() >= minCgpa;
                boolean branchOK = branches.stream().anyMatch(b -> b.trim().equalsIgnoreCase(s.getBranch()));
                boolean skillsOK = s.getSkills() != null && s.getSkills().containsAll(
                    skills.stream().map(String::trim).collect(java.util.stream.Collectors.toList()));

                if (cgpaOK && branchOK && skillsOK) {
                    String subject = "💼 New Job Opening: " + title + " at " + companyName;
                    String body = MailUtil.newJobTemplate(s.getName(), title, companyName, minCgpa, branchesInput, skillsInput);
                    MailUtil.sendEmail(s.getEmail(), subject, body);
                    count++;
                    System.out.println("📧 Job notification sent to: " + s.getEmail());
                }
            }
            System.out.println("✅ Total " + count + " eligible students ko job notification bheji.");
        } catch (Exception e) {
            System.out.println("❌ Student notifications failed: " + e.getMessage());
        }

        response.sendRedirect("JobsServlet");
    }
}