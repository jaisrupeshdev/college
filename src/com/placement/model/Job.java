package com.placement.model;

import java.util.List;

public class Job {
    private int id;
    private int companyId;
    private String title;
    private double minCgpa;
    private List<String> eligibleBranches;
    private List<String> requiredSkills;

    public Job() {}

    public Job(int companyId, String title, double minCgpa, List<String> eligibleBranches, List<String> requiredSkills) {
        this.companyId = companyId;
        this.title = title;
        this.minCgpa = minCgpa;
        this.eligibleBranches = eligibleBranches;
        this.requiredSkills = requiredSkills;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getCompanyId() { return companyId; }
    public void setCompanyId(int companyId) { this.companyId = companyId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public double getMinCgpa() { return minCgpa; }
    public void setMinCgpa(double minCgpa) { this.minCgpa = minCgpa; }
    public List<String> getEligibleBranches() { return eligibleBranches; }
    public void setEligibleBranches(List<String> eligibleBranches) { this.eligibleBranches = eligibleBranches; }
    public List<String> getRequiredSkills() { return requiredSkills; }
    public void setRequiredSkills(List<String> requiredSkills) { this.requiredSkills = requiredSkills; }
}