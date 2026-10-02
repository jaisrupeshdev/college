package com.placement.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.CompanyDAO;
import com.placement.dao.JobDAO;
import com.placement.dao.StudentDAO;

@WebServlet("/DeleteServlet")
public class DeleteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String type = request.getParameter("type");
        int id = Integer.parseInt(request.getParameter("id"));

        if ("student".equals(type)) {
            new StudentDAO().deleteStudent(id);
            response.sendRedirect("StudentsServlet");
        } else if ("company".equals(type)) {
            new CompanyDAO().deleteCompany(id);
            response.sendRedirect("CompaniesServlet");
        } else if ("job".equals(type)) {
            new JobDAO().deleteJob(id);
            response.sendRedirect("JobsServlet");
        } else {
            response.sendRedirect("dashboard.jsp");
        }
    }
}