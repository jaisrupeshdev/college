package com.placement.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.placement.model.Student;
import com.placement.utils.DBConnection;

public class StudentDAO {

    public void addStudent(Student student) {
        String sql = "INSERT INTO students (name, roll_no, email, password, cgpa, branch, skills) VALUES (?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, student.getName());
            pstmt.setString(2, student.getRollNo());
            pstmt.setString(3, student.getEmail());
            pstmt.setString(4, student.getPassword());
            pstmt.setDouble(5, student.getCgpa());
            pstmt.setString(6, student.getBranch());
            pstmt.setString(7, String.join(",", student.getSkills()));
            int rows = pstmt.executeUpdate();
            if (rows > 0) System.out.println("✅ Student added: " + student.getRollNo());
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT * FROM students";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                Student s = new Student();
                s.setId(rs.getInt("id"));
                s.setName(rs.getString("name"));
                s.setRollNo(rs.getString("roll_no"));
                s.setEmail(rs.getString("email"));
                s.setPassword(rs.getString("password"));
                s.setCgpa(rs.getDouble("cgpa"));
                s.setBranch(rs.getString("branch"));
                String skillsStr = rs.getString("skills");
                if (skillsStr != null && !skillsStr.isEmpty()) {
                    s.setSkills(Arrays.asList(skillsStr.split(",")));
                } else {
                    s.setSkills(new ArrayList<>());
                }
                s.setResumePath(rs.getString("resume_path"));
                students.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return students;
    }

    public void updateStudent(Student student) {
        String sql = "UPDATE students SET name=?, email=?, password=?, cgpa=?, branch=?, skills=?, resume_path=? WHERE id=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, student.getName());
            pstmt.setString(2, student.getEmail());
            pstmt.setString(3, student.getPassword());
            pstmt.setDouble(4, student.getCgpa());
            pstmt.setString(5, student.getBranch());
            pstmt.setString(6, String.join(",", student.getSkills()));
            pstmt.setString(7, student.getResumePath());
            pstmt.setInt(8, student.getId());
            int rows = pstmt.executeUpdate();
            if (rows > 0) System.out.println("✅ Student updated!");
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public Student getStudentById(int id) {
        String sql = "SELECT * FROM students WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                Student s = new Student();
                s.setId(rs.getInt("id"));
                s.setName(rs.getString("name"));
                s.setRollNo(rs.getString("roll_no"));
                s.setEmail(rs.getString("email"));
                s.setPassword(rs.getString("password"));
                s.setCgpa(rs.getDouble("cgpa"));
                s.setBranch(rs.getString("branch"));
                String skillsStr = rs.getString("skills");
                if (skillsStr != null && !skillsStr.isEmpty()) {
                    s.setSkills(Arrays.asList(skillsStr.split(",")));
                } else {
                    s.setSkills(new ArrayList<>());
                }
                s.setResumePath(rs.getString("resume_path"));
                return s;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return null;
    }

    public void deleteStudent(int id) {
        String sql = "DELETE FROM students WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            int rows = pstmt.executeUpdate();
            if (rows > 0) System.out.println("✅ Student deleted: ID " + id);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
    // ✅ OTP save karo (Forgot Password ke liye)
    public void saveResetToken(String email, String otp) {
        String sql = "UPDATE students SET reset_token=?, token_expiry=DATE_ADD(NOW(), INTERVAL 10 MINUTE) WHERE email=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, otp);
            pstmt.setString(2, email);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // ✅ OTP verify karo + password update karo
    public boolean resetPassword(String email, String otp, String newHashedPassword) {
        String sql = "UPDATE students SET password=?, reset_token=NULL, token_expiry=NULL WHERE email=? AND reset_token=? AND token_expiry > NOW()";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newHashedPassword);
            pstmt.setString(2, email);
            pstmt.setString(3, otp);
            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }

    // ✅ Check karo email exist karta hai ya nahi
    public boolean emailExists(String email) {
        String sql = "SELECT id FROM students WHERE email = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
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