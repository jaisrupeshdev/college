package com.placement.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.placement.model.Application;
import com.placement.utils.DBConnection;

public class ApplicationDAO {

    // ✅ Naya application create karo (student apply kare)
    public void applyForJob(int studentId, int jobId) {
        String sql = "INSERT INTO applications (student_id, job_id, status, applied_date) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, jobId);
            pstmt.setString(3, "PENDING");
            pstmt.setDate(4, Date.valueOf(LocalDate.now()));

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                System.out.println("✅ Application submit ho gaya! (Student ID: " + studentId + ", Job ID: " + jobId + ")");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // ✅ Application ka status update karo (SHORTLISTED / REJECTED / SELECTED)
    public void updateStatus(int applicationId, String newStatus) {
        String sql = "UPDATE applications SET status = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, applicationId);

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                System.out.println("✅ Status update ho gaya! Application ID: " + applicationId + " → " + newStatus);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // ✅ Saare applications fetch karo
    public List<Application> getAllApplications() {
        List<Application> applications = new ArrayList<>();
        String sql = "SELECT * FROM applications";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                Application a = new Application();
                a.setId(rs.getInt("id"));
                a.setStudentId(rs.getInt("student_id"));
                a.setJobId(rs.getInt("job_id"));
                a.setStatus(rs.getString("status"));
                Date d = rs.getDate("applied_date");
                if (d != null) a.setAppliedDate(d.toLocalDate());
                applications.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return applications;
    }
    // ✅ Specific student ki saari applications laao
    public List<Application> getApplicationsByStudent(int studentId) {
        List<Application> applications = new ArrayList<>();
        String sql = "SELECT * FROM applications WHERE student_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Application a = new Application();
                a.setId(rs.getInt("id"));
                a.setStudentId(rs.getInt("student_id"));
                a.setJobId(rs.getInt("job_id"));
                a.setStatus(rs.getString("status"));
                Date d = rs.getDate("applied_date");
                if (d != null) a.setAppliedDate(d.toLocalDate());
                applications.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return applications;
    }

    // ✅ Check karo ki student ne already apply kiya hai ya nahi
    public boolean hasApplied(int studentId, int jobId) {
        String sql = "SELECT * FROM applications WHERE student_id = ? AND job_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, jobId);
            rs = pstmt.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }
}