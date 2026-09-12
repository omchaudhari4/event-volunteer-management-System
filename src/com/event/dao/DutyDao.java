package com.event.dao;

import com.event.config.DBConnection;
import com.event.model.DutyAssignment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DutyDao {

    public boolean assignDuty(DutyAssignment d) {
        String sql = "INSERT INTO duty_assignment (application_id, volunteer_id, event_id, duty_title, duty_location, start_time, end_time, status) VALUES (?, ?, ?, ?, ?, ?, ?, 'Assigned')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, d.getApplicationId());
            ps.setInt(2, d.getVolunteerId());
            ps.setInt(3, d.getEventId());
            ps.setString(4, d.getDutyTitle());
            ps.setString(5, d.getDutyLocation());
            ps.setString(6, d.getStartTime());
            ps.setString(7, d.getEndTime());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(int assignmentId, String status) {
        String sql = "UPDATE duty_assignment SET status = ? WHERE assignment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, assignmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<DutyAssignment> getAllDuties() {
        List<DutyAssignment> list = new ArrayList<>();
        String sql = "SELECT da.*, e.event_name, v.name as volunteer_name, vr.role_name " +
                     "FROM duty_assignment da " +
                     "JOIN event e ON da.event_id = e.event_id " +
                     "JOIN volunteer v ON da.volunteer_id = v.volunteer_id " +
                     "JOIN event_application ea ON da.application_id = ea.application_id " +
                     "JOIN volunteer_role vr ON ea.role_id = vr.role_id " +
                     "ORDER BY da.assignment_id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapResultSetToDuty(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<DutyAssignment> getByVolunteer(int volunteerId) {
        List<DutyAssignment> list = new ArrayList<>();
        String sql = "SELECT da.*, e.event_name, v.name as volunteer_name, vr.role_name " +
                     "FROM duty_assignment da " +
                     "JOIN event e ON da.event_id = e.event_id " +
                     "JOIN volunteer v ON da.volunteer_id = v.volunteer_id " +
                     "JOIN event_application ea ON da.application_id = ea.application_id " +
                     "JOIN volunteer_role vr ON ea.role_id = vr.role_id " +
                     "WHERE da.volunteer_id = ? " +
                     "ORDER BY da.assignment_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToDuty(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public DutyAssignment getById(int assignmentId) {
        String sql = "SELECT da.*, e.event_name, v.name as volunteer_name, vr.role_name " +
                     "FROM duty_assignment da " +
                     "JOIN event e ON da.event_id = e.event_id " +
                     "JOIN volunteer v ON da.volunteer_id = v.volunteer_id " +
                     "JOIN event_application ea ON da.application_id = ea.application_id " +
                     "JOIN volunteer_role vr ON ea.role_id = vr.role_id " +
                     "WHERE da.assignment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, assignmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToDuty(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private DutyAssignment mapResultSetToDuty(ResultSet rs) throws SQLException {
        DutyAssignment d = new DutyAssignment();
        d.setAssignmentId(rs.getInt("assignment_id"));
        d.setApplicationId(rs.getInt("application_id"));
        d.setVolunteerId(rs.getInt("volunteer_id"));
        d.setEventId(rs.getInt("event_id"));
        d.setDutyTitle(rs.getString("duty_title"));
        d.setDutyLocation(rs.getString("duty_location"));
        d.setStartTime(rs.getString("start_time"));
        d.setEndTime(rs.getString("end_time"));
        d.setStatus(rs.getString("status"));

        d.setEventName(rs.getString("event_name"));
        d.setVolunteerName(rs.getString("volunteer_name"));
        d.setRoleName(rs.getString("role_name"));
        return d;
    }
}
