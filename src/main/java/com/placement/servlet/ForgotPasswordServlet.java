package com.placement.servlet;

import java.io.IOException;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.StudentDAO;
import com.placement.utils.MailUtil;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Please enter your email address.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        email = email.trim();
        StudentDAO dao = new StudentDAO();

        // Check karo email exist karta hai ya nahi
        if (!dao.emailExists(email)) {
            request.setAttribute("error", "No account found with this email!");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        // 6-digit OTP generate karo
        String otp = String.format("%06d", new Random().nextInt(1000000));

        // DB me save karo (10 min validity)
        dao.saveResetToken(email, otp);

        // Email bhejo
        try {
            String subject = "Your OTP for Password Reset — Placement Portal";
            String body = MailUtil.otpTemplate("Student", otp);
            MailUtil.sendEmail(email, subject, body);
            System.out.println("📧 OTP sent to: " + email + " | OTP: " + otp);
        } catch (Exception e) {
            System.out.println("❌ OTP email failed: " + e.getMessage());
            request.setAttribute("error", "Failed to send OTP. Please try again.");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            return;
        }

        // Session me email store karo
        HttpSession session = request.getSession();
        session.setAttribute("resetEmail", email);

        response.sendRedirect("reset-password.jsp");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("forgot-password.jsp");
    }
}