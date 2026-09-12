<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.event.dao.*, com.event.model.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (!"VOLUNTEER".equals(role)) {
        response.sendRedirect("../login.jsp");
        return;
    }

    int volunteerId = (Integer) session.getAttribute("volunteerId");
    ApplicationDao appDao = new ApplicationDao();
    List<EventApplication> myApps = appDao.getByVolunteer(volunteerId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications - Volunteer Portal</title>
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
            <li><a href="events.jsp" class="nav-link"><i class="fa-solid fa-calendar-days"></i> Available Events</a></li>
            <li><a href="my-applications.jsp" class="nav-link active"><i class="fa-solid fa-file-lines"></i> My Applications</a></li>
            <li><a href="my-duty.jsp" class="nav-link"><i class="fa-solid fa-user-gear"></i> Assigned Duty</a></li>
            <li><a href="attendance.jsp" class="nav-link"><i class="fa-solid fa-clock"></i> Attendance</a></li>
            <li><a href="history.jsp" class="nav-link"><i class="fa-solid fa-history"></i> History & Feedback</a></li>
        </ul>
        <div class="user-menu">
            <a href="../LogoutServlet" class="btn btn-secondary btn-sm"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <div>
                <h1 class="page-title">My Event Applications</h1>
                <p class="page-subtitle">Track the status of your volunteer role applications and coordinator feedback.</p>
            </div>
            <a href="events.jsp" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Apply for More Events</a>
        </div>

        <% if ("applied".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Application submitted! It is now pending coordinator review.</div>
        <% } else if ("already_applied".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-info"><i class="fa-solid fa-circle-info"></i> You have already applied for this event.</div>
        <% } %>

        <div class="glass-panel">
            <% if (myApps.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon"><i class="fa-solid fa-file-lines"></i></div>
                    <div class="empty-title">You Haven't Applied for Any Events Yet</div>
                    <div class="empty-desc">Browse our list of upcoming events and apply for volunteer roles that match your passion!</div>
                    <a href="events.jsp" class="btn btn-primary"><i class="fa-solid fa-magnifying-glass"></i> Browse Events</a>
                </div>
            <% } else { %>
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>App ID</th>
                                <th>Event Name</th>
                                <th>Role</th>
                                <th>Submitted On</th>
                                <th>Status</th>
                                <th>Coordinator Remark</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (EventApplication app : myApps) { 
                                String st = app.getStatus() != null ? app.getStatus() : "Pending";
                            %>
                                <tr>
                                    <td>#<%= app.getApplicationId() %></td>
                                    <td style="font-weight: 700; color: var(--accent-primary);"><%= app.getEventName() %></td>
                                    <td><span class="nav-badge"><%= app.getRoleName() %></span></td>
                                    <td><%= app.getAppliedDate() %></td>
                                    <td>
                                        <span class="badge badge-<%= st.toLowerCase() %>">
                                            <span class="badge-dot" style="background: currentColor;"></span> <%= st %>
                                        </span>
                                    </td>
                                    <td style="color: var(--text-secondary); max-width: 250px;"><%= app.getRemark() != null ? app.getRemark() : "-" %></td>
                                    <td>
                                        <% if ("Approved".equalsIgnoreCase(st)) { %>
                                            <a href="my-duty.jsp" class="btn btn-primary btn-sm"><i class="fa-solid fa-clipboard-check"></i> View Assigned Duty</a>
                                        <% } else { %>
                                            <span style="color: var(--text-muted); font-size: 0.85rem;">Pending Review</span>
                                        <% } %>
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

</body>
</html>
