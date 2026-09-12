<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.event.dao.*, com.event.model.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (!"ADMIN".equals(role)) {
        response.sendRedirect("../login.jsp");
        return;
    }

    EventDao eventDao = new EventDao();
    VolunteerDao volunteerDao = new VolunteerDao();
    ApplicationDao appDao = new ApplicationDao();
    DutyDao dutyDao = new DutyDao();

    int totalEvents = eventDao.getCount();
    int totalVolunteers = volunteerDao.getCount();
    int pendingApps = appDao.getCountByStatus("Pending");
    int approvedApps = appDao.getCountByStatus("Approved");

    List<Event> recentEvents = eventDao.getAllEvents();
    List<EventApplication> recentApps = appDao.getAllApplications();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Event Volunteer Management</title>
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
            <li><a href="dashboard.jsp" class="nav-link active"><i class="fa-solid fa-chart-pie"></i> Dashboard</a></li>
            <li><a href="events.jsp" class="nav-link"><i class="fa-solid fa-calendar-days"></i> Events</a></li>
            <li><a href="volunteer-roles.jsp" class="nav-link"><i class="fa-solid fa-user-tag"></i> Roles</a></li>
            <li><a href="applications.jsp" class="nav-link"><i class="fa-solid fa-file-signature"></i> Applications</a></li>
            <li><a href="assign-duty.jsp" class="nav-link"><i class="fa-solid fa-clipboard-list"></i> Duties</a></li>
            <li><a href="attendance.jsp" class="nav-link"><i class="fa-solid fa-clock-rotate-left"></i> Attendance</a></li>
            <li><a href="reports.jsp" class="nav-link"><i class="fa-solid fa-chart-line"></i> Reports</a></li>
        </ul>
        <div class="user-menu">
            <div class="user-avatar">A</div>
            <a href="../LogoutServlet" class="btn btn-secondary btn-sm"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <div>
                <h1 class="page-title">Coordinator Dashboard</h1>
                <p class="page-subtitle">Overview of event registrations, volunteer applications, and duty assignments.</p>
            </div>
            <a href="add-event.jsp" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Create New Event</a>
        </div>

        <!-- Metric Stat Cards -->
        <div class="stats-grid">
            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-val"><%= totalEvents %></div>
                    <div class="stat-label">Total Events</div>
                </div>
                <div class="stat-icon"><i class="fa-solid fa-calendar-star"></i></div>
            </div>
            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-val"><%= totalVolunteers %></div>
                    <div class="stat-label">Registered Volunteers</div>
                </div>
                <div class="stat-icon" style="color: var(--accent-secondary); background: rgba(168, 85, 247, 0.1); border-color: rgba(168, 85, 247, 0.2);"><i class="fa-solid fa-users"></i></div>
            </div>
            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-val"><%= pendingApps %></div>
                    <div class="stat-label">Pending Applications</div>
                </div>
                <div class="stat-icon" style="color: #f59e0b; background: rgba(245, 158, 11, 0.1); border-color: rgba(245, 158, 11, 0.2);"><i class="fa-solid fa-hourglass-half"></i></div>
            </div>
            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-val"><%= approvedApps %></div>
                    <div class="stat-label">Approved Volunteers</div>
                </div>
                <div class="stat-icon" style="color: #10b981; background: rgba(16, 185, 129, 0.1); border-color: rgba(16, 185, 129, 0.2);"><i class="fa-solid fa-circle-check"></i></div>
            </div>
        </div>

        <!-- Quick Access & Overview -->
        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 1.5rem; margin-bottom: 2rem;">
            <!-- Recent Events -->
            <div class="glass-panel" style="padding: 1.5rem;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem;">
                    <h3 style="font-size: 1.15rem;"><i class="fa-solid fa-calendar-days" style="color: var(--accent-primary);"></i> Active & Upcoming Events</h3>
                    <a href="events.jsp" style="color: var(--accent-primary); font-size: 0.88rem; font-weight: 600; text-decoration: none;">View All &rarr;</a>
                </div>

                <% if (recentEvents.isEmpty()) { %>
                    <div class="empty-state">
                        <div class="empty-icon"><i class="fa-regular fa-folder-open"></i></div>
                        <div class="empty-title">No Events Created Yet</div>
                        <div class="empty-desc">Get started by creating your first event and configuring volunteer roles.</div>
                        <a href="add-event.jsp" class="btn btn-primary btn-sm"><i class="fa-solid fa-plus"></i> Add Event Now</a>
                    </div>
                <% } else { %>
                    <div class="table-container">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Event Name</th>
                                    <th>Date</th>
                                    <th>Venue</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (int i = 0; i < Math.min(5, recentEvents.size()); i++) { 
                                    Event e = recentEvents.get(i);
                                    String st = e.getStatus() != null ? e.getStatus() : "Upcoming";
                                %>
                                    <tr>
                                        <td style="font-weight: 600;"><%= e.getEventName() %></td>
                                        <td><%= e.getEventDate() %></td>
                                        <td><%= e.getVenue() %></td>
                                        <td><span class="badge badge-<%= st.toLowerCase().replace(" ", "-") %>"><%= st %></span></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>

            <!-- Action Center -->
            <div class="glass-panel" style="padding: 1.5rem;">
                <h3 style="font-size: 1.15rem; margin-bottom: 1.25rem;"><i class="fa-solid fa-bolt" style="color: #f59e0b;"></i> Action Shortcuts</h3>
                <div style="display: flex; flex-direction: column; gap: 0.85rem;">
                    <a href="add-event.jsp" class="btn btn-secondary" style="justify-content: flex-start;">
                        <i class="fa-solid fa-calendar-plus" style="color: var(--accent-primary);"></i> Create New Event
                    </a>
                    <a href="volunteer-roles.jsp" class="btn btn-secondary" style="justify-content: flex-start;">
                        <i class="fa-solid fa-user-tag" style="color: var(--accent-secondary);"></i> Define Volunteer Roles
                    </a>
                    <a href="applications.jsp" class="btn btn-secondary" style="justify-content: flex-start;">
                        <i class="fa-solid fa-user-check" style="color: #10b981;"></i> Review Applications
                    </a>
                    <a href="assign-duty.jsp" class="btn btn-secondary" style="justify-content: flex-start;">
                        <i class="fa-solid fa-clock" style="color: #3b82f6;"></i> Assign Shift Duties
                    </a>
                    <a href="reports.jsp" class="btn btn-secondary" style="justify-content: flex-start;">
                        <i class="fa-solid fa-chart-column" style="color: #ec4899;"></i> View Analytics Report
                    </a>
                </div>
            </div>
        </div>

    </div>

    <footer class="footer">
        &copy; 2026 Event Volunteer Management System. Admin Dashboard.
    </footer>

</body>
</html>
