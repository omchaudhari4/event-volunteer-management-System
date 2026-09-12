<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.event.dao.*, com.event.model.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (!"VOLUNTEER".equals(role)) {
        response.sendRedirect("../login.jsp");
        return;
    }

    int eventId = 0;
    try {
        eventId = Integer.parseInt(request.getParameter("eventId"));
    } catch (Exception ignored) {}

    EventDao eventDao = new EventDao();
    RoleDao roleDao = new RoleDao();

    Event selectedEvent = eventDao.getById(eventId);
    List<VolunteerRole> availableRoles = roleDao.getRolesByEvent(eventId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apply for Event - Volunteer</title>
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

    <nav class="navbar">
        <a href="events.jsp" class="brand">
            <div class="brand-icon"><i class="fa-solid fa-hands-holding-child"></i></div>
            <span class="brand-title">EventVolunteer</span>
        </a>
        <ul class="nav-links">
            <li><a href="events.jsp" class="nav-link active"><i class="fa-solid fa-calendar-days"></i> Available Events</a></li>
            <li><a href="my-applications.jsp" class="nav-link"><i class="fa-solid fa-file-lines"></i> My Applications</a></li>
            <li><a href="my-duty.jsp" class="nav-link"><i class="fa-solid fa-user-gear"></i> Assigned Duty</a></li>
        </ul>
        <div class="user-menu">
            <a href="../LogoutServlet" class="btn btn-secondary btn-sm"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <div>
                <h1 class="page-title">Submit Application</h1>
                <p class="page-subtitle">Select your preferred volunteer role and confirm your application.</p>
            </div>
            <a href="events.jsp" class="btn btn-secondary"><i class="fa-solid fa-arrow-left"></i> Back to Events</a>
        </div>

        <div class="glass-panel" style="max-width: 620px; margin: 0 auto; padding: 2.5rem;">
            <% if (selectedEvent == null) { %>
                <div class="empty-state">
                    <div class="empty-title">Event Not Found</div>
                    <a href="events.jsp" class="btn btn-primary">Return to Events</a>
                </div>
            <% } else { %>
                <div style="background: rgba(99, 102, 241, 0.1); border: 1px solid rgba(99, 102, 241, 0.3); border-radius: var(--radius-sm); padding: 1.25rem; margin-bottom: 1.75rem;">
                    <h3 style="color: var(--text-primary); font-size: 1.2rem; margin-bottom: 0.35rem;"><%= selectedEvent.getEventName() %></h3>
                    <div style="font-size: 0.88rem; color: var(--text-secondary); display: flex; gap: 1.25rem;">
                        <span><i class="fa-regular fa-calendar"></i> <%= selectedEvent.getEventDate() %></span>
                        <span><i class="fa-solid fa-location-dot"></i> <%= selectedEvent.getVenue() %></span>
                    </div>
                </div>

                <form action="../ApplyEventServlet" method="post">
                    <input type="hidden" name="eventId" value="<%= selectedEvent.getEventId() %>">

                    <div class="form-group">
                        <label class="form-label">Choose Volunteer Role</label>
                        <select name="roleId" class="form-control" required>
                            <% if (availableRoles.isEmpty()) { %>
                                <option value="">No roles defined for this event yet.</option>
                            <% } else { %>
                                <% for (VolunteerRole r : availableRoles) { %>
                                    <option value="<%= r.getRoleId() %>">
                                        <%= r.getRoleName() %> &mdash; Required: <%= r.getRequiredCount() %> positions
                                    </option>
                                <% } %>
                            <% } %>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Relevant Experience & Notes (Optional)</label>
                        <textarea name="remark" class="form-control" placeholder="Share why you are excited for this role or any past relevant experience..."></textarea>
                    </div>

                    <div style="display: flex; justify-content: flex-end; gap: 1rem; margin-top: 2rem;">
                        <a href="events.jsp" class="btn btn-secondary">Cancel</a>
                        <button type="submit" class="btn btn-primary" <%= availableRoles.isEmpty() ? "disabled" : "" %>><i class="fa-solid fa-paper-plane"></i> Confirm & Submit Application</button>
                    </div>
                </form>
            <% } %>
        </div>
    </div>

    <footer class="footer">
        &copy; 2026 Event Volunteer Management System.
    </footer>

</body>
</html>
