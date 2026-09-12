package com.event.dao;

import com.event.config.DBConnection;
import com.event.model.VolunteerRole;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoleDao {

    public boolean addRole(VolunteerRole r) {
        String sql = "INSERT INTO volunteer_role (event_id, role_name, required_count, description) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, r.getEventId());
            ps.setString(2, r.getRoleName());
            ps.setInt(3, r.getRequiredCount());
            ps.setString(4, r.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<VolunteerRole> getRolesByEvent(int eventId) {
        List<VolunteerRole> list = new ArrayList<>();
        String sql = "SELECT vr.*, e.event_name FROM volunteer_role vr " +
                     "JOIN event e ON vr.event_id = e.event_id " +
                     "WHERE vr.event_id = ? ORDER BY vr.role_id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToRole(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<VolunteerRole> getAllRoles() {
        List<VolunteerRole> list = new ArrayList<>();
        String sql = "SELECT vr.*, e.event_name FROM volunteer_role vr " +
                     "JOIN event e ON vr.event_id = e.event_id " +
                     "ORDER BY vr.role_id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapResultSetToRole(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public VolunteerRole getById(int roleId) {
        String sql = "SELECT vr.*, e.event_name FROM volunteer_role vr " +
                     "JOIN event e ON vr.event_id = e.event_id " +
                     "WHERE vr.role_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToRole(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean deleteRole(int roleId) {
        String sql = "DELETE FROM volunteer_role WHERE role_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private VolunteerRole mapResultSetToRole(ResultSet rs) throws SQLException {
        VolunteerRole r = new VolunteerRole();
        r.setRoleId(rs.getInt("role_id"));
        r.setEventId(rs.getInt("event_id"));
        r.setRoleName(rs.getString("role_name"));
        r.setRequiredCount(rs.getInt("required_count"));
        r.setDescription(rs.getString("description"));
        try {
            r.setEventName(rs.getString("event_name"));
        } catch (SQLException ignored) {}
        return r;
    }
}
