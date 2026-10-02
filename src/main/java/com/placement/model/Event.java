package com.placement.model;

import java.time.LocalDate;

public class Event {
    private int id;
    private String title;
    private String description;
    private LocalDate eventDate;
    private String venue;
    private int companyId;

    public Event() {}

    public Event(String title, String description, LocalDate eventDate, String venue, int companyId) {
        this.title = title;
        this.description = description;
        this.eventDate = eventDate;
        this.venue = venue;
        this.companyId = companyId;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public LocalDate getEventDate() { return eventDate; }
    public void setEventDate(LocalDate eventDate) { this.eventDate = eventDate; }
    public String getVenue() { return venue; }
    public void setVenue(String venue) { this.venue = venue; }
    public int getCompanyId() { return companyId; }
    public void setCompanyId(int companyId) { this.companyId = companyId; }
}