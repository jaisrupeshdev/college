package com.placement.servlet;

import java.io.IOException;
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

@WebServlet("/CompanyApplicationsServlet")
public class CompanyApplicationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"company".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int companyId = (Integer) session.getAttribute("companyId");

        // Company jobs
        List<Job> myJobs = new ArrayList<>();
        for (Job j : new JobDAO().getAllJobs()) {
            if (j.getCompanyId() == companyId) myJobs.add(j);
        }

        List<Integer> jobIds = new ArrayList<>();
        for (Job j : myJobs) jobIds.add(j.getId());

        // Filters
        String filterJob = request.getParameter("jobId");
        String filterStatus = request.getParameter("status");
        String filterBranch = request.getParameter("branch");
        String search = request.getParameter("search");
        String minCgpaStr = request.getParameter("minCgpa");
        String sortBy = request.getParameter("sortBy");

        List<Student> allStudents = new StudentDAO().getAllStudents();
        List<Application> applications = new ArrayList<>();

        for (Application a : new ApplicationDAO().getAllApplications()) {
            if (!jobIds.contains(a.getJobId())) continue;

            // Job filter
            if (filterJob != null && !filterJob.isEmpty() && !"all".equals(filterJob)) {
                if (a.getJobId() != Integer.parseInt(filterJob)) continue;
            }
            // Status filter
            if (filterStatus != null && !filterStatus.isEmpty() && !"all".equals(filterStatus)) {
                if (!filterStatus.equals(a.getStatus())) continue;
            }

            Student s = null;
            for (Student st : allStudents) if (st.getId() == a.getStudentId()) { s = st; break; }
            if (s == null) continue;

            // Branch filter
            if (filterBranch != null && !filterBranch.isEmpty() && !"all".equals(filterBranch)) {
                if (!filterBranch.equals(s.getBranch())) continue;
            }
            // Search
            if (search != null && !search.trim().isEmpty()) {
                String q = search.toLowerCase().trim();
                boolean match = s.getName().toLowerCase().contains(q)
                             || (s.getRollNo() != null && s.getRollNo().toLowerCase().contains(q))
                             || (s.getEmail() != null && s.getEmail().toLowerCase().contains(q));
                if (!match) continue;
            }
            // Min CGPA
            if (minCgpaStr != null && !minCgpaStr.trim().isEmpty()) {
                try {
                    double minCgpa = Double.parseDouble(minCgpaStr);
                    if (s.getCgpa() < minCgpa) continue;
                } catch (NumberFormatException e) {}
            }

            applications.add(a);
        }

        // Sorting
        if (sortBy != null && !sortBy.isEmpty()) {
            final List<Student> finalStudents = allStudents;
            if ("cgpa_desc".equals(sortBy)) {
                applications.sort((a1, a2) -> {
                    double c1 = getCgpa(finalStudents, a1.getStudentId());
                    double c2 = getCgpa(finalStudents, a2.getStudentId());
                    return Double.compare(c2, c1);
                });
            } else if ("cgpa_asc".equals(sortBy)) {
                applications.sort((a1, a2) -> {
                    double c1 = getCgpa(finalStudents, a1.getStudentId());
                    double c2 = getCgpa(finalStudents, a2.getStudentId());
                    return Double.compare(c1, c2);
                });
            } else if ("name".equals(sortBy)) {
                applications.sort((a1, a2) -> getStudentName(finalStudents, a1.getStudentId())
                    .compareToIgnoreCase(getStudentName(finalStudents, a2.getStudentId())));
            }
        }

        // Stats
        int total = applications.size();
        int pending = 0, shortlisted = 0, selected = 0, rejected = 0;
        for (Application a : applications) {
            if ("PENDING".equals(a.getStatus())) pending++;
            else if ("SHORTLISTED".equals(a.getStatus())) shortlisted++;
            else if ("SELECTED".equals(a.getStatus())) selected++;
            else if ("REJECTED".equals(a.getStatus())) rejected++;
        }

        request.setAttribute("applicationsList", applications);
        request.setAttribute("myJobs", myJobs);
        request.setAttribute("allStudents", allStudents);
        request.setAttribute("jobCount", myJobs.size());
        request.setAttribute("totalApplications", total);
        request.setAttribute("pendingCount", pending);
        request.setAttribute("shortlistedCount", shortlisted);
        request.setAttribute("selectedCount", selected);
        request.setAttribute("rejectedCount", rejected);
        request.setAttribute("filterJob", filterJob);
        request.setAttribute("filterStatus", filterStatus);
        request.setAttribute("filterBranch", filterBranch);
        request.setAttribute("search", search);
        request.setAttribute("minCgpa", minCgpaStr);
        request.setAttribute("sortBy", sortBy);

        request.getRequestDispatcher("company-applications.jsp").forward(request, response);
    }

    private double getCgpa(List<Student> students, int id) {
        for (Student s : students) if (s.getId() == id) return s.getCgpa();
        return 0;
    }
    private String getStudentName(List<Student> students, int id) {
        for (Student s : students) if (s.getId() == id) return s.getName();
        return "";
    }
}