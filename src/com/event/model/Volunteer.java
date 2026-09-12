package com.event.model;

public class Volunteer {
    private int volunteerId;
    private String name;
    private String email;
    private String password;
    private String contact;
    private String skills;
    private String status;
    private String avatarUrl;

    public Volunteer() {}

    public Volunteer(int volunteerId, String name, String email, String password, String contact, String skills, String status) {
        this(volunteerId, name, email, password, contact, skills, status, "images/avatar_default.png");
    }

    public Volunteer(int volunteerId, String name, String email, String password, String contact, String skills, String status, String avatarUrl) {
        this.volunteerId = volunteerId;
        this.name = name;
        this.email = email;
        this.password = password;
        this.contact = contact;
        this.skills = skills;
        this.status = status;
        this.avatarUrl = avatarUrl;
    }

    public int getVolunteerId() { return volunteerId; }
    public void setVolunteerId(int volunteerId) { this.volunteerId = volunteerId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }

    public String getSkills() { return skills; }
    public void setSkills(String skills) { this.skills = skills; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getAvatarUrl() { return avatarUrl != null && !avatarUrl.trim().isEmpty() ? avatarUrl : "images/avatar_default.png"; }
    public void setAvatarUrl(String avatarUrl) { this.avatarUrl = avatarUrl; }
}
