package com.event.model;

public class VolunteerRole {
    private int roleId;
    private int eventId;
    private String roleName;
    private int requiredCount;
    private String description;
    private String eventName; // Helper display field

    public VolunteerRole() {}

    public VolunteerRole(int roleId, int eventId, String roleName, int requiredCount, String description) {
        this.roleId = roleId;
        this.eventId = eventId;
        this.roleName = roleName;
        this.requiredCount = requiredCount;
        this.description = description;
    }

    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }

    public int getRequiredCount() { return requiredCount; }
    public void setRequiredCount(int requiredCount) { this.requiredCount = requiredCount; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getEventName() { return eventName; }
    public void setEventName(String eventName) { this.eventName = eventName; }
}
