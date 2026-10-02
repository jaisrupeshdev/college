package com.placement.model;

import java.time.LocalDate;

public class Application {
    private int id;
    private int studentId;
    private int jobId;
    private String status;
    private LocalDate appliedDate;

    public Application() {}

    public Application(int studentId, int jobId, String status, LocalDate appliedDate) {
        this.studentId = studentId;
        this.jobId = jobId;
        this.status = status;
        this.appliedDate = appliedDate;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public int getJobId() { return jobId; }
    public void setJobId(int jobId) { this.jobId = jobId; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDate getAppliedDate() { return appliedDate; }
    public void setAppliedDate(LocalDate appliedDate) { this.appliedDate = appliedDate; }
}