package com.placement.service;

import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

import com.placement.dao.CompanyDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Company;
import com.placement.model.Student;

public class LoginService {

    private StudentDAO studentDAO = new StudentDAO();
    private CompanyDAO companyDAO = new CompanyDAO();

    // ============ PASSWORD HASHING ============
    
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
    }

    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) return false;
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (IllegalArgumentException e) {
            return plainPassword.equals(hashedPassword);
        }
    }

    // ============ ADMIN LOGIN ============
    // Username: College_Ad | Password: PlaceStudent
    
    public boolean adminLogin(String username, String password) {
        return username.equals("College_Ad") && password.equals("PlaceStudent");
    }

    // ============ STUDENT LOGIN ============
    // Email, Roll Number, YA Name — teeno se login kar sakta hai
    
    public Student studentLogin(String loginInput, String password) {
        List<Student> students = studentDAO.getAllStudents();
        for (Student s : students) {
            // Email YA Roll Number YA Name — teeno se match karo
            boolean emailMatch = s.getEmail() != null && s.getEmail().equalsIgnoreCase(loginInput);
            boolean rollMatch = s.getRollNo() != null && s.getRollNo().equalsIgnoreCase(loginInput);
            boolean nameMatch = s.getName() != null && s.getName().equalsIgnoreCase(loginInput);
            
            if (emailMatch || rollMatch || nameMatch) {
                if (verifyPassword(password, s.getPassword())) {
                    return s;
                }
            }
        }
        return null;
    }

    // ============ COMPANY LOGIN ============
    
    public Company companyLogin(String email, String password) {
        Company c = companyDAO.getCompanyByEmail(email);
        if (c != null) {
            if (verifyPassword(password, c.getPassword())) {
                return c;
            }
        }
        return null;
    }
}