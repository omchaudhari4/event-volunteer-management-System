package com.event.dao;

import com.event.config.DBConnection;
import com.event.model.EventApplication;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDao {

    public boolean applyEvent(int eventId, int volunteerId, int roleId, String remark) {
        String sql = "INSERT INTO event_application (event_id, volunteer_id, role_id, status, remark) VALUES (?, ?, ?, 'Pending', ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, volunteerId);
            ps.setInt(3, roleId);
            ps.setString(4, remark);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasAlreadyApplied(int eventId, int volunteerId) {
        String sql = "SELECT COUNT(*) FROM event_application WHERE event_id = ? AND volunteer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ps.setInt(2, volunteerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int applicationId, String status, String remark) {
        String sql = "UPDATE event_application SET status = ?, remark = ? WHERE application_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, remark);
            ps.setInt(3, applicationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<EventApplication> getAllApplications() {
        List<EventApplication> list = new ArrayList<>();
        String sql = "SELECT ea.*, e.event_name, v.name as volunteer_name, v.email as volunteer_email, vr.role_name " +
                     "FROM event_application ea " +
                     "JOIN event e ON ea.event_id = e.event_id " +
                     "JOIN volunteer v ON ea.volunteer_id = v.volunteer_id " +
                     "JOIN volunteer_role vr ON ea.role_id = vr.role_id " +
                     "ORDER BY ea.application_id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapResultSetToApplication(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<EventApplication> getByVolunteer(int volunteerId) {
        List<EventApplication> list = new ArrayList<>();
        String sql = "SELECT ea.*, e.event_name, v.name as volunteer_name, v.email as volunteer_email, vr.role_name " +
                     "FROM event_application ea " +
                     "JOIN event e ON ea.event_id = e.event_id " +
                     "JOIN volunteer v ON ea.volunteer_id = v.volunteer_id " +
                     "JOIN volunteer_role vr ON ea.role_id = vr.role_id " +
                     "WHERE ea.volunteer_id = ? " +
                     "ORDER BY ea.application_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToApplication(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public EventApplication getById(int applicationId) {
        String sql = "SELECT ea.*, e.event_name, v.name as volunteer_name, v.email as volunteer_email, vr.role_name " +
                     "FROM event_application ea " +
                     "JOIN event e ON ea.event_id = e.event_id " +
                     "JOIN volunteer v ON ea.volunteer_id = v.volunteer_id " +
                     "JOIN volunteer_role vr ON ea.role_id = vr.role_id " +
                     "WHERE ea.application_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, applicationId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToApplication(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int getCountByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM event_application WHERE status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private EventApplication mapResultSetToApplication(ResultSet rs) throws SQLException {
        EventApplication app = new EventApplication();
        app.setApplicationId(rs.getInt("application_id"));
        app.setEventId(rs.getInt("event_id"));
        app.setVolunteerId(rs.getInt("volunteer_id"));
        app.setRoleId(rs.getInt("role_id"));
        app.setAppliedDate(rs.getString("applied_date"));
        app.setStatus(rs.getString("status"));
        app.setRemark(rs.getString("remark"));

        app.setEventName(rs.getString("event_name"));
        app.setVolunteerName(rs.getString("volunteer_name"));
        app.setVolunteerEmail(rs.getString("volunteer_email"));
        app.setRoleName(rs.getString("role_name"));
        return app;
    }
}
