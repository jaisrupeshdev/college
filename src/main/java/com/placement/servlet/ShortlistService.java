package com.placement.servlet;

import java.util.List;
import java.util.stream.Collectors;

import com.placement.dao.StudentDAO;
import com.placement.model.Job;
import com.placement.model.Student;

public class ShortlistService {

    private StudentDAO studentDAO = new StudentDAO();

    public List<Student> getShortlistedStudents(Job job) {
        List<Student> allStudents = studentDAO.getAllStudents();

        List<Student> shortlisted = allStudents.stream()
            .filter(s -> s.getCgpa() >= job.getMinCgpa())
            .filter(s -> job.getEligibleBranches().contains(s.getBranch()))
            .filter(s -> s.getSkills().containsAll(job.getRequiredSkills()))
            .collect(Collectors.toList());

        return shortlisted;
    }

    public long getShortlistCount(Job job) {
        return getShortlistedStudents(job).size();
    }
}