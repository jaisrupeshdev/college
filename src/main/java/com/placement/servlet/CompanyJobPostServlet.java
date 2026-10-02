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

@WebServlet("/CompanyJobPostServlet")
public class CompanyJobPostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"company".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.getRequestDispatcher("company-add-job.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"company".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int companyId = (Integer) session.getAttribute("companyId");
        String title = request.getParameter("title");
        double minCgpa = Double.parseDouble(request.getParameter("minCgpa"));
        String branchesInput = request.getParameter("branches");
        String skillsInput = request.getParameter("skills");

        List<String> branches = Arrays.asList(branchesInput.split(","));
        List<String> skills = Arrays.asList(skillsInput.split(","));

        Job job = new Job(companyId, title, minCgpa, branches, skills);
        new JobDAO().addJob(job);

        // Company details laao
        Company company = null;
        for (Company c : new CompanyDAO().getAllCompanies()) {
            if (c.getId() == companyId) { company = c; break; }
        }

        String companyName = company != null ? company.getName() : "Company";

        // ========== EMAIL 1: COMPANY KO CONFIRMATION ==========
        try {
            if (company != null && company.getEmail() != null && !company.getEmail().isEmpty()) {
                String subject = "Job Posted Successfully: " + title;
                String body = MailUtil.jobPostedCompanyTemplate(
                    company.getName(), title, minCgpa, branchesInput, skillsInput
                );
                MailUtil.sendEmail(company.getEmail(), subject, body);
                System.out.println("📧 Job confirmation sent to company: " + company.getEmail());
            }
        } catch (Exception e) {
            System.out.println("❌ Company job email failed: " + e.getMessage());
        }

        // ========== EMAIL 2: SAARE ELIGIBLE STUDENTS KO ==========
        try {
            List<Student> allStudents = new StudentDAO().getAllStudents();
            int count = 0;

            for (Student s : allStudents) {
                boolean cgpaOK = s.getCgpa() >= minCgpa;
                boolean branchOK = branches.stream().anyMatch(b -> b.trim().equalsIgnoreCase(s.getBranch()));
                boolean skillsOK = s.getSkills() != null && s.getSkills().containsAll(
                    skills.stream().map(String::trim).collect(java.util.stream.Collectors.toList()));

                if (cgpaOK && branchOK && skillsOK) {
                    String subject = "New Job Opening: " + title + " at " + companyName;
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

        response.sendRedirect("CompanyJobsServlet");
    }
}