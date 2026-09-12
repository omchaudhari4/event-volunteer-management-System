package com.event.dao;

import com.event.config.DBConnection;
import com.event.model.Event;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventDao {

    public boolean addEvent(Event e) {
        String sql = "INSERT INTO event (event_name, event_date, venue, description, status, image_url) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, e.getEventName());
            ps.setString(2, e.getEventDate());
            ps.setString(3, e.getVenue());
            ps.setString(4, e.getDescription());
            ps.setString(5, e.getStatus() != null ? e.getStatus() : "Upcoming");
            ps.setString(6, e.getImageUrl());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public boolean updateEvent(Event e) {
        String sql = "UPDATE event SET event_name=?, event_date=?, venue=?, description=?, status=?, image_url=? WHERE event_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, e.getEventName());
            ps.setString(2, e.getEventDate());
            ps.setString(3, e.getVenue());
            ps.setString(4, e.getDescription());
            ps.setString(5, e.getStatus());
            ps.setString(6, e.getImageUrl());
            ps.setInt(7, e.getEventId());
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public Event getById(int id) {
        String sql = "SELECT * FROM event WHERE event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToEvent(rs);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public List<Event> getAllEvents() {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM event ORDER BY event_date ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapResultSetToEvent(rs));
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return list;
    }

    public boolean deleteEvent(int id) {
        String sql = "DELETE FROM event WHERE event_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public int getCount() {
        String sql = "SELECT COUNT(*) FROM event";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return 0;
    }

    private Event mapResultSetToEvent(ResultSet rs) throws SQLException {
        Event e = new Event();
        e.setEventId(rs.getInt("event_id"));
        e.setEventName(rs.getString("event_name"));
        e.setEventDate(rs.getString("event_date"));
        e.setVenue(rs.getString("venue"));
        e.setDescription(rs.getString("description"));
        e.setStatus(rs.getString("status"));
        try {
            e.setImageUrl(rs.getString("image_url"));
        } catch (SQLException ex) {
            e.setImageUrl("images/event_tech_conf.png");
        }
        return e;
    }
}
