package com.placement.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.AttendanceDAO;
import com.placement.dao.EventDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Event;
import com.placement.model.Student;
import com.placement.utils.MailUtil;

@WebServlet("/MarkAttendanceServlet")
public class MarkAttendanceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("studentId");
        int eventId = Integer.parseInt(request.getParameter("eventId"));

        AttendanceDAO dao = new AttendanceDAO();

        if (dao.hasMarked(eventId, studentId)) {
            response.sendRedirect("EventsServlet?msg=already");
            return;
        }

        dao.markAttendance(eventId, studentId);

        // 📧 Attendance confirmation email
        try {
            Student student = new StudentDAO().getStudentById(studentId);
            Event event = null;
            for (Event e : new EventDAO().getAllEvents()) {
                if (e.getId() == eventId) { event = e; break; }
            }

            if (student != null && event != null) {
                String subject = "Attendance Marked: " + event.getTitle();
                String body = MailUtil.attendanceMarkedTemplate(
                    student.getName(),
                    event.getTitle(),
                    event.getEventDate() != null ? event.getEventDate().toString() : "-",
                    event.getVenue() != null ? event.getVenue() : "-"
                );
                MailUtil.sendEmail(student.getEmail(), subject, body);
                System.out.println("📧 Attendance email sent to: " + student.getEmail());
            }
        } catch (Exception e) {
            System.out.println("❌ Attendance email failed: " + e.getMessage());
        }

        response.sendRedirect("EventsServlet?msg=marked");
    }
}