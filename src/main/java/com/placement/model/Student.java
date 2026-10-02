package com.placement.model;

import java.util.List;

public class Student {
    private int id;
    private String name;
    private String rollNo;
    private String email;
    private String password;
    private double cgpa;
    private String branch;
    private List<String> skills;
    private String resumePath;

    public Student() {}

    public Student(String name, String rollNo, String email, String password, double cgpa, String branch, List<String> skills) {
        this.name = name;
        this.rollNo = rollNo;
        this.email = email;
        this.password = password;
        this.cgpa = cgpa;
        this.branch = branch;
        this.skills = skills;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getRollNo() { return rollNo; }
    public void setRollNo(String rollNo) { this.rollNo = rollNo; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public double getCgpa() { return cgpa; }
    public void setCgpa(double cgpa) { this.cgpa = cgpa; }
    public String getBranch() { return branch; }
    public void setBranch(String branch) { this.branch = branch; }
    public List<String> getSkills() { return skills; }
    public void setSkills(List<String> skills) { this.skills = skills; }
    public String getResumePath() { return resumePath; }
    public void setResumePath(String resumePath) { this.resumePath = resumePath; }

    @Override
    public String toString() {
        return "Student [id=" + id + ", name=" + name + ", rollNo=" + rollNo + ", cgpa=" + cgpa + ", branch=" + branch + "]";
    }
}