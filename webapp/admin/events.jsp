<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.event.dao.*, com.event.model.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (!"ADMIN".equals(role)) {
        response.sendRedirect("../login.jsp");
        return;
    }

    EventDao eventDao = new EventDao();
    List<Event> eventList = eventDao.getAllEvents();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Events - Admin</title>
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <nav class="navbar">
        <a href="dashboard.jsp" class="brand">
            <div class="brand-icon"><i class="fa-solid fa-hands-holding-child"></i></div>
            <span class="brand-title">EventVolunteer</span>
            <span class="nav-badge">Coordinator Portal</span>
        </a>
        <ul class="nav-links">
            <li><a href="dashboard.jsp" class="nav-link"><i class="fa-solid fa-chart-pie"></i> Dashboard</a></li>
            <li><a href="events.jsp" class="nav-link active"><i class="fa-solid fa-calendar-days"></i> Events</a></li>
            <li><a href="volunteer-roles.jsp" class="nav-link"><i class="fa-solid fa-user-tag"></i> Roles</a></li>
            <li><a href="applications.jsp" class="nav-link"><i class="fa-solid fa-file-signature"></i> Applications</a></li>
            <li><a href="assign-duty.jsp" class="nav-link"><i class="fa-solid fa-clipboard-list"></i> Duties</a></li>
            <li><a href="attendance.jsp" class="nav-link"><i class="fa-solid fa-clock-rotate-left"></i> Attendance</a></li>
            <li><a href="reports.jsp" class="nav-link"><i class="fa-solid fa-chart-line"></i> Reports</a></li>
        </ul>
        <div class="user-menu">
            <a href="../LogoutServlet" class="btn btn-secondary btn-sm"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <div>
                <h1 class="page-title">Event Management</h1>
                <p class="page-subtitle">View, edit, filter, and track all upcoming and past events.</p>
            </div>
            <a href="add-event.jsp" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Add Event</a>
        </div>

        <% if ("added".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Event created successfully!</div>
        <% } else if ("updated".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-info"><i class="fa-solid fa-circle-info"></i> Event details updated!</div>
        <% } %>

        <!-- Filter & Search Controls -->
        <div class="glass-panel" style="padding: 1rem 1.5rem; margin-bottom: 1.5rem; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
            <div style="display: flex; gap: 0.5rem;">
                <button class="btn btn-secondary btn-sm active" data-status-filter="all" data-target-table="eventsTable">All Events</button>
                <button class="btn btn-secondary btn-sm" data-status-filter="Upcoming" data-target-table="eventsTable">Upcoming</button>
                <button class="btn btn-secondary btn-sm" data-status-filter="Active" data-target-table="eventsTable">Active</button>
                <button class="btn btn-secondary btn-sm" data-status-filter="Completed" data-target-table="eventsTable">Completed</button>
                <button class="btn btn-secondary btn-sm" data-status-filter="Cancelled" data-target-table="eventsTable">Cancelled</button>
            </div>
            <div style="width: 260px;">
                <input type="text" class="form-control" placeholder="Search events..." data-table-search="eventsTable">
            </div>
        </div>

        <div class="glass-panel">
            <% if (eventList.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon"><i class="fa-solid fa-calendar-xmark"></i></div>
                    <div class="empty-title">No Events in System</div>
                    <div class="empty-desc">There are currently no events registered. Click the button below to add your first event.</div>
                    <a href="add-event.jsp" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Create Event</a>
                </div>
            <% } else { %>
                <div class="table-container">
                    <table class="data-table" id="eventsTable">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Event Name</th>
                                <th>Date</th>
                                <th>Venue</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Event e : eventList) { 
                                String st = e.getStatus() != null ? e.getStatus() : "Upcoming";
                            %>
                                <tr data-status="<%= st %>">
                                    <td>#<%= e.getEventId() %></td>
                                    <td style="font-weight: 700;">
                                        <%= e.getEventName() %>
                                        <div style="font-size: 0.8rem; color: var(--text-muted); font-weight: normal;"><%= e.getDescription() != null ? e.getDescription() : "" %></div>
                                    </td>
                                    <td><i class="fa-regular fa-calendar" style="color: var(--accent-primary);"></i> <%= e.getEventDate() %></td>
                                    <td><i class="fa-solid fa-location-dot" style="color: #ec4899;"></i> <%= e.getVenue() %></td>
                                    <td>
                                        <span class="badge badge-<%= st.toLowerCase().replace(" ", "-") %>">
                                            <span class="badge-dot" style="background: currentColor;"></span> <%= st %>
                                        </span>
                                    </td>
                                    <td>
                                        <div style="display: flex; gap: 0.4rem;">
                                            <a href="volunteer-roles.jsp?eventId=<%= e.getEventId() %>" class="btn btn-secondary btn-sm" title="Manage Roles">
                                                <i class="fa-solid fa-user-tag"></i> Roles
                                            </a>
                                            <form action="../UpdateEventServlet" method="post" style="display: inline;">
                                                <input type="hidden" name="eventId" value="<%= e.getEventId() %>">
                                                <input type="hidden" name="action" value="delete">
                                                <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Delete this event?');" title="Delete Event">
                                                    <i class="fa-solid fa-trash"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>

    <footer class="footer">
        &copy; 2026 Event Volunteer Management System.
    </footer>

    <script src="../js/main.js"></script>
</body>
</html>
