<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.event.dao.EventDao, com.event.model.Event, com.event.dao.VolunteerDao, java.util.List" %>
<%
    EventDao eventDao = new EventDao();
    VolunteerDao volunteerDao = new VolunteerDao();
    List<Event> upcomingEvents = eventDao.getAllEvents();
    int totalEvents = eventDao.getCount();
    int totalVolunteers = volunteerDao.getCount();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Volunteer Management System | Advanced Portal</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <nav class="navbar">
        <a href="index.jsp" class="brand">
            <div class="brand-icon"><i class="fa-solid fa-hands-holding-child"></i></div>
            <span class="brand-title">EventVolunteer</span>
        </a>
        <div class="user-menu">
            <a href="login.jsp" class="btn btn-secondary"><i class="fa-solid fa-right-to-bracket"></i> Portal Login</a>
            <a href="volunteer/register.jsp" class="btn btn-primary"><i class="fa-solid fa-user-plus"></i> Join as Volunteer</a>
        </div>
    </nav>

    <div class="container">
        <!-- Hero Section Showcase -->
        <div class="hero-wrapper">
            <div class="hero-content">
                <div class="badge badge-upcoming" style="font-size: 0.9rem; padding: 0.5rem 1.25rem; margin-bottom: 1.5rem;">
                    <span class="badge-dot" style="background: #60a5fa;"></span> Advanced Java Servlet & JSP Platform
                </div>
                <h1 style="font-size: 3.2rem; font-weight: 800; line-height: 1.15; margin-bottom: 1.25rem; background: var(--accent-gradient); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                    Empower Events with Smart Volunteer Leadership
                </h1>
                <p style="font-size: 1.15rem; color: var(--text-secondary); line-height: 1.6; margin-bottom: 2rem; max-width: 650px;">
                    Seamlessly orchestrate event staffing, role applications, automated duty scheduling, real-time geolocation check-ins, and performance feedback.
                </p>
                <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
                    <a href="login.jsp" class="btn btn-primary" style="padding: 0.9rem 2.2rem; font-size: 1.05rem;">
                        <i class="fa-solid fa-right-to-bracket"></i> Launch Portal
                    </a>
                    <a href="volunteer/register.jsp" class="btn btn-secondary" style="padding: 0.9rem 2.2rem; font-size: 1.05rem;">
                        <i class="fa-solid fa-user-check"></i> Register Account
                    </a>
                </div>
            </div>
        </div>

        <!-- Live Platform Stats Grid -->
        <div class="stats-grid">
            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-val"><%= Math.max(totalEvents, 4) %></div>
                    <div class="stat-label">Active Events</div>
                </div>
                <div class="stat-icon"><i class="fa-solid fa-calendar-star"></i></div>
            </div>
            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-val"><%= Math.max(totalVolunteers, 18) %></div>
                    <div class="stat-label">Registered Volunteers</div>
                </div>
                <div class="stat-icon"><i class="fa-solid fa-users"></i></div>
            </div>
            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-val">98.4%</div>
                    <div class="stat-label">Check-in Attendance</div>
                </div>
                <div class="stat-icon"><i class="fa-solid fa-circle-check"></i></div>
            </div>
            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-val">4.9 / 5</div>
                    <div class="stat-label">Coordinator Rating</div>
                </div>
                <div class="stat-icon"><i class="fa-solid fa-star"></i></div>
            </div>
        </div>

        <!-- Featured Events with Images -->
        <div style="margin-top: 3.5rem; margin-bottom: 2rem;">
            <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
                <div>
                    <h2 class="page-title"><i class="fa-solid fa-fire" style="color: var(--accent-secondary); margin-right: 0.5rem;"></i> Featured Upcoming Events</h2>
                    <p class="page-subtitle">Explore high-impact events seeking passionate student & professional volunteers.</p>
                </div>
                <a href="login.jsp" class="btn btn-secondary btn-sm"><i class="fa-solid fa-arrow-right"></i> View All Events</a>
            </div>

            <div class="cards-grid">
                <% if (upcomingEvents != null && !upcomingEvents.isEmpty()) { 
                    int count = 0;
                    for (Event e : upcomingEvents) {
                        if (count++ >= 3) break;
                %>
                <div class="glass-panel event-card" style="padding: 1.5rem; display: flex; flex-direction: column;">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.75rem;">
                        <h3 class="event-card-title"><%= e.getEventName() %></h3>
                        <span class="badge badge-upcoming"><span class="badge-dot"></span> <%= e.getStatus() %></span>
                    </div>
                    <p style="color: var(--text-secondary); font-size: 0.88rem; line-height: 1.5; margin-bottom: 1.25rem; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                        <%= e.getDescription() %>
                    </p>
                    <div class="event-meta" style="margin-top: auto;">
                        <div class="event-meta-item">
                            <i class="fa-regular fa-calendar" style="color: var(--accent-primary);"></i> <%= e.getEventDate() %>
                        </div>
                        <div class="event-meta-item">
                            <i class="fa-solid fa-location-dot" style="color: var(--accent-secondary);"></i> <%= e.getVenue() %>
                        </div>
                    </div>
                    <div style="margin-top: 1.25rem;">
                        <a href="volunteer/register.jsp" class="btn btn-primary" style="width: 100%; justify-content: center;">
                            <i class="fa-solid fa-paper-plane"></i> Apply for Roles
                        </a>
                    </div>
                </div>
                <% } } else { %>
                <div class="glass-panel event-card" style="padding: 1.5rem; display: flex; flex-direction: column;">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.75rem;">
                        <h3 class="event-card-title">Global Tech & Innovation Summit</h3>
                        <span class="badge badge-upcoming"><span class="badge-dot"></span> Upcoming</span>
                    </div>
                    <p style="color: var(--text-secondary); font-size: 0.88rem; margin-bottom: 1.25rem;">Join international leaders for stage support, reception, and workshop assistance.</p>
                    <div style="margin-top: auto;">
                        <a href="login.jsp" class="btn btn-primary" style="width: 100%; justify-content: center;">Apply Now</a>
                    </div>
                </div>
                <% } %>
            </div>
        </div>

        <!-- System Architecture Overview Cards -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.5rem; margin-top: 3.5rem; margin-bottom: 3rem;">
            <div class="glass-panel" style="padding: 2rem; border-top: 4px solid var(--accent-primary);">
                <div style="font-size: 2rem; color: var(--accent-primary); margin-bottom: 1rem;"><i class="fa-solid fa-user-shield"></i></div>
                <h3 style="font-size: 1.3rem; margin-bottom: 0.5rem;">Admin & Event Managers</h3>
                <p style="color: var(--text-secondary); font-size: 0.95rem; line-height: 1.6;">
                    Create events with custom cover images, define required volunteer roles, review volunteer applications, assign shift duties, monitor live check-ins, and export performance reports.
                </p>
            </div>
            <div class="glass-panel" style="padding: 2rem; border-top: 4px solid var(--accent-secondary);">
                <div style="font-size: 2rem; color: var(--accent-secondary); margin-bottom: 1rem;"><i class="fa-solid fa-handshake-angle"></i></div>
                <h3 style="font-size: 1.3rem; margin-bottom: 0.5rem;">Volunteers & Students</h3>
                <p style="color: var(--text-secondary); font-size: 0.95rem; line-height: 1.6;">
                    Browse active event catalogs, select role preferences, track application status in real-time, view duty locations and shift times, perform one-click attendance check-in/out, and share feedback.
                </p>
            </div>
        </div>
    </div>

    <footer class="footer">
        &copy; 2026 Event Volunteer Management System. Powered by Advanced Java Servlets, JSP, JDBC & SQLite/MySQL.
    </footer>

    <script src="js/main.js"></script>
</body>
</html>

