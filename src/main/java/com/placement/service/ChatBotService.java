package com.placement.service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.List;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.placement.dao.ApplicationDAO;
import com.placement.dao.EventDAO;
import com.placement.dao.InterviewDAO;
import com.placement.dao.JobDAO;
import com.placement.model.Application;
import com.placement.model.Event;
import com.placement.model.Interview;
import com.placement.model.Job;

public class ChatBotService {

	

	    // 🔐 API key loaded from environment variable (not hardcoded)
	    private static final String GEMINI_API_KEY = System.getenv("GEMINI_API_KEY");
	    
	    private static final String GEMINI_URL = 
	        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=";
	    
	    
	
    // ============ MAIN METHOD ============
    public static String getReply(String userMessage, int studentId, String studentName) {
        if (userMessage == null || userMessage.trim().isEmpty()) {
            return "Please type a message.";
        }

        String msg = userMessage.toLowerCase().trim();

        // ========== STEP 1: RULE-BASED (Fast + Free) ==========
        String ruleReply = ruleBasedReply(msg, studentId, studentName);
        if (ruleReply != null) {
            System.out.println("🤖 Rule-based reply used");
            return ruleReply;
        }

        // ========== STEP 2: GEMINI API FALLBACK ==========
        try {
            System.out.println("🤖 Calling Gemini API...");
            return callGeminiAPI(userMessage, studentName);
        } catch (Exception e) {
            System.out.println("❌ Gemini API failed: " + e.getMessage());
            return "Sorry, I couldn't understand that. You can ask about:\n" +
                   "• How to apply for jobs\n" +
                   "• Resume upload\n" +
                   "• My applications status\n" +
                   "• Available jobs\n" +
                   "• Upcoming events";
        }
    }

    // ============ RULE-BASED LOGIC ============
    private static String ruleBasedReply(String msg, int studentId, String studentName) {

        // Greeting
        if (msg.matches(".*\\b(hi|hello|hey|namaste|namaskar|hii|helo)\\b.*")) {
            return "Hello " + studentName + "! 👋\nHow can I help you today? You can ask about jobs, applications, resume, events, and more.";
        }

        // Help
        if (msg.contains("help") || msg.contains("what can you do") || msg.contains("kya kar sakte")
            || msg.contains("what can u do")) {
            return "I can help you with:\n" +
                   "📌 How to apply for jobs\n" +
                   "📌 Resume upload\n" +
                   "📌 My applications status\n" +
                   "📌 My interviews\n" +
                   "📌 Available jobs count\n" +
                   "📌 Upcoming events\n" +
                   "📌 Profile update\n" +
                   "Just type your question!";
        }

        // How to apply
        if (msg.contains("how to apply") || msg.contains("apply for job") || msg.contains("apply kaise")
            || msg.contains("job apply")) {
            return "📝 How to Apply for a Job:\n" +
                   "1. Go to 'Browse Jobs' from sidebar\n" +
                   "2. Click 'Apply Now' on any job card\n" +
                   "3. Confirm the dialog\n" +
                   "4. That's it! You'll get a notification when the status updates.\n\n" +
                   "Note: You can only apply once per job.";
        }

        // Resume
        if (msg.contains("resume") || msg.contains("cv")) {
            if (msg.contains("upload") || msg.contains("kaise")) {
                return "📄 How to Upload Resume:\n" +
                       "1. Go to 'My Profile' from sidebar\n" +
                       "2. Scroll to 'My Resume' section\n" +
                       "3. Click 'Choose File' and select a PDF (max 5 MB)\n" +
                       "4. Click 'Upload'\n\n" +
                       "Your resume will be visible to companies when you apply.";
            }
            return "You can upload your resume from 'My Profile' page. Only PDF files (max 5 MB) are allowed.";
        }

        // Applications count / status
        if (msg.contains("application") || msg.contains("applied") || msg.contains("meri application")
            || msg.contains("my application")) {
            try {
                List<Application> apps = new ApplicationDAO().getApplicationsByStudent(studentId);
                if (apps.isEmpty()) {
                    return "You haven't applied to any jobs yet. Browse jobs and click 'Apply Now'!";
                }
                long pending = apps.stream().filter(a -> "PENDING".equals(a.getStatus())).count();
                long shortlisted = apps.stream().filter(a -> "SHORTLISTED".equals(a.getStatus())).count();
                long selected = apps.stream().filter(a -> "SELECTED".equals(a.getStatus())).count();
                long rejected = apps.stream().filter(a -> "REJECTED".equals(a.getStatus())).count();

                return "📋 Your Application Summary:\n" +
                       "Total: " + apps.size() + " applications\n" +
                       "⏳ Pending: " + pending + "\n" +
                       "✅ Shortlisted: " + shortlisted + "\n" +
                       "🎉 Selected: " + selected + "\n" +
                       "❌ Rejected: " + rejected + "\n\n" +
                       "Check 'My Applications' for details.";
            } catch (Exception e) {
                return "I couldn't fetch your applications. Please check 'My Applications' page.";
            }
        }

        // Interviews
        if (msg.contains("interview")) {
            try {
                List<Interview> interviews = new InterviewDAO().getInterviewsByStudent(studentId);
                if (interviews.isEmpty()) {
                    return "You have no scheduled interviews yet. Once shortlisted, your interview will appear here.";
                }
                StringBuilder sb = new StringBuilder("🎯 Your Interviews (" + interviews.size() + "):\n");
                for (Interview i : interviews) {
                    sb.append("\n📅 ").append(i.getInterviewDate())
                      .append(" at ").append(i.getInterviewTime())
                      .append(" (").append(i.getMode()).append(")");
                }
                sb.append("\n\nCheck 'My Interviews' for full details.");
                return sb.toString();
            } catch (Exception e) {
                return "Check 'My Interviews' page for schedule.";
            }
        }

        // Jobs count
        if (msg.contains("how many jobs") || msg.contains("job count") || msg.contains("kitni jobs") 
            || msg.contains("available jobs") || msg.contains("jobs available") || msg.contains("jobs hain")) {
            try {
                List<Job> jobs = new JobDAO().getAllJobs();
                return "💼 Currently there are *" + jobs.size() + " job openings* available.\n" +
                       "Go to 'Browse Jobs' to see them all!";
            } catch (Exception e) {
                return "Check 'Browse Jobs' page for current openings.";
            }
        }

        // Events
        if (msg.contains("event") || msg.contains("upcoming")) {
            try {
                List<Event> events = new EventDAO().getAllEvents();
                if (events.isEmpty()) {
                    return "No upcoming events scheduled right now. Check back later!";
                }
                StringBuilder sb = new StringBuilder("📅 Upcoming Events (" + events.size() + "):\n");
                int count = 0;
                for (Event e : events) {
                    if (count++ >= 3) break;
                    sb.append("\n• ").append(e.getTitle())
                      .append(" on ").append(e.getEventDate());
                }
                sb.append("\n\nCheck 'Events' page for all events.");
                return sb.toString();
            } catch (Exception e) {
                return "Check 'Events' page for upcoming placement activities.";
            }
        }

        // Profile
        if (msg.contains("profile") || msg.contains("update profile") || msg.contains("profile update")) {
            return "👤 To Update Profile:\n" +
                   "1. Go to 'My Profile' from sidebar\n" +
                   "2. Edit your details (name, email, CGPA, branch, skills)\n" +
                   "3. Leave password blank if you don't want to change it\n" +
                   "4. Click 'Save Changes'";
        }

        // Notification
        if (msg.contains("notification")) {
            return "🔔 Check 'Notifications' from sidebar. You'll see:\n" +
                   "• Application status updates\n" +
                   "• Interview schedules\n" +
                   "• Important announcements\n\n" +
                   "Unread notifications have a purple 'NEW' badge.";
        }

        // Contact / Email
        if (msg.contains("contact") || msg.contains("email") || msg.contains("phone")) {
            return "📧 For any queries, contact the Placement Cell:\n" +
                   "• Email: placement@college.edu\n" +
                   "• Phone: +91-XXXXXXXXXX\n" +
                   "• Office: Admin Block, Room 201";
        }

        // Thank you
        if (msg.matches(".*\\b(thanks|thank you|shukriya|dhanyawad|thnx|thanx)\\b.*")) {
            return "You're welcome! 😊 All the best for your placements!";
        }

        // Bye
        if (msg.matches(".*\\b(bye|goodbye|see you|tata)\\b.*")) {
            return "Goodbye! 👋 Feel free to come back if you have more questions.";
        }

        // Who are you
        if (msg.contains("who are you") || msg.contains("your name") || msg.contains("kaun ho")) {
            return "I'm the Placement Assistant 🤖 — a chatbot built to help students with their placement-related queries. Ask me anything!";
        }

        // If no rule matched → return null (Gemini API will handle)
        return null;
    }

