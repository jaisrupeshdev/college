package com.placement.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.CompanyDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Company;
import com.placement.model.Student;
import com.placement.service.LoginService;
import com.placement.utils.MailUtil;

@WebServlet("/AddCompanyServlet")
public class AddCompanyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 🔥 APNA ADMIN EMAIL YAHAN DAALO
    private static final String ADMIN_EMAIL = "jaisrupesh35@gmail.com";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String name = request.getParameter("name");
        String industry = request.getParameter("industry");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Password hash karo
        String hashedPassword = LoginService.hashPassword(password);

        Company company = new Company(name, industry);
        company.setEmail(email);
        company.setPassword(hashedPassword);

        CompanyDAO dao = new CompanyDAO();
        dao.addCompanyWithLogin(company);

        System.out.println("✅ Company added: " + name);

        // ========== 📧 EMAIL 1: COMPANY KO WELCOME ==========
        try {
            String subject = "Welcome to Placement Portal, " + name + "!";
            String body = MailUtil.companyWelcomeTemplate(name, email, password);
            MailUtil.sendEmail(email, subject, body);
            System.out.println("📧 Company welcome email sent to: " + email);
        } catch (Exception e) {
            System.out.println("❌ Company welcome email failed: " + e.getMessage());
        }

        // ========== 📧 EMAIL 2: SAARE STUDENTS KO ==========
        try {
            List<Student> students = new StudentDAO().getAllStudents();
            int count = 0;
            for (Student s : students) {
                if (s.getEmail() == null || s.getEmail().trim().isEmpty()) continue;
                String subject = "New Company Added: " + name;
                String body = MailUtil.newCompanyStudentTemplate(s.getName(), name, industry);
                MailUtil.sendEmail(s.getEmail(), subject, body);
                count++;
            }
            System.out.println("📧 " + count + " students ko new company notification bheji.");
        } catch (Exception e) {
            System.out.println("❌ Student notifications failed: " + e.getMessage());
        }

        // ========== 📧 EMAIL 3: ADMIN KO NOTIFICATION ==========
        try {
            String subject = "New Company Registered: " + name;
            String body = MailUtil.newCompanyAdminTemplate(name, industry, email);
            MailUtil.sendEmail(ADMIN_EMAIL, subject, body);
            System.out.println("📧 Admin notified about new company.");
        } catch (Exception e) {
            System.out.println("❌ Admin notification failed: " + e.getMessage());
        }

        response.sendRedirect("CompaniesServlet");
    }
}