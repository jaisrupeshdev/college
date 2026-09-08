package com.placement.main;

import java.util.Arrays;

import com.placement.dao.StudentDAO;
import com.placement.model.Student;
import com.placement.utils.DBConnection;

public class Main {
    public static void main(String[] args) {
        StudentDAO dao = new StudentDAO();

        // 🔥 Naya student insert karo (roll number unique hona chahiye)
        Student s1 = new Student(
            "Amit Singh",
            "CS2024002",          // naya roll number (pehle CS2024001 already inserted)
            "amit@example.com",
            "pass123",
            8.8,
            "Computer Science",
            Arrays.asList("C++", "DSA", "Algorithms")
        );

        dao.addStudent(s1);

        // Saare students print karo
        System.out.println("\n📋 Database me saare students:");
        for (Student s : dao.getAllStudents()) {
            System.out.println("👉 " + s.getName() + " (" + s.getRollNo() + ") - CGPA: " + s.getCgpa());
        }

        // Database connection close karo
        DBConnection.getInstance().closeConnection();
    }
}