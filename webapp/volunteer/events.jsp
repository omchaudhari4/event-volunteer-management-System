<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.event.dao.*, com.event.model.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (!"VOLUNTEER".equals(role)) {
        response.sendRedirect("../login.jsp");
        return;
    }

    String userName = (String) session.getAttribute("userName");
    EventDao eventDao = new EventDao();
    RoleDao roleDao = new RoleDao();

    List<Event> eventList = eventDao.getAllEvents();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Events - Volunteer Portal</title>
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <nav class="navbar">
        <a href="events.jsp" class="brand">
            <div class="brand-icon"><i class="fa-solid fa-hands-holding-child"></i></div>
            <span class="brand-title">EventVolunteer</span>
            <span class="nav-badge">Volunteer Portal</span>
        </a>
        <ul class="nav-links">
            <li><a href="events.jsp" class="nav-link active"><i class="fa-solid fa-calendar-days"></i> Available Events</a></li>
            <li><a href="my-applications.jsp" class="nav-link"><i class="fa-solid fa-file-lines"></i> My Applications</a></li>
            <li><a href="my-duty.jsp" class="nav-link"><i class="fa-solid fa-user-gear"></i> Assigned Duty</a></li>
            <li><a href="attendance.jsp" class="nav-link"><i class="fa-solid fa-clock"></i> Attendance</a></li>
            <li><a href="history.jsp" class="nav-link"><i class="fa-solid fa-history"></i> History & Feedback</a></li>
        </ul>
        <div class="user-menu">
            <div style="text-align: right;">
                <div style="font-weight: 700; font-size: 0.9rem;"><%= userName != null ? userName : "Volunteer" %></div>
            </div>
            <a href="../LogoutServlet" class="btn btn-secondary btn-sm"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <div>
                <h1 class="page-title">Explore Open Events</h1>
                <p class="page-subtitle">Select an event below to view open volunteer roles and submit your application.</p>
            </div>
        </div>

        <% if ("error".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-danger"><i class="fa-solid fa-circle-exclamation"></i> Error submitting application.</div>
        <% } %>

        <% if (eventList.isEmpty()) { %>
            <div class="glass-panel">
                <div class="empty-state">
                    <div class="empty-icon"><i class="fa-regular fa-calendar-xmark"></i></div>
                    <div class="empty-title">No Available Events Right Now</div>
                    <div class="empty-desc">Coordinators have not published any open events yet. Please check back soon!</div>
                </div>
            </div>
        <% } else { %>
            <div class="cards-grid">
                <% for (Event e : eventList) { 
                    List<VolunteerRole> roles = roleDao.getRolesByEvent(e.getEventId());
                    String st = e.getStatus() != null ? e.getStatus() : "Upcoming";
                %>
                    <div class="glass-panel event-card" style="padding: 1.5rem; display: flex; flex-direction: column;">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.75rem;">
                            <h3 class="event-card-title"><%= e.getEventName() %></h3>
                            <span class="badge badge-<%= st.toLowerCase().replace(" ", "-") %>"><%= st %></span>
                        </div>
                        <div class="event-meta" style="margin-bottom: 0.75rem;">
                            <div class="event-meta-item"><i class="fa-regular fa-calendar" style="color: var(--accent-primary);"></i> <%= e.getEventDate() %></div>
                            <div class="event-meta-item"><i class="fa-solid fa-location-dot" style="color: #ec4899;"></i> <%= e.getVenue() %></div>
                        </div>
                        <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 1.25rem; line-height: 1.5;">
                                <%= e.getDescription() != null ? e.getDescription() : "No detailed description provided." %>
                            </p>

                            <!-- Role Badges -->
                            <div style="margin-bottom: 1.5rem; margin-top: auto;">
                                <div style="font-size: 0.8rem; font-weight: 700; color: var(--text-muted); text-transform: uppercase; margin-bottom: 0.5rem;">Open Volunteer Roles (<%= roles.size() %>):</div>
                                <% if (roles.isEmpty()) { %>
                                    <span style="font-size: 0.85rem; color: var(--text-muted); font-style: italic;">Roles pending coordinator assignment</span>
                                <% } else { %>
                                    <div style="display: flex; flex-wrap: wrap; gap: 0.4rem;">
                                        <% for (VolunteerRole r : roles) { %>
                                            <span class="nav-badge"><%= r.getRoleName() %> (<%= r.getRequiredCount() %>)</span>
                                        <% } %>
                                    </div>
                                <% } %>
                            </div>

                            <div>
                                <a href="apply-event.jsp?eventId=<%= e.getEventId() %>" class="btn btn-primary" style="width: 100%; justify-content: center;" <%= roles.isEmpty() ? "disabled style='pointer-events:none; opacity:0.5;'" : "" %>>
                                    <i class="fa-solid fa-paper-plane"></i> Apply for Role
                                </a>
                            </div>
                        </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <footer class="footer">
        &copy; 2026 Event Volunteer Management System.
    </footer>

    <script src="../js/main.js"></script>
</body>
</html>
