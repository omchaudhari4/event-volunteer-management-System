<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.event.dao.*, com.event.model.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (!"VOLUNTEER".equals(role)) {
        response.sendRedirect("../login.jsp");
        return;
    }

    int volunteerId = (Integer) session.getAttribute("volunteerId");
    DutyDao dutyDao = new DutyDao();
    List<DutyAssignment> myDuties = dutyDao.getByVolunteer(volunteerId);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assigned Duty - Volunteer Portal</title>
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
            <li><a href="my-applications.jsp" class="nav-link"><i class="fa-solid fa-file-lines"></i> My Applications</a></li>
            <li><a href="my-duty.jsp" class="nav-link active"><i class="fa-solid fa-user-gear"></i> Assigned Duty</a></li>
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
                <h1 class="page-title">My Assigned Shift Duties</h1>
                <p class="page-subtitle">View duty location, shift timings, and update your task completion status.</p>
            </div>
            <a href="attendance.jsp" class="btn btn-primary"><i class="fa-solid fa-user-clock"></i> Mark Check-In / Out</a>
        </div>

        <% if ("updated".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-info"><i class="fa-solid fa-circle-info"></i> Task progress status updated!</div>
        <% } %>

        <div class="glass-panel">
            <% if (myDuties.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon"><i class="fa-solid fa-user-shield"></i></div>
                    <div class="empty-title">No Shift Duty Assigned Yet</div>
                    <div class="empty-desc">Once your event application is approved by the event coordinator, your assigned duty tasks and shift times will appear here.</div>
                    <a href="my-applications.jsp" class="btn btn-secondary"><i class="fa-solid fa-file-signature"></i> Check Application Status</a>
                </div>
            <% } else { %>
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Assignment ID</th>
                                <th>Event Name</th>
                                <th>Role</th>
                                <th>Duty Task Title</th>
                                <th>Duty Location</th>
                                <th>Shift Timing</th>
                                <th>Task Status</th>
                                <th>Update Task Progress</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (DutyAssignment d : myDuties) { 
                                String st = d.getStatus() != null ? d.getStatus() : "Assigned";
                            %>
                                <tr>
                                    <td>#<%= d.getAssignmentId() %></td>
                                    <td style="font-weight: 700; color: var(--accent-primary);"><%= d.getEventName() %></td>
                                    <td><span class="nav-badge"><%= d.getRoleName() %></span></td>
                                    <td style="font-weight: 600;"><%= d.getDutyTitle() %></td>
                                    <td><i class="fa-solid fa-location-dot" style="color: #ec4899;"></i> <%= d.getDutyLocation() %></td>
                                    <td><i class="fa-solid fa-clock" style="color: var(--accent-secondary);"></i> <%= d.getStartTime() %> - <%= d.getEndTime() %></td>
                                    <td>
                                        <span class="badge badge-<%= st.toLowerCase().replace(" ", "-") %>">
                                            <span class="badge-dot" style="background: currentColor;"></span> <%= st %>
                                        </span>
                                    </td>
                                    <td>
                                        <form action="../UpdateDutyServlet" method="post" style="display: flex; gap: 0.4rem;">
                                            <input type="hidden" name="assignmentId" value="<%= d.getAssignmentId() %>">
                                            <% if (!"Completed".equalsIgnoreCase(st)) { %>
                                                <select name="status" class="form-control" style="padding: 0.35rem 0.5rem; font-size: 0.82rem; width: auto;">
                                                    <option value="In Progress" <%= "In Progress".equalsIgnoreCase(st) ? "selected" : "" %>>In Progress</option>
                                                    <option value="Completed">Completed</option>
                                                </select>
                                                <button type="submit" class="btn btn-primary btn-sm">Update</button>
                                            <% } else { %>
                                                <span style="color: #10b981; font-weight: 700; font-size: 0.85rem;"><i class="fa-solid fa-circle-check"></i> Finished</span>
                                            <% } %>
                                        </form>
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
