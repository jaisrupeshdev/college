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

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("studentId");
        StudentDAO dao = new StudentDAO();
        Student student = dao.getStudentById(studentId);

        request.setAttribute("student", student);
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("studentId");
        StudentDAO dao = new StudentDAO();
        Student student = dao.getStudentById(studentId);

        student.setName(request.getParameter("name"));
        student.setEmail(request.getParameter("email"));
        student.setCgpa(Double.parseDouble(request.getParameter("cgpa")));
        student.setBranch(request.getParameter("branch"));
        
        List<String> skills = Arrays.asList(request.getParameter("skills").split(","));
        student.setSkills(skills);

        // Password handling — sirf tab change karo jab user ne naya type kiya ho
        String newPassword = request.getParameter("password");
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            student.setPassword(LoginService.hashPassword(newPassword.trim()));
        }

        dao.updateStudent(student);

        session.setAttribute("studentName", student.getName());
        session.setAttribute("studentEmail", student.getEmail());

        // 📧 Profile update confirmation email
        try {
            String subject = "Profile Updated Successfully";
            String body = MailUtil.profileUpdatedTemplate(student.getName());
            MailUtil.sendEmail(student.getEmail(), subject, body);
            System.out.println("📧 Profile confirmation sent to: " + student.getEmail());
        } catch (Exception e) {
            System.out.println("❌ Profile email failed: " + e.getMessage());
        }

        response.sendRedirect("ProfileServlet?msg=updated");
    }
}