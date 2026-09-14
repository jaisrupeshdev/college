package com.placement.main;

import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

import com.placement.dao.ApplicationDAO;
import com.placement.dao.CompanyDAO;
import com.placement.dao.JobDAO;
import com.placement.dao.StudentDAO;
import com.placement.model.Company;
import com.placement.model.Job;
import com.placement.model.Student;
import com.placement.service.LoginService;
import com.placement.service.ShortlistService;
import com.placement.utils.DBConnection;

public class Menu {

    static Scanner sc = new Scanner(System.in);
    static StudentDAO studentDAO = new StudentDAO();
    static CompanyDAO companyDAO = new CompanyDAO();
    static JobDAO jobDAO = new JobDAO();
    static ApplicationDAO applicationDAO = new ApplicationDAO();
    static ShortlistService shortlistService = new ShortlistService();

    public static void main(String[] args) {
        LoginService loginService = new LoginService();

        System.out.println("========= 🎓 PLACEMENT PORTAL LOGIN =========");
        System.out.println("1. Admin Login");
        System.out.println("2. Student Login");
        System.out.print("👉 Enter choice: ");
        int loginChoice = sc.nextInt();
        sc.nextLine();

        boolean loggedIn = false;

        if (loginChoice == 1) {
            System.out.print("Username: ");
            String user = sc.nextLine();
            System.out.print("Password: ");
            String pass = sc.nextLine();
            loggedIn = loginService.adminLogin(user, pass);
            if (loggedIn) System.out.println("✅ Admin login successful!");
            else System.out.println("❌ Invalid admin credentials!");
        } else if (loginChoice == 2) {
            System.out.print("Email: ");
            String email = sc.nextLine();
            System.out.print("Password: ");
            String pass = sc.nextLine();
            Student s = loginService.studentLogin(email, pass);
            if (s != null) {
                System.out.println("✅ Welcome, " + s.getName() + "!");
                loggedIn = true;
            } else {
                System.out.println("❌ Invalid email or password!");
            }
        }

        if (!loggedIn) {
            System.out.println("🚫 Login failed. Exiting...");
            DBConnection.getInstance().closeConnection();
            return;
        }

        // Main menu loop
        while (true) {
            System.out.println("\n========= 🎓 PLACEMENT PORTAL =========");
            System.out.println("1. Add New Student");
            System.out.println("2. View All Students");
            System.out.println("3. Add New Company");
            System.out.println("4. View All Companies");
            System.out.println("5. Add New Job");
            System.out.println("6. View All Jobs");
            System.out.println("7. Apply for a Job");
            System.out.println("8. View Shortlist for a Job");
            System.out.println("9. Exit");
            System.out.print("👉 Enter your choice: ");

            int choice = sc.nextInt();
            sc.nextLine();

            switch (choice) {
                case 1: addStudent(); break;
                case 2: viewStudents(); break;
                case 3: addCompany(); break;
                case 4: viewCompanies(); break;
                case 5: addJob(); break;
                case 6: viewJobs(); break;
                case 7: applyForJob(); break;
                case 8: viewShortlist(); break;
                case 9:
                    DBConnection.getInstance().closeConnection();
                    System.out.println("👋 Goodbye! See you again.");
                    System.exit(0);
                default: System.out.println("❌ Invalid choice! Try again.");
            }
        }
    }

    // --- 1. Add Student ---
    static void addStudent() {
        System.out.print("Name: ");
        String name = sc.nextLine();
        System.out.print("Roll No: ");
        String roll = sc.nextLine();
        System.out.print("Email: ");
        String email = sc.nextLine();
        System.out.print("Password: ");
        String pass = sc.nextLine();
        System.out.print("CGPA: ");
        double cgpa = sc.nextDouble();
        sc.nextLine();
        System.out.print("Branch: ");
        String branch = sc.nextLine();
        System.out.print("Skills (comma separated, e.g., Java,SQL): ");
        String skillsInput = sc.nextLine();
        List<String> skills = Arrays.asList(skillsInput.split(","));

        studentDAO.addStudent(new Student(name, roll, email, pass, cgpa, branch, skills));
    }

