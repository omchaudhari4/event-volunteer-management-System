package com.event.dao;

import com.event.config.DBConnection;
import com.event.model.Attendance;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AttendanceDao {

    public boolean recordCheckIn(int assignmentId) {
        // Check if existing record exists
        Attendance existing = getByAssignmentId(assignmentId);
        if (existing != null) {
            String sql = "UPDATE attendance SET check_in = CURRENT_TIMESTAMP, status = 'Present' WHERE assignment_id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, assignmentId);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            String sql = "INSERT INTO attendance (assignment_id, check_in, status) VALUES (?, CURRENT_TIMESTAMP, 'Present')";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, assignmentId);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    public boolean recordCheckOut(int assignmentId) {
        String sql = "UPDATE attendance SET check_out = CURRENT_TIMESTAMP WHERE assignment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, assignmentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Attendance getByAssignmentId(int assignmentId) {
        String sql = "SELECT att.*, v.name as volunteer_name, e.event_name, da.duty_title " +
                     "FROM attendance att " +
                     "JOIN duty_assignment da ON att.assignment_id = da.assignment_id " +
                     "JOIN volunteer v ON da.volunteer_id = v.volunteer_id " +
                     "JOIN event e ON da.event_id = e.event_id " +
                     "WHERE att.assignment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, assignmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToAttendance(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Attendance> getAllAttendance() {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT att.*, v.name as volunteer_name, e.event_name, da.duty_title " +
                     "FROM attendance att " +
                     "JOIN duty_assignment da ON att.assignment_id = da.assignment_id " +
                     "JOIN volunteer v ON da.volunteer_id = v.volunteer_id " +
                     "JOIN event e ON da.event_id = e.event_id " +
                     "ORDER BY att.attendance_id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapResultSetToAttendance(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Attendance> getByVolunteer(int volunteerId) {
        List<Attendance> list = new ArrayList<>();
        String sql = "SELECT att.*, v.name as volunteer_name, e.event_name, da.duty_title " +
                     "FROM attendance att " +
                     "JOIN duty_assignment da ON att.assignment_id = da.assignment_id " +
                     "JOIN volunteer v ON da.volunteer_id = v.volunteer_id " +
                     "JOIN event e ON da.event_id = e.event_id " +
                     "WHERE da.volunteer_id = ? " +
                     "ORDER BY att.attendance_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, volunteerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToAttendance(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Attendance mapResultSetToAttendance(ResultSet rs) throws SQLException {
        Attendance a = new Attendance();
        a.setAttendanceId(rs.getInt("attendance_id"));
        a.setAssignmentId(rs.getInt("assignment_id"));
        a.setCheckIn(rs.getString("check_in"));
        a.setCheckOut(rs.getString("check_out"));
        a.setStatus(rs.getString("status"));

        a.setVolunteerName(rs.getString("volunteer_name"));
        a.setEventName(rs.getString("event_name"));
        a.setDutyTitle(rs.getString("duty_title"));
        return a;
    }
}
