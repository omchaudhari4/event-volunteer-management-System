package com.event.dao;

import com.event.config.DBConnection;
import com.event.model.Volunteer;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VolunteerDao {

    public boolean registerVolunteer(Volunteer v) {
        String sql = "INSERT INTO volunteer (name, email, password, contact, skills, status, avatar_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getName());
            ps.setString(2, v.getEmail());
            ps.setString(3, v.getPassword());
            ps.setString(4, v.getContact());
            ps.setString(5, v.getSkills());
            ps.setString(6, "Active");
            ps.setString(7, v.getAvatarUrl());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Volunteer authenticate(String email, String password) {
        String sql = "SELECT * FROM volunteer WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToVolunteer(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Volunteer getById(int id) {
        String sql = "SELECT * FROM volunteer WHERE volunteer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToVolunteer(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Volunteer> getAllVolunteers() {
        List<Volunteer> list = new ArrayList<>();
        String sql = "SELECT * FROM volunteer ORDER BY volunteer_id DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapResultSetToVolunteer(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getCount() {
        String sql = "SELECT COUNT(*) FROM volunteer";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Volunteer mapResultSetToVolunteer(ResultSet rs) throws SQLException {
        Volunteer v = new Volunteer();
        v.setVolunteerId(rs.getInt("volunteer_id"));
        v.setName(rs.getString("name"));
        v.setEmail(rs.getString("email"));
        v.setPassword(rs.getString("password"));
        v.setContact(rs.getString("contact"));
        v.setSkills(rs.getString("skills"));
        v.setStatus(rs.getString("status"));
        try {
            v.setAvatarUrl(rs.getString("avatar_url"));
        } catch (SQLException ex) {
            v.setAvatarUrl("images/avatar_default.png");
        }
        return v;
    }
}
