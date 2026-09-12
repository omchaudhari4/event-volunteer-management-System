package com.event.dao;

import com.event.config.DBConnection;
import com.event.model.VolunteerFeedback;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDao {

    public boolean addFeedback(int assignmentId, int rating, String feedbackText) {
        String sql = "INSERT INTO volunteer_feedback (assignment_id, rating, feedback, created_at) VALUES (?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, assignmentId);
            ps.setInt(2, rating);
            ps.setString(3, feedbackText);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<VolunteerFeedback> getAllFeedback() {
        List<VolunteerFeedback> list = new ArrayList<>();
        String sql = "SELECT fb.*, v.name as volunteer_name, e.event_name, da.duty_title " +
                     "FROM volunteer_feedback fb " +
                     "JOIN duty_assignment da ON fb.assignment_id = da.assignment_id " +
                     "JOIN volunteer v ON da.volunteer_id = v.volunteer_id " +
                     "JOIN event e ON da.event_id = e.event_id " +
                     "ORDER BY fb.feedback_id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapResultSetToFeedback(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<VolunteerFeedback> getByVolunteer(int volunteerId) {
        List<VolunteerFeedback> list = new ArrayList<>();
        String sql = "SELECT fb.*, v.name as volunteer_name, e.event_name, da.duty_title " +
                     "FROM volunteer_feedback fb " +
                     "JOIN duty_assignment da ON fb.assignment_id = da.assignment_id " +
                     "JOIN volunteer v ON da.volunteer_id = v.volunteer_id " +
                     "JOIN event e ON da.event_id = e.event_id " +
                     "WHERE da.volunteer_id = ? " +
                     "ORDER BY fb.feedback_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToFeedback(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private VolunteerFeedback mapResultSetToFeedback(ResultSet rs) throws SQLException {
        VolunteerFeedback f = new VolunteerFeedback();
        f.setFeedbackId(rs.getInt("feedback_id"));
        f.setAssignmentId(rs.getInt("assignment_id"));
        f.setRating(rs.getInt("rating"));
        f.setFeedback(rs.getString("feedback"));
        f.setCreatedAt(rs.getString("created_at"));

        f.setVolunteerName(rs.getString("volunteer_name"));
        f.setEventName(rs.getString("event_name"));
        f.setDutyTitle(rs.getString("duty_title"));
        return f;
    }
}
