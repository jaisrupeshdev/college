package com.placement.servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.placement.dao.StudentDAO;
import com.placement.model.Student;
import com.placement.utils.MailUtil;

@WebServlet("/UploadResumeServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 5,
    maxRequestSize = 1024 * 1024 * 10
)
public class UploadResumeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("studentId");
        Part filePart = request.getPart("resume");

        if (filePart == null || filePart.getSize() == 0) {
            response.sendRedirect("ProfileServlet?msg=nofile");
            return;
        }

        String fileName = filePart.getSubmittedFileName();
        if (fileName == null || !fileName.toLowerCase().endsWith(".pdf")) {
            response.sendRedirect("ProfileServlet?msg=invalidtype");
            return;
        }

        String savedFileName = "resume_" + studentId + "_" + System.currentTimeMillis() + ".pdf";

        // ========== 1. TOMCAT DEPLOYED FOLDER ME SAVE (browser access ke liye) ==========
        String tomcatDir = getServletContext().getRealPath("/uploads/resumes/");
        File tomcatFolder = new File(tomcatDir);
        if (!tomcatFolder.exists()) tomcatFolder.mkdirs();
        
        String tomcatPath = tomcatDir + File.separator + savedFileName;
        filePart.write(tomcatPath);
        System.out.println("✅ Resume saved to Tomcat: " + tomcatPath);

        // ========== 2. PERMANENT FOLDER ME BACKUP (Tomcat clean hone pe bhi safe) ==========
        try {
            String permanentDir = "C:\\PlacementWebResumes\\";
            File permFolder = new File(permanentDir);
            if (!permFolder.exists()) permFolder.mkdirs();
            
            Files.copy(
                new File(tomcatPath).toPath(),
                new File(permanentDir + savedFileName).toPath(),
                StandardCopyOption.REPLACE_EXISTING
            );
            System.out.println("✅ Resume backed up to: " + permanentDir);
        } catch (Exception e) {
            System.out.println("⚠️ Backup failed: " + e.getMessage());
        }

        // ========== 3. DATABASE ME RELATIVE PATH SAVE ==========
        String relativePath = "uploads/resumes/" + savedFileName;
        StudentDAO dao = new StudentDAO();
        Student student = dao.getStudentById(studentId);
        student.setResumePath(relativePath);
        dao.updateStudent(student);

        System.out.println("✅ Database updated with path: " + relativePath);

        // ========== 4. EMAIL CONFIRMATION ==========
        try {
            String subject = "Resume Uploaded Successfully";
            String body = MailUtil.resumeUploadedTemplate(student.getName());
            MailUtil.sendEmail(student.getEmail(), subject, body);
            System.out.println("📧 Resume confirmation sent to: " + student.getEmail());
        } catch (Exception e) {
            System.out.println("❌ Resume email failed: " + e.getMessage());
        }

        response.sendRedirect("ProfileServlet?msg=resumeuploaded");
    }
}