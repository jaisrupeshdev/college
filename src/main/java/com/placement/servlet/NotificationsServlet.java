package com.placement.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.dao.NotificationDAO;
import com.placement.model.Notification;

@WebServlet("/NotificationsServlet")
public class NotificationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("studentId");
        NotificationDAO dao = new NotificationDAO();

        // Mark all as read when viewing
        if ("read".equals(request.getParameter("action"))) {
            dao.markAllAsRead(studentId);
        }

        List<Notification> notifications = dao.getNotificationsByStudent(studentId);
        int unreadCount = dao.getUnreadCount(studentId);

        request.setAttribute("notificationsList", notifications);
        request.setAttribute("unreadCount", unreadCount);
        request.getRequestDispatcher("notifications.jsp").forward(request, response);
    }
}