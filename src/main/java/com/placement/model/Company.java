package com.placement.model;

public class Company {
    private int id;
    private String name;
    private String industry;
    private String email;
    private String password;

    public Company() {}

    public Company(String name, String industry) {
        this.name = name;
        this.industry = industry;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getIndustry() { return industry; }
    public void setIndustry(String industry) { this.industry = industry; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    @Override
    public String toString() {
        return "Company [id=" + id + ", name=" + name + ", industry=" + industry + "]";
    }
}