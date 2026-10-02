package com.placement.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.CompanyDAO;
import com.placement.model.Company;
import com.placement.service.LoginService;

@WebServlet("/CompanyProfileServlet")
public class CompanyProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"company".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int companyId = (Integer) session.getAttribute("companyId");
        Company company = null;
        for (Company c : new CompanyDAO().getAllCompanies()) {
            if (c.getId() == companyId) { company = c; break; }
        }

        request.setAttribute("company", company);
        request.getRequestDispatcher("company-profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"company".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int companyId = (Integer) session.getAttribute("companyId");
        CompanyDAO dao = new CompanyDAO();
        Company company = null;
        for (Company c : dao.getAllCompanies()) {
            if (c.getId() == companyId) { company = c; break; }
        }

        if (company == null) {
            response.sendRedirect("CompanyProfileServlet");
            return;
        }

        String newName = request.getParameter("name");
        String newIndustry = request.getParameter("industry");
        String newPassword = request.getParameter("password");

        company.setName(newName);
        company.setIndustry(newIndustry);

        if (newPassword != null && !newPassword.trim().isEmpty()) {
            company.setPassword(LoginService.hashPassword(newPassword.trim()));
        }

        dao.updateCompany(company);

        session.setAttribute("companyName", newName);

        response.sendRedirect("CompanyProfileServlet?msg=updated");
    }
}