    // --- 2. View All Students ---
    static void viewStudents() {
        List<Student> list = studentDAO.getAllStudents();
        if (list.isEmpty()) {
            System.out.println("❌ No students found!");
            return;
        }
        System.out.println("\n📋 All Students:");
        for (Student s : list) {
            System.out.println("  ID: " + s.getId() + " | " + s.getName() + " (" + s.getRollNo() + ") | CGPA: " + s.getCgpa() + " | Branch: " + s.getBranch() + " | Skills: " + s.getSkills());
        }
    }

    // --- 3. Add Company ---
    static void addCompany() {
        System.out.print("Company Name: ");
        String name = sc.nextLine();
        System.out.print("Industry: ");
        String industry = sc.nextLine();
        companyDAO.addCompany(new Company(name, industry));
    }

    // --- 4. View All Companies ---
    static void viewCompanies() {
        List<Company> list = companyDAO.getAllCompanies();
        if (list.isEmpty()) {
            System.out.println("❌ No companies found!");
            return;
        }
        System.out.println("\n📋 All Companies:");
        for (Company c : list) {
            System.out.println("  ID: " + c.getId() + " | " + c.getName() + " | Industry: " + c.getIndustry());
        }
    }

    // --- 5. Add Job ---
    static void addJob() {
        System.out.print("Company ID: ");
        int companyId = sc.nextInt();
        sc.nextLine();
        System.out.print("Job Title: ");
        String title = sc.nextLine();
        System.out.print("Minimum CGPA: ");
        double minCgpa = sc.nextDouble();
        sc.nextLine();
        System.out.print("Eligible Branches (comma separated): ");
        List<String> branches = Arrays.asList(sc.nextLine().split(","));
        System.out.print("Required Skills (comma separated): ");
        List<String> skills = Arrays.asList(sc.nextLine().split(","));

        Job job = new Job(companyId, title, minCgpa, branches, skills);
        jobDAO.addJob(job);
    }

    // --- 6. View All Jobs ---
    static void viewJobs() {
        List<Job> list = jobDAO.getAllJobs();
        if (list.isEmpty()) {
            System.out.println("❌ No jobs found!");
            return;
        }
        System.out.println("\n📋 All Jobs:");
        for (Job j : list) {
            System.out.println("  ID: " + j.getId() + " | " + j.getTitle() + " | Min CGPA: " + j.getMinCgpa() + " | Branches: " + j.getEligibleBranches() + " | Skills: " + j.getRequiredSkills());
        }
    }

    // --- 7. Apply for Job ---
    static void applyForJob() {
        System.out.print("Student ID: ");
        int studentId = sc.nextInt();
        System.out.print("Job ID: ");
        int jobId = sc.nextInt();
        sc.nextLine();
        applicationDAO.applyForJob(studentId, jobId);
    }

    // --- 8. View Shortlist ---
    static void viewShortlist() {
        System.out.print("Enter Job ID: ");
        int jobId = sc.nextInt();
        sc.nextLine();

        List<Job> jobs = jobDAO.getAllJobs();
        Job selected = null;
        for (Job j : jobs) {
            if (j.getId() == jobId) {
                selected = j;
                break;
            }
        }
        if (selected == null) {
            System.out.println("❌ Job not found!");
            return;
        }

        List<Student> shortlisted = shortlistService.getShortlistedStudents(selected);
        System.out.println("\n🎯 Job: " + selected.getTitle());
        System.out.println("📋 Shortlisted Students (" + shortlisted.size() + "):");
        for (Student s : shortlisted) {
            System.out.println("   👉 " + s.getName() + " (" + s.getRollNo() + ") - CGPA: " + s.getCgpa());
        }
    }
}