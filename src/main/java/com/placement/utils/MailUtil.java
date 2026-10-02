package com.placement.utils;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class MailUtil {

    // ============================================
    // 🔥 APNI DETAILS YAHAN DAALO
    // ============================================
    private static final String FROM_EMAIL = "jaisrupesh35@gmail.com";
    private static final String FROM_PASSWORD = "jdpd zowl uhan qbnt";

    // ============================================
    // MAIN SEND METHOD
    // ============================================
    public static void sendEmail(String toEmail, String subject, String body) {
        if (toEmail == null || toEmail.trim().isEmpty()) {
            System.out.println("Email skipped — recipient empty");
            return;
        }

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Placement Portal"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(body, "text/html; charset=utf-8");

            Transport.send(message);
            System.out.println("Email sent to: " + toEmail);

        } catch (Exception e) {
            System.out.println("Email failed to " + toEmail + ": " + e.getMessage());
        }
    }

    // ============================================
    // HELPER: HTML Wrapper
    // ============================================
    private static String wrapBody(String heading, String content, String buttonUrl, String buttonText, String gradient) {
        return "<div style='font-family:Inter,Arial,sans-serif;max-width:600px;margin:auto;border:1px solid #e1e5ee;border-radius:12px;overflow:hidden;'>" +
               "<div style='background:" + gradient + ";padding:30px;text-align:center;'>" +
               "<h1 style='color:white;margin:0;font-size:22px;'>" + heading + "</h1>" +
               "</div>" +
               "<div style='padding:30px;'>" +
               content +
               "<a href='" + buttonUrl + "' style='display:inline-block;background:" + gradient + ";color:white;padding:12px 25px;border-radius:8px;text-decoration:none;margin-top:15px;font-weight:600;'>" + buttonText + "</a>" +
               "</div>" +
               "<div style='background:#f8f9fa;padding:20px;text-align:center;color:#8892b0;font-size:12px;'>" +
               "© 2026 Placement Portal — Auto generated email. Do not reply." +
               "</div>" +
               "</div>";
    }

    // ============================================
    // TEMPLATE 1: Student Welcome
    // ============================================
    public static String welcomeTemplate(String name) {
        return wrapBody(
            "Welcome Aboard!",
            "<h2 style='color:#1a1a2e;'>Hi " + name + ",</h2>" +
            "<p style='color:#4a5578;font-size:15px;'>Your account has been created on Placement Portal.</p>" +
            "<ul style='color:#4a5578;font-size:14px;line-height:2;'>" +
            "<li>Browse job openings</li>" +
            "<li>Apply for eligible positions</li>" +
            "<li>Upload your resume</li>" +
            "<li>Track applications &amp; get notifications</li>" +
            "</ul>",
            "http://localhost:8080/PlacementWeb/login.jsp",
            "Login Now",
            "linear-gradient(135deg,#667eea,#764ba2)"
        );
    }

    // ============================================
    // TEMPLATE 2: Status Update
    // ============================================
    public static String statusUpdateTemplate(String studentName, String jobTitle, String status) {
        String color = "PENDING".equals(status) ? "#f6c23e" :
                       "SHORTLISTED".equals(status) ? "#43e97b" :
                       "SELECTED".equals(status) ? "#4facfe" : "#f5576c";
        return wrapBody(
            "Application Update",
            "<h2 style='color:#1a1a2e;'>Hello " + studentName + ",</h2>" +
            "<p style='color:#4a5578;font-size:15px;'>Your application status has been updated:</p>" +
            "<div style='background:#f8f9fa;padding:20px;border-radius:10px;border-left:5px solid " + color + ";margin:20px 0;'>" +
            "<p style='margin:0;color:#8892b0;font-size:13px;'>JOB POSITION</p>" +
            "<p style='margin:5px 0 15px;color:#1a1a2e;font-size:17px;font-weight:700;'>" + jobTitle + "</p>" +
            "<p style='margin:0;color:#8892b0;font-size:13px;'>NEW STATUS</p>" +
            "<p style='margin:5px 0;color:" + color + ";font-size:20px;font-weight:800;'>" + status + "</p>" +
            "</div>",
            "http://localhost:8080/PlacementWeb/MyApplicationsServlet",
            "View in Portal",
            "linear-gradient(135deg,#667eea,#764ba2)"
        );
    }

    // ============================================
    // TEMPLATE 3: Application Received (Company)
    // ============================================
    public static String applicationReceivedTemplate(
            String companyName, String studentName, String studentRoll,
            String studentEmail, double cgpa, String branch,
            String skills, String jobTitle, String resumePath) {
        String resumeSection;
        if (resumePath != null && !resumePath.isEmpty()) {
            resumeSection = "<p style='margin:15px 0;'><a href='http://localhost:8080/PlacementWeb/" + resumePath +
                "' style='display:inline-block;background:#43e97b;color:white;padding:10px 20px;border-radius:8px;text-decoration:none;font-weight:600;'>View Resume</a></p>";
        } else {
            resumeSection = "<p style='color:#8892b0;font-size:13px;margin:15px 0;'><em>No resume uploaded</em></p>";
        }
        return wrapBody(
            "New Application Received",
            "<h2 style='color:#1a1a2e;'>Hello " + companyName + ",</h2>" +
            "<p style='color:#4a5578;font-size:15px;'>A student has applied for your job posting:</p>" +
            "<div style='background:#f8f9fa;padding:20px;border-radius:10px;border-left:5px solid #667eea;margin:20px 0;'>" +
            "<p style='margin:0;color:#8892b0;font-size:13px;'>JOB POSITION</p>" +
            "<p style='margin:5px 0 0;color:#1a1a2e;font-size:18px;font-weight:700;'>" + jobTitle + "</p>" +
            "</div>" +
            "<h3 style='color:#1a1a2e;font-size:16px;margin-top:25px;'>Applicant Details</h3>" +
            "<table style='width:100%;border-collapse:collapse;margin-top:10px;'>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;width:130px;'>Name</td><td style='padding:8px 0;color:#1a1a2e;font-weight:600;'>" + studentName + "</td></tr>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;'>Roll No</td><td style='padding:8px 0;color:#1a1a2e;'>" + studentRoll + "</td></tr>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;'>Email</td><td style='padding:8px 0;color:#1a1a2e;'>" + studentEmail + "</td></tr>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;'>CGPA</td><td style='padding:8px 0;color:#1d7a3a;font-weight:700;'>" + cgpa + "</td></tr>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;'>Branch</td><td style='padding:8px 0;color:#1a1a2e;'>" + branch + "</td></tr>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;'>Skills</td><td style='padding:8px 0;color:#4c51bf;font-weight:600;'>" + skills + "</td></tr>" +
            "</table>" + resumeSection,
            "http://localhost:8080/PlacementWeb/CompanyDashboardServlet",
            "View in Portal",
            "linear-gradient(135deg,#667eea,#764ba2)"
        );
    }

    // ============================================
    // TEMPLATE 4: New Job (Students)
    // ============================================
    public static String newJobTemplate(String studentName, String jobTitle, String companyName,
            double minCgpa, String branches, String skills) {
        return wrapBody(
            "New Job Opening!",
            "<h2 style='color:#1a1a2e;'>Hi " + studentName + ",</h2>" +
            "<p style='color:#4a5578;font-size:15px;'>A new job opportunity matching your profile has been posted:</p>" +
            "<div style='background:#f8f9fa;padding:20px;border-radius:10px;border-left:5px solid #4facfe;margin:20px 0;'>" +
            "<p style='margin:0;color:#8892b0;font-size:13px;'>JOB POSITION</p>" +
            "<p style='margin:5px 0 15px;color:#1a1a2e;font-size:20px;font-weight:700;'>" + jobTitle + "</p>" +
            "<p style='margin:0;color:#8892b0;font-size:13px;'>COMPANY</p>" +
            "<p style='margin:5px 0;color:#1a1a2e;font-size:16px;font-weight:600;'>" + companyName + "</p>" +
            "</div>" +
            "<table style='width:100%;border-collapse:collapse;'>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;width:130px;'>Min CGPA</td><td style='padding:8px 0;color:#1d7a3a;font-weight:700;'>" + minCgpa + "</td></tr>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;'>Branches</td><td style='padding:8px 0;color:#4c51bf;font-weight:600;'>" + branches + "</td></tr>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;'>Required Skills</td><td style='padding:8px 0;color:#4c51bf;font-weight:600;'>" + skills + "</td></tr>" +
            "</table>",
            "http://localhost:8080/PlacementWeb/JobsServlet",
            "Apply Now",
            "linear-gradient(135deg,#4facfe,#00f2fe)"
        );
    }

    // ============================================
    // TEMPLATE 5: New Event (Students)
    // ============================================
    public static String newEventTemplate(String studentName, String eventTitle, String description,
            String eventDate, String venue, String companyName) {
        return wrapBody(
            "New Placement Event!",
            "<h2 style='color:#1a1a2e;'>Hi " + studentName + ",</h2>" +
            "<p style='color:#4a5578;font-size:15px;'>A new placement event has been scheduled:</p>" +
            "<div style='background:#f8f9fa;padding:20px;border-radius:10px;border-left:5px solid #f093fb;margin:20px 0;'>" +
            "<p style='margin:0;color:#8892b0;font-size:13px;'>EVENT</p>" +
            "<p style='margin:5px 0 0;color:#1a1a2e;font-size:20px;font-weight:700;'>" + eventTitle + "</p>" +
            "</div>" +
            "<table style='width:100%;border-collapse:collapse;'>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;width:130px;'>Date</td><td style='padding:8px 0;color:#1a1a2e;font-weight:600;'>" + eventDate + "</td></tr>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;'>Venue</td><td style='padding:8px 0;color:#1a1a2e;'>" + venue + "</td></tr>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;'>Company</td><td style='padding:8px 0;color:#1a1a2e;'>" + companyName + "</td></tr>" +
            "</table>" +
            "<div style='background:#fff8e1;padding:15px;border-radius:10px;margin-top:20px;border-left:4px solid #f6c23e;'>" +
            "<p style='margin:0;color:#4a5578;font-size:13px;'>" + description + "</p></div>",
            "http://localhost:8080/PlacementWeb/EventsServlet",
            "View Event",
            "linear-gradient(135deg,#f093fb,#f5576c)"
        );
    }

    // ============================================
    // TEMPLATE 6: New Student (Admin)
    // ============================================
    public static String newStudentAdminTemplate(String studentName, String rollNo, String email,
            double cgpa, String branch, String skills) {
        return wrapBody(
            "New Student Registered",
            "<h2 style='color:#1a1a2e;'>Admin Alert</h2>" +
            "<p style='color:#4a5578;font-size:15px;'>A new student has been added to the Placement Portal.</p>" +
            "<div style='background:#f8f9fa;padding:20px;border-radius:10px;border-left:5px solid #667eea;margin:20px 0;'>" +
            "<p style='margin:0;color:#8892b0;font-size:13px;'>STUDENT</p>" +
            "<p style='margin:5px 0 0;color:#1a1a2e;font-size:20px;font-weight:700;'>" + studentName + "</p>" +
            "</div>" +
            "<table style='width:100%;border-collapse:collapse;'>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;width:130px;'>Roll No</td><td style='padding:8px 0;color:#1a1a2e;'>" + rollNo + "</td></tr>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;'>Email</td><td style='padding:8px 0;color:#1a1a2e;'>" + email + "</td></tr>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;'>CGPA</td><td style='padding:8px 0;color:#1d7a3a;font-weight:700;'>" + cgpa + "</td></tr>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;'>Branch</td><td style='padding:8px 0;color:#1a1a2e;'>" + branch + "</td></tr>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;'>Skills</td><td style='padding:8px 0;color:#4c51bf;font-weight:600;'>" + skills + "</td></tr>" +
            "</table>",
            "http://localhost:8080/PlacementWeb/StudentsServlet",
            "View Students",
            "linear-gradient(135deg,#667eea,#764ba2)"
        );
    }

    // ============================================
    // TEMPLATE 7: New Company (Admin)
    // ============================================
    public static String newCompanyAdminTemplate(String companyName, String industry, String email) {
        return wrapBody(
            "New Company Registered",
            "<h2 style='color:#1a1a2e;'>Admin Alert</h2>" +
            "<p style='color:#4a5578;font-size:15px;'>A new company has been added as a recruitment partner.</p>" +
            "<div style='background:#f8f9fa;padding:20px;border-radius:10px;border-left:5px solid #f093fb;margin:20px 0;'>" +
            "<p style='margin:0;color:#8892b0;font-size:13px;'>COMPANY</p>" +
            "<p style='margin:5px 0 0;color:#1a1a2e;font-size:20px;font-weight:700;'>" + companyName + "</p>" +
            "</div>" +
            "<table style='width:100%;border-collapse:collapse;'>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;width:130px;'>Industry</td><td style='padding:8px 0;color:#1a1a2e;'>" + industry + "</td></tr>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;'>Login Email</td><td style='padding:8px 0;color:#1a1a2e;'>" + email + "</td></tr>" +
            "</table>",
            "http://localhost:8080/PlacementWeb/CompaniesServlet",
            "View Companies",
            "linear-gradient(135deg,#f093fb,#f5576c)"
        );
    }

    // ============================================
    // TEMPLATE 8: Company Welcome
    // ============================================
    public static String companyWelcomeTemplate(String companyName, String email, String password) {
        return wrapBody(
            "Welcome to Placement Portal!",
            "<h2 style='color:#1a1a2e;'>Hello " + companyName + ",</h2>" +
            "<p style='color:#4a5578;font-size:15px;'>Your company has been registered as a recruitment partner.</p>" +
            "<div style='background:#f8f9fa;padding:20px;border-radius:10px;border-left:5px solid #667eea;margin:20px 0;'>" +
            "<p style='margin:0;color:#8892b0;font-size:13px;'>YOUR LOGIN CREDENTIALS</p>" +
            "<p style='margin:8px 0 0;color:#1a1a2e;font-size:14px;'><strong>Email:</strong> " + email + "</p>" +
            "<p style='margin:5px 0 0;color:#1a1a2e;font-size:14px;'><strong>Password:</strong> " + password + "</p>" +
            "</div>" +
            "<p style='color:#4a5578;font-size:14px;'>You can now post job openings and manage applications.</p>",
            "http://localhost:8080/PlacementWeb/login.jsp",
            "Login to Portal",
            "linear-gradient(135deg,#667eea,#764ba2)"
        );
    }

    // ============================================
    // TEMPLATE 9: New Company (Students)
    // ============================================
    public static String newCompanyStudentTemplate(String studentName, String companyName, String industry) {
        return wrapBody(
            "New Company Added!",
            "<h2 style='color:#1a1a2e;'>Hi " + studentName + ",</h2>" +
            "<p style='color:#4a5578;font-size:15px;'>A new company has joined our placement portal!</p>" +
            "<div style='background:#f8f9fa;padding:20px;border-radius:10px;border-left:5px solid #43e97b;margin:20px 0;'>" +
            "<p style='margin:0;color:#8892b0;font-size:13px;'>COMPANY</p>" +
            "<p style='margin:5px 0 0;color:#1a1a2e;font-size:20px;font-weight:700;'>" + companyName + "</p>" +
            "<p style='margin:8px 0 0;color:#8892b0;font-size:13px;'>Industry: " + industry + "</p>" +
            "</div>" +
            "<p style='color:#4a5578;font-size:14px;'>Keep an eye out for job openings from this company!</p>",
            "http://localhost:8080/PlacementWeb/JobsServlet",
            "Browse Jobs",
            "linear-gradient(135deg,#43e97b,#38f9d7)"
        );
    }

    // ============================================
    // TEMPLATE 10: Application Confirmation (Student)
    // ============================================
    public static String applicationConfirmationTemplate(String studentName, String jobTitle, String companyName) {
        return wrapBody(
            "Application Submitted!",
            "<h2 style='color:#1a1a2e;'>Hi " + studentName + ",</h2>" +
            "<p style='color:#4a5578;font-size:15px;'>Your application has been successfully submitted:</p>" +
            "<div style='background:#f8f9fa;padding:20px;border-radius:10px;border-left:5px solid #667eea;margin:20px 0;'>" +
            "<p style='margin:0;color:#8892b0;font-size:13px;'>JOB POSITION</p>" +
            "<p style='margin:5px 0 15px;color:#1a1a2e;font-size:18px;font-weight:700;'>" + jobTitle + "</p>" +
            "<p style='margin:0;color:#8892b0;font-size:13px;'>COMPANY</p>" +
            "<p style='margin:5px 0;color:#1a1a2e;font-size:15px;'>" + companyName + "</p>" +
            "</div>" +
            "<p style='color:#4a5578;font-size:14px;'>You will receive updates when the company reviews your application.</p>",
            "http://localhost:8080/PlacementWeb/MyApplicationsServlet",
            "Track Application",
            "linear-gradient(135deg,#667eea,#764ba2)"
        );
    }

    // ============================================
    // TEMPLATE 11: Resume Uploaded (Student)
    // ============================================
    public static String resumeUploadedTemplate(String studentName) {
        return wrapBody(
            "Resume Uploaded!",
            "<h2 style='color:#1a1a2e;'>Hi " + studentName + ",</h2>" +
            "<p style='color:#4a5578;font-size:15px;'>Your resume has been uploaded successfully. It will now be visible to companies when you apply.</p>",
            "http://localhost:8080/PlacementWeb/ProfileServlet",
            "View Profile",
            "linear-gradient(135deg,#43e97b,#38f9d7)"
        );
    }

    // ============================================
    // TEMPLATE 12: Profile Updated (Student)
    // ============================================
    public static String profileUpdatedTemplate(String studentName) {
        return wrapBody(
            "Profile Updated",
            "<h2 style='color:#1a1a2e;'>Hi " + studentName + ",</h2>" +
            "<p style='color:#4a5578;font-size:15px;'>Your profile has been updated successfully.</p>" +
            "<p style='color:#8892b0;font-size:13px;'>If you didn't make this change, please contact the placement cell.</p>",
            "http://localhost:8080/PlacementWeb/ProfileServlet",
            "View Profile",
            "linear-gradient(135deg,#4facfe,#00f2fe)"
        );
    }

    // ============================================
    // TEMPLATE 13: Attendance Marked (Student)
    // ============================================
    public static String attendanceMarkedTemplate(String studentName, String eventTitle, String date, String venue) {
        return wrapBody(
            "Attendance Marked!",
            "<h2 style='color:#1a1a2e;'>Hi " + studentName + ",</h2>" +
            "<p style='color:#4a5578;font-size:15px;'>Your attendance has been marked for:</p>" +
            "<div style='background:#f8f9fa;padding:20px;border-radius:10px;border-left:5px solid #f093fb;margin:20px 0;'>" +
            "<p style='margin:0;color:#8892b0;font-size:13px;'>EVENT</p>" +
            "<p style='margin:5px 0 0;color:#1a1a2e;font-size:18px;font-weight:700;'>" + eventTitle + "</p>" +
            "<p style='margin:10px 0 0;color:#4a5578;font-size:13px;'>Date: " + date + "</p>" +
            "<p style='margin:5px 0 0;color:#4a5578;font-size:13px;'>Venue: " + venue + "</p>" +
            "</div>",
            "http://localhost:8080/PlacementWeb/EventsServlet",
            "View Events",
            "linear-gradient(135deg,#f093fb,#f5576c)"
        );
    }

    // ============================================
    // TEMPLATE 14: Job Posted Confirmation (Company)
    // ============================================
    public static String jobPostedCompanyTemplate(String companyName, String jobTitle, 
            double minCgpa, String branches, String skills) {
        return wrapBody(
            "Job Posted Successfully",
            "<h2 style='color:#1a1a2e;'>Hello " + companyName + ",</h2>" +
            "<p style='color:#4a5578;font-size:15px;'>Your job opening has been posted successfully.</p>" +
            "<div style='background:#f8f9fa;padding:20px;border-radius:10px;border-left:5px solid #4facfe;margin:20px 0;'>" +
            "<p style='margin:0;color:#8892b0;font-size:13px;'>JOB TITLE</p>" +
            "<p style='margin:5px 0 15px;color:#1a1a2e;font-size:18px;font-weight:700;'>" + jobTitle + "</p>" +
            "<p style='margin:0;color:#8892b0;font-size:13px;'>MIN CGPA</p>" +
            "<p style='margin:5px 0 10px;color:#1d7a3a;font-weight:700;'>" + minCgpa + "</p>" +
            "<p style='margin:0;color:#8892b0;font-size:13px;'>BRANCHES</p>" +
            "<p style='margin:5px 0 10px;color:#1a1a2e;'>" + branches + "</p>" +
            "<p style='margin:0;color:#8892b0;font-size:13px;'>SKILLS</p>" +
            "<p style='margin:5px 0;color:#1a1a2e;'>" + skills + "</p>" +
            "</div>" +
            "<p style='color:#4a5578;font-size:14px;'>Eligible students have been notified automatically.</p>",
            "http://localhost:8080/PlacementWeb/CompanyJobsServlet",
            "View My Jobs",
            "linear-gradient(135deg,#4facfe,#00f2fe)"
        );
    }

    // ============================================
    // TEMPLATE 15: OTP (Password Reset)
    // ============================================
    public static String otpTemplate(String studentName, String otp) {
        return wrapBody(
            "Password Reset",
            "<h2 style='color:#1a1a2e;'>Hi " + studentName + ",</h2>" +
            "<p style='color:#4a5578;font-size:15px;'>We received a request to reset your password. Use the OTP below:</p>" +
            "<div style='background:#f8f9fa;padding:30px;border-radius:10px;text-align:center;margin:25px 0;border:2px dashed #667eea;'>" +
            "<p style='margin:0;color:#8892b0;font-size:13px;'>YOUR OTP CODE</p>" +
            "<h1 style='margin:10px 0;color:#667eea;font-size:42px;font-weight:800;letter-spacing:8px;'>" + otp + "</h1>" +
            "<p style='margin:0;color:#8892b0;font-size:12px;'>Valid for 10 minutes</p>" +
            "</div>" +
            "<div style='background:#fff8e1;padding:15px;border-radius:10px;border-left:4px solid #f6c23e;'>" +
            "<p style='margin:0;color:#4a5578;font-size:13px;'><strong>Security Tip:</strong> Never share this OTP with anyone.</p>" +
            "</div>" +
            "<p style='color:#8892b0;font-size:13px;margin-top:20px;'>If you didn't request this, ignore this email.</p>",
            "http://localhost:8080/PlacementWeb/login.jsp",
            "Back to Login",
            "linear-gradient(135deg,#667eea,#764ba2)"
        );
    }

    // ============================================
    // TEMPLATE 16: Interview Scheduled
    // ============================================
    public static String interviewTemplate(String studentName, String jobTitle, 
            String date, String time, String mode, String location, String notes) {
        String notesSection = "";
        if (notes != null && !notes.isEmpty()) {
            notesSection = "<div style='background:#fff8e1;padding:15px;border-radius:10px;margin-top:20px;border-left:4px solid #f6c23e;'>" +
                          "<p style='margin:0;color:#4a5578;font-size:14px;'><strong>Notes:</strong></p>" +
                          "<p style='margin:8px 0 0;color:#4a5578;font-size:13px;'>" + notes + "</p>" +
                          "</div>";
        }
        return wrapBody(
            "Interview Scheduled!",
            "<h2 style='color:#1a1a2e;'>Hi " + studentName + ",</h2>" +
            "<p style='color:#4a5578;font-size:15px;'>Your interview has been scheduled:</p>" +
            "<div style='background:#f8f9fa;padding:20px;border-radius:10px;border-left:5px solid #667eea;margin:20px 0;'>" +
            "<p style='margin:0;color:#8892b0;font-size:13px;'>JOB POSITION</p>" +
            "<p style='margin:5px 0 0;color:#1a1a2e;font-size:18px;font-weight:700;'>" + jobTitle + "</p>" +
            "</div>" +
            "<table style='width:100%;border-collapse:collapse;'>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;width:130px;'>Date</td><td style='padding:8px 0;color:#1a1a2e;font-weight:600;'>" + date + "</td></tr>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;'>Time</td><td style='padding:8px 0;color:#1a1a2e;'>" + time + "</td></tr>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;'>Mode</td><td style='padding:8px 0;color:#1a1a2e;'>" + mode + "</td></tr>" +
            "<tr><td style='padding:8px 0;color:#8892b0;font-size:13px;'>Location</td><td style='padding:8px 0;color:#1a1a2e;'>" + location + "</td></tr>" +
            "</table>" + notesSection +
            "<p style='color:#8892b0;font-size:13px;margin-top:20px;'>All the best!</p>",
            "http://localhost:8080/PlacementWeb/MyInterviewsServlet",
            "View Interview",
            "linear-gradient(135deg,#667eea,#764ba2)"
        );
    }
}