package com.event.model;

public class Event {
    private int eventId;
    private String eventName;
    private String eventDate;
    private String venue;
    private String description;
    private String status;
    private String imageUrl;

    public Event() {}

    public Event(int eventId, String eventName, String eventDate, String venue, String description, String status) {
        this(eventId, eventName, eventDate, venue, description, status, "images/event_tech_conf.png");
    }

    public Event(int eventId, String eventName, String eventDate, String venue, String description, String status, String imageUrl) {
        this.eventId = eventId;
        this.eventName = eventName;
        this.eventDate = eventDate;
        this.venue = venue;
        this.description = description;
        this.status = status;
        this.imageUrl = imageUrl;
    }

    public int getEventId() { return eventId; }
    public void setEventId(int eventId) { this.eventId = eventId; }

    public String getEventName() { return eventName; }
    public void setEventName(String eventName) { this.eventName = eventName; }

    public String getEventDate() { return eventDate; }
    public void setEventDate(String eventDate) { this.eventDate = eventDate; }

    public String getVenue() { return venue; }
    public void setVenue(String venue) { this.venue = venue; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getImageUrl() { return imageUrl != null && !imageUrl.trim().isEmpty() ? imageUrl : "images/event_tech_conf.png"; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}
