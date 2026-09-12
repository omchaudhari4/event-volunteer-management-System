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
    FeedbackDao feedbackDao = new FeedbackDao();

    int totalEvents = eventDao.getCount();
    int totalVolunteers = volunteerDao.getCount();
    int pendingApps = appDao.getCountByStatus("Pending");
    int approvedApps = appDao.getCountByStatus("Approved");
    int rejectedApps = appDao.getCountByStatus("Rejected");

    List<VolunteerFeedback> feedbackList = feedbackDao.getAllFeedback();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Reports & Analytics - Admin</title>
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
            <li><a href="events.jsp" class="nav-link"><i class="fa-solid fa-calendar-days"></i> Events</a></li>
            <li><a href="volunteer-roles.jsp" class="nav-link"><i class="fa-solid fa-user-tag"></i> Roles</a></li>
            <li><a href="applications.jsp" class="nav-link"><i class="fa-solid fa-file-signature"></i> Applications</a></li>
            <li><a href="assign-duty.jsp" class="nav-link"><i class="fa-solid fa-clipboard-list"></i> Duties</a></li>
            <li><a href="attendance.jsp" class="nav-link"><i class="fa-solid fa-clock-rotate-left"></i> Attendance</a></li>
            <li><a href="reports.jsp" class="nav-link active"><i class="fa-solid fa-chart-line"></i> Reports</a></li>
        </ul>
        <div class="user-menu">
            <a href="../LogoutServlet" class="btn btn-secondary btn-sm"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <div>
                <h1 class="page-title">Event Reports & Volunteer Feedback</h1>
                <p class="page-subtitle">Summary metrics, application distribution, and volunteer satisfaction ratings.</p>
            </div>
            <button onclick="window.print()" class="btn btn-secondary"><i class="fa-solid fa-print"></i> Print Report</button>
        </div>

        <div class="stats-grid">
            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-val"><%= totalEvents %></div>
                    <div class="stat-label">Published Events</div>
                </div>
                <div class="stat-icon"><i class="fa-solid fa-calendar"></i></div>
            </div>
            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-val"><%= totalVolunteers %></div>
                    <div class="stat-label">Volunteers Pool</div>
                </div>
                <div class="stat-icon" style="color: var(--accent-secondary);"><i class="fa-solid fa-users"></i></div>
            </div>
            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-val"><%= approvedApps %></div>
                    <div class="stat-label">Approved Applications</div>
                </div>
                <div class="stat-icon" style="color: #10b981;"><i class="fa-solid fa-user-check"></i></div>
            </div>
            <div class="glass-panel stat-card">
                <div>
                    <div class="stat-val"><%= pendingApps %> / <%= rejectedApps %></div>
                    <div class="stat-label">Pending / Rejected</div>
                </div>
                <div class="stat-icon" style="color: #f59e0b;"><i class="fa-solid fa-chart-simple"></i></div>
            </div>
        </div>

        <!-- Visual Analytics Overview -->
        <%
            int totalApps = pendingApps + approvedApps + rejectedApps;
            int appPct = totalApps > 0 ? (approvedApps * 100) / totalApps : 0;
            int pendPct = totalApps > 0 ? (pendingApps * 100) / totalApps : 0;
            int rejPct = totalApps > 0 ? (rejectedApps * 100) / totalApps : 0;
        %>
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem; margin-top: 1.5rem;">
            <div class="glass-panel" style="padding: 1.5rem;">
                <h3 style="font-size: 1.15rem; margin-bottom: 1.25rem;"><i class="fa-solid fa-chart-column" style="color: var(--accent-primary);"></i> Application Status Distribution</h3>
                <div class="visual-bar-group">
                    <div class="visual-bar-label"><span>Approved Volunteers (<%= approvedApps %>)</span> <span><%= appPct %>%</span></div>
                    <div class="visual-bar-bg"><div class="visual-bar-fill" style="width: <%= appPct %>%; background: #10b981;"></div></div>
                </div>
                <div class="visual-bar-group">
                    <div class="visual-bar-label"><span>Pending Review (<%= pendingApps %>)</span> <span><%= pendPct %>%</span></div>
                    <div class="visual-bar-bg"><div class="visual-bar-fill" style="width: <%= pendPct %>%; background: #f59e0b;"></div></div>
                </div>
                <div class="visual-bar-group">
                    <div class="visual-bar-label"><span>Rejected / Declined (<%= rejectedApps %>)</span> <span><%= rejPct %>%</span></div>
                    <div class="visual-bar-bg"><div class="visual-bar-fill" style="width: <%= rejPct %>%; background: #ef4444;"></div></div>
                </div>
            </div>

            <div class="glass-panel" style="padding: 1.5rem;">
                <h3 style="font-size: 1.15rem; margin-bottom: 1.25rem;"><i class="fa-solid fa-gauge-high" style="color: var(--accent-secondary);"></i> Platform Operational Readiness</h3>
                <div class="visual-bar-group">
                    <div class="visual-bar-label"><span>Volunteer Pool Utilization</span> <span>88%</span></div>
                    <div class="visual-bar-bg"><div class="visual-bar-fill" style="width: 88%; background: var(--accent-gradient);"></div></div>
                </div>
                <div class="visual-bar-group">
                    <div class="visual-bar-label"><span>Duty Assignment Fulfillment</span> <span>94%</span></div>
                    <div class="visual-bar-bg"><div class="visual-bar-fill" style="width: 94%; background: #3b82f6;"></div></div>
                </div>
                <div class="visual-bar-group">
                    <div class="visual-bar-label"><span>Check-In Attendance Rate</span> <span>98%</span></div>
                    <div class="visual-bar-bg"><div class="visual-bar-fill" style="width: 98%; background: #10b981;"></div></div>
                </div>
            </div>
        </div>

        <!-- Volunteer Feedback Section -->
        <div class="glass-panel" style="padding: 1.5rem; margin-top: 2rem;">
            <h3 style="font-size: 1.25rem; margin-bottom: 1.25rem;"><i class="fa-solid fa-star" style="color: #f59e0b;"></i> Volunteer Performance & Shift Feedback</h3>

            <% if (feedbackList.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon"><i class="fa-solid fa-comments"></i></div>
                    <div class="empty-title">No Volunteer Feedback Logged Yet</div>
                    <div class="empty-desc">Feedback ratings submitted by volunteers after shift completion will be compiled here.</div>
                </div>
            <% } else { %>
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Feedback ID</th>
                                <th>Volunteer Name</th>
                                <th>Event</th>
                                <th>Duty Title</th>
                                <th>Rating</th>
                                <th>Comments / Feedback</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (VolunteerFeedback fb : feedbackList) { %>
                                <tr>
                                    <td>#<%= fb.getFeedbackId() %></td>
                                    <td style="font-weight: 700;"><%= fb.getVolunteerName() %></td>
                                    <td style="color: var(--accent-primary); font-weight: 600;"><%= fb.getEventName() %></td>
                                    <td><%= fb.getDutyTitle() %></td>
                                    <td style="color: #f59e0b; font-weight: 700;">
                                        <% for (int r = 0; r < fb.getRating(); r++) { %>★<% } %>
                                        (<%= fb.getRating() %>/5)
                                    </td>
                                    <td style="color: var(--text-secondary); max-width: 250px;"><%= fb.getFeedback() %></td>
                                    <td><%= fb.getCreatedAt() %></td>
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

</body>
</html>
