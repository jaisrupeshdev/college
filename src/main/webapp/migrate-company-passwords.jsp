<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.placement.dao.CompanyDAO" %>
<%@ page import="com.placement.model.Company" %>
<%@ page import="com.placement.service.LoginService" %>
<%@ page import="com.placement.utils.DBConnection" %>
<%@ page import="java.sql.*" %>
<%
    StringBuilder log = new StringBuilder();
    List<Company> companies = new CompanyDAO().getAllCompanies();
    Connection conn = DBConnection.getInstance().getConnection();
    int updated = 0;

    for (Company c : companies) {
        String pwd = c.getPassword();
        if (pwd == null || pwd.isEmpty()) {
            log.append("SKIP ").append(c.getName()).append(" (NULL)<br>");
            continue;
        }
        if (pwd.startsWith("$2a$") || pwd.startsWith("$2b$")) {
            log.append("SKIP ").append(c.getName()).append(" (hashed)<br>");
            continue;
        }
        String hashed = LoginService.hashPassword(pwd);
        PreparedStatement ps = conn.prepareStatement("UPDATE companies SET password=? WHERE id=?");
        ps.setString(1, hashed);
        ps.setInt(2, c.getId());
        ps.executeUpdate();
        ps.close();
        updated++;
        log.append("HASHED ").append(c.getName()).append(" (").append(c.getEmail()).append(")<br>");
    }
%>
<!DOCTYPE html>
<html><head><title>Migrate</title></head>
<body style="font-family:monospace;padding:20px;">
<h2>Company Password Migration</h2>
<p><b>Updated:</b> <%= updated %></p>
<div><%= log.toString() %></p></div>
<p style="color:red;">Delete this file after use!</p>
</body></html>