    // ============ GEMINI API CALL ============
    private static String callGeminiAPI(String userMessage, String studentName) throws Exception {
        String apiUrl = GEMINI_URL + GEMINI_API_KEY;

        // System context + user message
        String prompt = "You are a helpful assistant for a College Placement Portal. " +
                        "The user is a student named " + studentName + ". " +
                        "Answer their question briefly (max 3 lines) and helpfully. " +
                        "If asked about the portal, answer about: jobs, applications, resume, events, interviews, notifications. " +
                        "User query: " + userMessage;

        // Build JSON request body
        JsonObject textPart = new JsonObject();
        textPart.addProperty("text", prompt);

        JsonArray parts = new JsonArray();
        parts.add(textPart);

        JsonObject content = new JsonObject();
        content.add("parts", parts);

        JsonArray contents = new JsonArray();
        contents.add(content);

        JsonObject requestBody = new JsonObject();
        requestBody.add("contents", contents);

        // HTTP call
        HttpClient client = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(apiUrl))
                .timeout(Duration.ofSeconds(15))
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(requestBody.toString()))
                .build();

        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        if (response.statusCode() != 200) {
            throw new Exception("API returned: " + response.statusCode() + " - " + response.body());
        }

        // Parse response
        JsonObject jsonResponse = JsonParser.parseString(response.body()).getAsJsonObject();
        JsonArray candidates = jsonResponse.getAsJsonArray("candidates");
        if (candidates == null || candidates.size() == 0) {
            throw new Exception("No candidates in response");
        }

        JsonObject candidate = candidates.get(0).getAsJsonObject();
        JsonObject contentObj = candidate.getAsJsonObject("content");
        JsonArray partsArr = contentObj.getAsJsonArray("parts");
        String reply = partsArr.get(0).getAsJsonObject().get("text").getAsString();

        return reply.trim();
    }
}