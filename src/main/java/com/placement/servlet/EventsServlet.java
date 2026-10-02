package com.placement.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.CompanyDAO;
import com.placement.dao.EventDAO;
import com.placement.model.Company;
import com.placement.model.Event;

@WebServlet("/EventsServlet")
public class EventsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        EventDAO eventDAO = new EventDAO();
        CompanyDAO companyDAO = new CompanyDAO();

        List<Event> events = eventDAO.getAllEvents();
        List<Company> companies = companyDAO.getAllCompanies();

        request.setAttribute("eventsList", events);
        request.setAttribute("companiesList", companies);
        request.getRequestDispatcher("events.jsp").forward(request, response);
    }
}