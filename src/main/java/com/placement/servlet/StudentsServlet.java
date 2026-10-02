package com.placement.servlet;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.StudentDAO;
import com.placement.model.Student;

@WebServlet("/StudentsServlet")
public class StudentsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        StudentDAO dao = new StudentDAO();
        List<Student> students = dao.getAllStudents();

        // Search parameters
        String searchName = request.getParameter("search");
        String searchBranch = request.getParameter("branch");
        String minCgpaStr = request.getParameter("minCgpa");

        if (searchName != null && !searchName.trim().isEmpty()) {
            String s = searchName.toLowerCase().trim();
            students = students.stream()
                .filter(st -> st.getName().toLowerCase().contains(s) 
                           || st.getRollNo().toLowerCase().contains(s)
                           || st.getEmail().toLowerCase().contains(s))
                .collect(Collectors.toList());
        }

        if (searchBranch != null && !searchBranch.trim().isEmpty()) {
            students = students.stream()
                .filter(st -> searchBranch.equals(st.getBranch()))
                .collect(Collectors.toList());
        }

        if (minCgpaStr != null && !minCgpaStr.trim().isEmpty()) {
            try {
                double minCgpa = Double.parseDouble(minCgpaStr);
                students = students.stream()
                    .filter(st -> st.getCgpa() >= minCgpa)
                    .collect(Collectors.toList());
            } catch (NumberFormatException e) {}
        }

        request.setAttribute("studentsList", students);
        request.setAttribute("searchName", searchName);
        request.setAttribute("searchBranch", searchBranch);
        request.setAttribute("minCgpa", minCgpaStr);
        
        request.getRequestDispatcher("students.jsp").forward(request, response);
    }
}