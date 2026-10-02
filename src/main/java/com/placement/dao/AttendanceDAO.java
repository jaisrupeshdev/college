package com.placement.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.placement.model.Attendance;
import com.placement.utils.DBConnection;

public class AttendanceDAO {

    // ✅ Mark attendance
    public boolean markAttendance(int eventId, int studentId) {
        String sql = "INSERT INTO event_attendance (event_id, student_id, status) VALUES (?, ?, 'PRESENT')";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, eventId);
            pstmt.setInt(2, studentId);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            // Duplicate entry = already marked
            System.out.println("Attendance mark failed (possibly already marked): " + e.getMessage());
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }

    // ✅ Check if student already marked attendance for an event
    public boolean hasMarked(int eventId, int studentId) {
        String sql = "SELECT id FROM event_attendance WHERE event_id = ? AND student_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, eventId);
            pstmt.setInt(2, studentId);
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

    // ✅ Get all attendance for an event (admin view)
    public List<Attendance> getAttendanceByEvent(int eventId) {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT * FROM event_attendance WHERE event_id = ? ORDER BY marked_at DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, eventId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Attendance a = new Attendance();
                a.setId(rs.getInt("id"));
                a.setEventId(rs.getInt("event_id"));
                a.setStudentId(rs.getInt("student_id"));
                a.setStatus(rs.getString("status"));
                Timestamp t = rs.getTimestamp("marked_at");
                if (t != null) a.setMarkedAt(t.toLocalDateTime());
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return list;
    }

    // ✅ Count attendance for event
    public int getAttendanceCount(int eventId) {
        String sql = "SELECT COUNT(*) FROM event_attendance WHERE event_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, eventId);
            rs = pstmt.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return 0;
    }
}