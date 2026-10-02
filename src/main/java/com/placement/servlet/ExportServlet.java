package com.placement.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.JobDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Job;
import com.placement.model.Student;
import com.placement.service.ShortlistService;

@WebServlet("/ExportServlet")
public class ExportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String type = request.getParameter("type");

        if ("students".equals(type)) {
            exportStudents(response);
        } else if ("shortlist".equals(type)) {
            String jobIdStr = request.getParameter("jobId");
            if (jobIdStr != null && !jobIdStr.isEmpty()) {
                exportShortlist(Integer.parseInt(jobIdStr), response);
            }
        }
    }

    // Students CSV
    private void exportStudents(HttpServletResponse response) throws IOException {
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"students.csv\"");

        PrintWriter out = response.getWriter();
        out.println("ID,Name,Roll No,Email,CGPA,Branch,Skills");

        StudentDAO dao = new StudentDAO();
        List<Student> students = dao.getAllStudents();

        for (Student s : students) {
            String skills = s.getSkills() != null ? String.join("; ", s.getSkills()) : "";
            out.println(
                s.getId() + "," +
                escapeCsv(s.getName()) + "," +
                escapeCsv(s.getRollNo()) + "," +
                escapeCsv(s.getEmail()) + "," +
                s.getCgpa() + "," +
                escapeCsv(s.getBranch()) + "," +
                escapeCsv(skills)
            );
        }
        out.flush();
    }

    // Shortlist CSV
    private void exportShortlist(int jobId, HttpServletResponse response) throws IOException {
        JobDAO jobDAO = new JobDAO();
        Job selectedJob = null;
        for (Job j : jobDAO.getAllJobs()) {
            if (j.getId() == jobId) { selectedJob = j; break; }
        }

        if (selectedJob == null) {
            response.sendRedirect("ShortlistServlet");
            return;
        }

        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", 
            "attachment; filename=\"shortlist_" + selectedJob.getTitle().replaceAll("\\s+", "_") + ".csv\"");

        PrintWriter out = response.getWriter();
        out.println("Shortlist for: " + escapeCsv(selectedJob.getTitle()));
        out.println("Min CGPA: " + selectedJob.getMinCgpa());
        out.println("Eligible Branches: " + escapeCsv(String.join("; ", selectedJob.getEligibleBranches())));
        out.println("Required Skills: " + escapeCsv(String.join("; ", selectedJob.getRequiredSkills())));
        out.println();
        out.println("Rank,ID,Name,Roll No,Email,CGPA,Branch,Skills");

        ShortlistService service = new ShortlistService();
        List<Student> shortlisted = service.getShortlistedStudents(selectedJob);

        int rank = 1;
        for (Student s : shortlisted) {
            String skills = s.getSkills() != null ? String.join("; ", s.getSkills()) : "";
            out.println(
                rank++ + "," +
                s.getId() + "," +
                escapeCsv(s.getName()) + "," +
                escapeCsv(s.getRollNo()) + "," +
                escapeCsv(s.getEmail()) + "," +
                s.getCgpa() + "," +
                escapeCsv(s.getBranch()) + "," +
                escapeCsv(skills)
            );
        }
        out.flush();
    }

    // CSV escape (quotes aur commas handle karne ke liye)
    private String escapeCsv(String value) {
        if (value == null) return "";
        if (value.contains(",") || value.contains("\"") || value.contains("\n")) {
            return "\"" + value.replace("\"", "\"\"") + "\"";
        }
        return value;
    }
}