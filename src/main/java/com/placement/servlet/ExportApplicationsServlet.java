package com.placement.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.JobDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Application;
import com.placement.model.Job;
import com.placement.model.Student;

@WebServlet("/ExportApplicationsServlet")
public class ExportApplicationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"company".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int companyId = (Integer) session.getAttribute("companyId");

        List<Job> myJobs = new ArrayList<>();
        for (Job j : new JobDAO().getAllJobs()) {
            if (j.getCompanyId() == companyId) myJobs.add(j);
        }

        List<Integer> jobIds = new ArrayList<>();
        for (Job j : myJobs) jobIds.add(j.getId());

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"applications.csv\"");

        PrintWriter out = response.getWriter();
        out.println("ID,Student Name,Roll No,Email,CGPA,Branch,Job Title,Status,Applied Date");

        List<Student> allStudents = new StudentDAO().getAllStudents();

        for (Application a : new ApplicationDAO().getAllApplications()) {
            if (!jobIds.contains(a.getJobId())) continue;

            String name = "", roll = "", email = "", branch = "";
            double cgpa = 0;
            for (Student s : allStudents) {
                if (s.getId() == a.getStudentId()) {
                    name = s.getName();
                    roll = s.getRollNo();
                    email = s.getEmail();
                    cgpa = s.getCgpa();
                    branch = s.getBranch();
                    break;
                }
            }
            String jobTitle = "";
            for (Job j : myJobs) if (j.getId() == a.getJobId()) { jobTitle = j.getTitle(); break; }

            out.println(a.getId() + "," + escape(name) + "," + escape(roll) + "," + escape(email)
                + "," + cgpa + "," + escape(branch) + "," + escape(jobTitle) + ","
                + a.getStatus() + "," + (a.getAppliedDate() != null ? a.getAppliedDate() : ""));
        }
        out.flush();
    }

    private String escape(String s) {
        if (s == null) return "";
        if (s.contains(",") || s.contains("\"")) return "\"" + s.replace("\"", "\"\"") + "\"";
        return s;
    }
}