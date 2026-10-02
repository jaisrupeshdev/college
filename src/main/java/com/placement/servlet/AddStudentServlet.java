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

import com.placement.dao.StudentDAO;
import com.placement.model.Student;
import com.placement.service.LoginService;
import com.placement.utils.MailUtil;

@WebServlet("/AddStudentServlet")
public class AddStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String ADMIN_EMAIL = "tumhara_admin_email@gmail.com"; // 🔥 APNA ADMIN EMAIL

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String name = request.getParameter("name");
        String rollNo = request.getParameter("rollNo");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        double cgpa = Double.parseDouble(request.getParameter("cgpa"));
        String branch = request.getParameter("branch");
        String skillsInput = request.getParameter("skills");

        List<String> skills = Arrays.asList(skillsInput.split(","));

        String hashedPassword = LoginService.hashPassword(password);

        Student student = new Student(name, rollNo, email, hashedPassword, cgpa, branch, skills);

        StudentDAO dao = new StudentDAO();
        dao.addStudent(student);

        // ========== 📧 EMAIL 1: STUDENT KO WELCOME ==========
        try {
            String subject = "Welcome to Placement Portal, " + name + "!";
            String body = MailUtil.welcomeTemplate(name);
            MailUtil.sendEmail(email, subject, body);
            System.out.println("📧 Welcome email sent to: " + email);
        } catch (Exception e) {
            System.out.println("❌ Welcome email failed: " + e.getMessage());
        }

        // ========== 📧 EMAIL 2: ADMIN KO NOTIFICATION ==========
        try {
            String adminSubject = "🎓 New Student Registered: " + name;
            String adminBody = MailUtil.newStudentAdminTemplate(name, rollNo, email, cgpa, branch, skillsInput);
            MailUtil.sendEmail(ADMIN_EMAIL, adminSubject, adminBody);
            System.out.println("📧 Admin notified about new student.");
        } catch (Exception e) {
            System.out.println("❌ Admin notification failed: " + e.getMessage());
        }

        response.sendRedirect("StudentsServlet");
    }
}