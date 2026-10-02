package com.placement.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.placement.service.ChatBotService;

@WebServlet("/ChatBotServlet")
public class ChatBotServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            out.print("{\"reply\":\"Please login as a student to use chatbot.\"}");
            return;
        }

        int studentId = (Integer) session.getAttribute("studentId");
        String studentName = (String) session.getAttribute("studentName");
        String message = request.getParameter("message");

        if (message == null || message.trim().isEmpty()) {
            out.print("{\"reply\":\"Please type a message.\"}");
            return;
        }

        try {
            String reply = ChatBotService.getReply(message.trim(), studentId, studentName);
            // Escape quotes and newlines for JSON
            reply = reply.replace("\\", "\\\\")
                         .replace("\"", "\\\"")
                         .replace("\n", "\\n")
                         .replace("\r", "");
            out.print("{\"reply\":\"" + reply + "\"}");
        } catch (Exception e) {
            out.print("{\"reply\":\"Sorry, something went wrong. Please try again.\"}");
            e.printStackTrace();
        }
    }

    // Optional: GET request pe bhi kuch response do (testing ke liye)
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print("{\"reply\":\"ChatBot is running. Use POST to send messages.\"}");
    }
}