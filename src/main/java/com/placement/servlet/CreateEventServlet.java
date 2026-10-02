package com.placement.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.CompanyDAO;
import com.placement.dao.EventDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Company;
import com.placement.model.Event;
import com.placement.model.Student;
import com.placement.utils.MailUtil;

@WebServlet("/CreateEventServlet")
public class CreateEventServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String eventDateStr = request.getParameter("eventDate");
        String venue = request.getParameter("venue");
        int companyId = Integer.parseInt(request.getParameter("companyId"));

        LocalDate eventDate = null;
        if (eventDateStr != null && !eventDateStr.isEmpty()) {
            eventDate = LocalDate.parse(eventDateStr);
        }

        Event event = new Event(title, description, eventDate, venue, companyId);
        new EventDAO().addEvent(event);

        // 📧 SAARE STUDENTS KO EMAIL BHEJO
        try {
            // Company details laao
            Company company = null;
            for (Company c : new CompanyDAO().getAllCompanies()) {
                if (c.getId() == companyId) { company = c; break; }
            }
            String companyName = company != null ? company.getName() : "N/A";

            // Saare students laao
            List<Student> allStudents = new StudentDAO().getAllStudents();
            int emailCount = 0;

            String dateStr = eventDate != null ? eventDate.toString() : "TBA";

            for (Student s : allStudents) {
                String subject = "New Event: " + title + " on " + dateStr;
                String body = MailUtil.newEventTemplate(
                    s.getName(),
                    title,
                    description,
                    dateStr,
                    venue,
                    companyName
                );

                MailUtil.sendEmail(s.getEmail(), subject, body);
                emailCount++;
                System.out.println("📧 Event email sent to: " + s.getEmail());
            }

            System.out.println("✅ Total " + emailCount + " students ko event email bheji gayi.");

        } catch (Exception e) {
            System.out.println("❌ Event emails failed: " + e.getMessage());
            e.printStackTrace();
        }

        response.sendRedirect("EventsServlet");
    }
}