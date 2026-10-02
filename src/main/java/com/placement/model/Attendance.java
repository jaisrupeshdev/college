package com.placement.model;

import java.time.LocalDateTime;

public class Attendance {
    private int id;
    private int eventId;
    private int studentId;
    private LocalDateTime markedAt;
    private String status;

    public Attendance() {}

    public Attendance(int eventId, int studentId, String status) {
        this.eventId = eventId;
        this.studentId = studentId;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }
    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }
    public LocalDateTime getMarkedAt() { return markedAt; }
    public void setMarkedAt(LocalDateTime markedAt) { this.markedAt = markedAt; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}