package com.placement.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.placement.model.Job;
import com.placement.utils.DBConnection;

public class JobDAO {

    public void addJob(Job job) {
        String sql = "INSERT INTO jobs (company_id, title, min_cgpa, eligible_branches, required_skills) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, job.getCompanyId());
            pstmt.setString(2, job.getTitle());
            pstmt.setDouble(3, job.getMinCgpa());

            String branchesStr = String.join(",", job.getEligibleBranches());
            String skillsStr = String.join(",", job.getRequiredSkills());

            pstmt.setString(4, branchesStr);
            pstmt.setString(5, skillsStr);

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                System.out.println("✅ Job add ho gayi! Title: " + job.getTitle());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public List<Job> getAllJobs() {
        List<Job> jobs = new ArrayList<>();
        String sql = "SELECT * FROM jobs";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                Job j = new Job();
                j.setId(rs.getInt("id"));
                j.setCompanyId(rs.getInt("company_id"));
                j.setTitle(rs.getString("title"));
                j.setMinCgpa(rs.getDouble("min_cgpa"));

                String branchesStr = rs.getString("eligible_branches");
                if (branchesStr != null && !branchesStr.isEmpty()) {
                    j.setEligibleBranches(Arrays.asList(branchesStr.split(",")));
                } else {
                    j.setEligibleBranches(new ArrayList<>());
                }

                String skillsStr = rs.getString("required_skills");
                if (skillsStr != null && !skillsStr.isEmpty()) {
                    j.setRequiredSkills(Arrays.asList(skillsStr.split(",")));
                } else {
                    j.setRequiredSkills(new ArrayList<>());
                }

                jobs.add(j);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return jobs;
    }
}