package com.event.model;

public class Attendance {
    private int attendanceId;
    private int assignmentId;
    private String checkIn;
    private String checkOut;
    private String status; // Present, Absent

    // Helper display fields
    private String volunteerName;
    private String eventName;
    private String dutyTitle;

    public Attendance() {}

    public int getAttendanceId() { return attendanceId; }
    public void setAttendanceId(int attendanceId) { this.attendanceId = attendanceId; }

    public int getAssignmentId() { return assignmentId; }
    public void setAssignmentId(int assignmentId) { this.assignmentId = assignmentId; }

    public String getCheckIn() { return checkIn; }
    public void setCheckIn(String checkIn) { this.checkIn = checkIn; }

    public String getCheckOut() { return checkOut; }
    public void setCheckOut(String checkOut) { this.checkOut = checkOut; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getVolunteerName() { return volunteerName; }
    public void setVolunteerName(String volunteerName) { this.volunteerName = volunteerName; }

    public String getEventName() { return eventName; }
    public void setEventName(String eventName) { this.eventName = eventName; }

    public String getDutyTitle() { return dutyTitle; }
    public void setDutyTitle(String dutyTitle) { this.dutyTitle = dutyTitle; }
}
