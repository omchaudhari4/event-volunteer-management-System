package com.event.model;

public class DutyAssignment {
    private int assignmentId;
    private int applicationId;
    private int volunteerId;
    private int eventId;
    private String dutyTitle;
    private String dutyLocation;
    private String startTime;
    private String endTime;
    private String status; // Assigned, In Progress, Completed

    // Helper display fields
    private String eventName;
    private String volunteerName;
    private String roleName;

    public DutyAssignment() {}

    public int getAssignmentId() { return assignmentId; }
    public void setAssignmentId(int assignmentId) { this.assignmentId = assignmentId; }

    public int getApplicationId() { return applicationId; }
    public void setApplicationId(int applicationId) { this.applicationId = applicationId; }

    public int getVolunteerId() { return volunteerId; }
    public void setVolunteerId(int volunteerId) { this.volunteerId = volunteerId; }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public String getDutyTitle() { return dutyTitle; }
    public void setDutyTitle(String dutyTitle) { this.dutyTitle = dutyTitle; }

    public String getDutyLocation() { return dutyLocation; }
    public void setDutyLocation(String dutyLocation) { this.dutyLocation = dutyLocation; }

    public String getStartTime() { return startTime; }
    public void setStartTime(String startTime) { this.startTime = startTime; }

    public String getEndTime() { return endTime; }
    public void setEndTime(String endTime) { this.endTime = endTime; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getEventName() { return eventName; }
    public void setEventName(String eventName) { this.eventName = eventName; }

    public String getVolunteerName() { return volunteerName; }
    public void setVolunteerName(String volunteerName) { this.volunteerName = volunteerName; }

    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }
}
