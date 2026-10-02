package com.placement.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.placement.model.Interview;
import com.placement.utils.DBConnection;

public class InterviewDAO {

    public void addInterview(Interview i) {
        String sql = "INSERT INTO interviews (application_id, student_id, job_id, interview_date, interview_time, mode, location, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, i.getApplicationId());
            pstmt.setInt(2, i.getStudentId());
            pstmt.setInt(3, i.getJobId());
            pstmt.setDate(4, Date.valueOf(i.getInterviewDate()));
            pstmt.setString(5, i.getInterviewTime());
            pstmt.setString(6, i.getMode());
            pstmt.setString(7, i.getLocation());
            pstmt.setString(8, i.getNotes());
            pstmt.executeUpdate();
            System.out.println("✅ Interview scheduled");
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public List<Interview> getAllInterviews() {
        List<Interview> list = new ArrayList<>();
        String sql = "SELECT * FROM interviews ORDER BY interview_date DESC";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                Interview i = new Interview();
                i.setId(rs.getInt("id"));
                i.setApplicationId(rs.getInt("application_id"));
                i.setStudentId(rs.getInt("student_id"));
                i.setJobId(rs.getInt("job_id"));
                Date d = rs.getDate("interview_date");
                if (d != null) i.setInterviewDate(d.toLocalDate());
                i.setInterviewTime(rs.getString("interview_time"));
                i.setMode(rs.getString("mode"));
                i.setLocation(rs.getString("location"));
                i.setNotes(rs.getString("notes"));
                i.setStatus(rs.getString("status"));
                list.add(i);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return list;
    }

    public List<Interview> getInterviewsByStudent(int studentId) {
        List<Interview> list = new ArrayList<>();
        String sql = "SELECT * FROM interviews WHERE student_id = ? ORDER BY interview_date DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, studentId);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Interview i = new Interview();
                i.setId(rs.getInt("id"));
                i.setApplicationId(rs.getInt("application_id"));
                i.setStudentId(rs.getInt("student_id"));
                i.setJobId(rs.getInt("job_id"));
                Date d = rs.getDate("interview_date");
                if (d != null) i.setInterviewDate(d.toLocalDate());
                i.setInterviewTime(rs.getString("interview_time"));
                i.setMode(rs.getString("mode"));
                i.setLocation(rs.getString("location"));
                i.setNotes(rs.getString("notes"));
                i.setStatus(rs.getString("status"));
                list.add(i);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return list;
    }

    public void deleteInterview(int id) {
        String sql = "DELETE FROM interviews WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}