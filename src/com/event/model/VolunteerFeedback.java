package com.event.model;

public class VolunteerFeedback {
    private int feedbackId;
    private int assignmentId;
    private int rating;
    private String feedback;
    private String createdAt;

    // Helper display fields
    private String volunteerName;
    private String eventName;
    private String dutyTitle;

    public VolunteerFeedback() {}

    public int getFeedbackId() { return feedbackId; }
    public void setFeedbackId(int feedbackId) { this.feedbackId = feedbackId; }

    public int getAssignmentId() { return assignmentId; }
    public void setAssignmentId(int assignmentId) { this.assignmentId = assignmentId; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getFeedback() { return feedback; }
    public void setFeedback(String feedback) { this.feedback = feedback; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public String getVolunteerName() { return volunteerName; }
    public void setVolunteerName(String volunteerName) { this.volunteerName = volunteerName; }

    public String getEventName() { return eventName; }
    public void setEventName(String eventName) { this.eventName = eventName; }

    public String getDutyTitle() { return dutyTitle; }
    public void setDutyTitle(String dutyTitle) { this.dutyTitle = dutyTitle; }
}
