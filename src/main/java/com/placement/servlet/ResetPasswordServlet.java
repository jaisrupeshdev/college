package com.placement.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.StudentDAO;
import com.placement.service.LoginService;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("resetEmail") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String email = (String) session.getAttribute("resetEmail");
        String otp = request.getParameter("otp");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "❌ Passwords match nahi kar rahe!");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            return;
        }

        // Password hash karo
        String hashedPassword = LoginService.hashPassword(newPassword);

        StudentDAO dao = new StudentDAO();
        boolean success = dao.resetPassword(email, otp, hashedPassword);

        if (success) {
            session.removeAttribute("resetEmail");
            request.setAttribute("success", "✅ Password reset successful! Login karo.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "❌ Invalid ya expired OTP! Dobara try karo.");
            request.getRequestDispatcher("reset-password.jsp").forward(request, response);
        }
    }
}