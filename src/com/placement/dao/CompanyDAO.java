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

    // ✅ Company insert karo
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
            if (rows > 0) {
                System.out.println("✅ Company add ho gayi! Name: " + company.getName());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // ✅ Saari companies fetch karo
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
}