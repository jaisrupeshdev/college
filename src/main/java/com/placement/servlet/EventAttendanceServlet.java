package com.placement.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.AttendanceDAO;
import com.placement.dao.EventDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Attendance;
import com.placement.model.Event;
import com.placement.model.Student;

@WebServlet("/EventAttendanceServlet")
public class EventAttendanceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int eventId = Integer.parseInt(request.getParameter("eventId"));

        EventDAO eventDAO = new EventDAO();
        AttendanceDAO attDAO = new AttendanceDAO();
        StudentDAO studentDAO = new StudentDAO();

        Event event = null;
        for (Event e : eventDAO.getAllEvents()) {
            if (e.getId() == eventId) { event = e; break; }
        }

        List<Attendance> attendanceList = attDAO.getAttendanceByEvent(eventId);
        List<Student> allStudents = studentDAO.getAllStudents();

        request.setAttribute("event", event);
        request.setAttribute("attendanceList", attendanceList);
        request.setAttribute("allStudents", allStudents);

        request.getRequestDispatcher("event-attendance.jsp").forward(request, response);
    }
}