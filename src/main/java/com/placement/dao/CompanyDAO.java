package com.placement.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.placement.model.Company;
import com.placement.utils.DBConnection;

public class CompanyDAO {

    public void addCompany(Company company) {
        String sql = "INSERT INTO companies (name, industry) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, company.getName());
            pstmt.setString(2, company.getIndustry());
            int rows = pstmt.executeUpdate();
            if (rows > 0) System.out.println("✅ Company added: " + company.getName());
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public void addCompanyWithLogin(Company company) {
        String sql = "INSERT INTO companies (name, industry, email, password) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, company.getName());
            pstmt.setString(2, company.getIndustry());
            pstmt.setString(3, company.getEmail());
            pstmt.setString(4, company.getPassword());
            int rows = pstmt.executeUpdate();
            if (rows > 0) System.out.println("✅ Company added (with login): " + company.getName());
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    public List<Company> getAllCompanies() {
        List<Company> companies = new ArrayList<>();
        String sql = "SELECT * FROM companies";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                Company c = new Company();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setIndustry(rs.getString("industry"));
                c.setEmail(rs.getString("email"));
                c.setPassword(rs.getString("password"));
                companies.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return companies;
    }

    public void deleteCompany(int id) {
        String sql = "DELETE FROM companies WHERE id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            int rows = pstmt.executeUpdate();
            if (rows > 0) System.out.println("✅ Company deleted: ID " + id);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // ✅ Email se company dhundo
    public Company getCompanyByEmail(String email) {
        String sql = "SELECT * FROM companies WHERE email = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                Company c = new Company();
                c.setId(rs.getInt("id"));
                c.setName(rs.getString("name"));
                c.setIndustry(rs.getString("industry"));
                c.setEmail(rs.getString("email"));
                c.setPassword(rs.getString("password"));
                return c;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        return null;
    }

    // ✅ Login method (deprecated - use LoginService instead)
    public Company login(String email, String password) {
        Company c = getCompanyByEmail(email);
        if (c != null && com.placement.service.LoginService.verifyPassword(password, c.getPassword())) {
            return c;
        }
        return null;
    }
    // ✅ Company update karo
    public void updateCompany(Company company) {
        String sql = "UPDATE companies SET name=?, industry=?, password=? WHERE id=?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBConnection.getInstance().getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, company.getName());
            pstmt.setString(2, company.getIndustry());
            pstmt.setString(3, company.getPassword());
            pstmt.setInt(4, company.getId());
            pstmt.executeUpdate();
            System.out.println("✅ Company updated: " + company.getName());
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}