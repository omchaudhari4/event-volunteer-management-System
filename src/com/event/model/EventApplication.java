package com.event.model;

public class EventApplication {
    private int applicationId;
    private int eventId;
    private int volunteerId;
    private int roleId;
    private String appliedDate;
    private String status; // Pending, Approved, Rejected
    private String remark;

    // Helper display attributes for joining in JSP/DAO
    private String eventName;
    private String volunteerName;
    private String volunteerEmail;
    private String roleName;

    public EventApplication() {}

    public int getApplicationId() { return applicationId; }
    public void setApplicationId(int applicationId) { this.applicationId = applicationId; }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public int getVolunteerId() { return volunteerId; }
    public void setVolunteerId(int volunteerId) { this.volunteerId = volunteerId; }

    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }

    public String getAppliedDate() { return appliedDate; }
    public void setAppliedDate(String appliedDate) { this.appliedDate = appliedDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }

    public String getEventName() { return eventName; }
    public void setEventName(String eventName) { this.eventName = eventName; }

    public String getVolunteerName() { return volunteerName; }
    public void setVolunteerName(String volunteerName) { this.volunteerName = volunteerName; }

    public String getVolunteerEmail() { return volunteerEmail; }
    public void setVolunteerEmail(String volunteerEmail) { this.volunteerEmail = volunteerEmail; }

    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }
}
