package com.placement.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.model.Company;
import com.placement.model.Student;
import com.placement.service.LoginService;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String role = request.getParameter("role");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        LoginService loginService = new LoginService();
        HttpSession session = request.getSession();

        if ("admin".equals(role)) {
            if (loginService.adminLogin(username, password)) {
                session.setAttribute("role", "admin");
                session.setAttribute("username", username);
                response.sendRedirect("DashboardServlet");
            } else {
                request.setAttribute("error", "❌ Invalid admin credentials!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else if ("student".equals(role)) {
            Student student = loginService.studentLogin(username, password);
            if (student != null) {
                session.setAttribute("role", "student");
                session.setAttribute("studentId", student.getId());
                session.setAttribute("studentName", student.getName());
                session.setAttribute("studentEmail", student.getEmail());
                response.sendRedirect("DashboardServlet");
            } else {
                request.setAttribute("error", "❌ Invalid email or password!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else if ("company".equals(role)) {
            Company company = loginService.companyLogin(username, password);
            if (company != null) {
                session.setAttribute("role", "company");
                session.setAttribute("companyId", company.getId());
                session.setAttribute("companyName", company.getName());
                response.sendRedirect("CompanyDashboardServlet");
            } else {
                request.setAttribute("error", "❌ Invalid company credentials!");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "❌ Invalid role!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}