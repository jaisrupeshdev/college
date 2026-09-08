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

    // ✅ INSERT
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

            String skillsStr = String.join(",", student.getSkills());
            pstmt.setString(7, skillsStr);

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                System.out.println("✅ Student add ho gaya! Roll No: " + student.getRollNo());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // ✅ SELECT ALL
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
}