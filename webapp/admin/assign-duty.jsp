<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.event.dao.*, com.event.model.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (!"ADMIN".equals(role)) {
        response.sendRedirect("../login.jsp");
        return;
    }

    DutyDao dutyDao = new DutyDao();
    ApplicationDao appDao = new ApplicationDao();

    List<DutyAssignment> dutyList = dutyDao.getAllDuties();
    List<EventApplication> allApps = appDao.getAllApplications();

    // Filter approved applications without duty assigned yet
    List<EventApplication> approvedApps = new ArrayList<EventApplication>();
    for (EventApplication app : allApps) {
        if ("Approved".equalsIgnoreCase(app.getStatus())) {
            approvedApps.add(app);
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assign Duty - Admin</title>
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
            <li><a href="assign-duty.jsp" class="nav-link active"><i class="fa-solid fa-clipboard-list"></i> Duties</a></li>
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
                <h1 class="page-title">Duty & Shift Assignment</h1>
                <p class="page-subtitle">Schedule shift timings, locations, and specific duty tasks for approved volunteers.</p>
            </div>
            <button class="btn btn-primary" data-modal-target="assignDutyModal"><i class="fa-solid fa-user-gear"></i> Assign New Duty</button>
        </div>

        <% if ("assigned".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Duty assigned successfully!</div>
        <% } else if ("updated".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-info"><i class="fa-solid fa-circle-info"></i> Duty status updated!</div>
        <% } %>

        <div class="glass-panel">
            <% if (dutyList.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon"><i class="fa-solid fa-clipboard-check"></i></div>
                    <div class="empty-title">No Duties Assigned Yet</div>
                    <div class="empty-desc">Once volunteer applications are approved, assign specific duties and timings here.</div>
                    <button class="btn btn-primary" data-modal-target="assignDutyModal"><i class="fa-solid fa-plus"></i> Assign Duty Now</button>
                </div>
            <% } else { %>
                <div class="table-container">
                    <table class="data-table" id="dutiesTable">
                        <thead>
                            <tr>
                                <th>Assignment ID</th>
                                <th>Volunteer Name</th>
                                <th>Event</th>
                                <th>Role</th>
                                <th>Duty Title</th>
                                <th>Location</th>
                                <th>Timing (Start - End)</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (DutyAssignment d : dutyList) { 
                                String st = d.getStatus() != null ? d.getStatus() : "Assigned";
                            %>
                                <tr>
                                    <td>#<%= d.getAssignmentId() %></td>
                                    <td style="font-weight: 700;"><%= d.getVolunteerName() %></td>
                                    <td style="color: var(--accent-primary); font-weight: 600;"><%= d.getEventName() %></td>
                                    <td><span class="nav-badge"><%= d.getRoleName() %></span></td>
                                    <td style="font-weight: 600;"><%= d.getDutyTitle() %></td>
                                    <td><i class="fa-solid fa-location-dot" style="color: #ec4899;"></i> <%= d.getDutyLocation() %></td>
                                    <td><i class="fa-solid fa-clock" style="color: var(--accent-secondary);"></i> <%= d.getStartTime() %> - <%= d.getEndTime() %></td>
                                    <td>
                                        <span class="badge badge-<%= st.toLowerCase().replace(" ", "-") %>">
                                            <span class="badge-dot" style="background: currentColor;"></span> <%= st %>
                                        </span>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>

    <!-- Modal to Assign Duty -->
    <div class="modal-overlay" id="assignDutyModal">
        <div class="glass-panel modal-content">
            <div class="modal-header">
                <h3 style="font-size: 1.25rem;"><i class="fa-solid fa-user-gear" style="color: var(--accent-primary);"></i> Assign Volunteer Duty</h3>
                <button class="modal-close">&times;</button>
            </div>
            <form action="../AssignDutyServlet" method="post">
                <div class="form-group">
                    <label class="form-label">Approved Volunteer & Event Application</label>
                    <select name="applicationId" class="form-control" required>
                        <% if (approvedApps.isEmpty()) { %>
                            <option value="">No approved applications available. Please approve applications first.</option>
                        <% } else { %>
                            <% for (EventApplication app : approvedApps) { %>
                                <option value="<%= app.getApplicationId() %>">
                                    <%= app.getVolunteerName() %> &mdash; <%= app.getEventName() %> (<%= app.getRoleName() %>)
                                </option>
                            <% } %>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Duty Title / Task Name</label>
                    <input type="text" name="dutyTitle" class="form-control" placeholder="e.g. VIP Guest Guidance & Ticket Scan" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Duty Location / Station</label>
                    <input type="text" name="dutyLocation" class="form-control" placeholder="e.g. Gate 2 - Main Entry Lounge" required>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label class="form-label">Start Time</label>
                        <input type="time" name="startTime" class="form-control" value="09:00" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">End Time</label>
                        <input type="time" name="endTime" class="form-control" value="17:00" required>
                    </div>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 1rem; margin-top: 1.5rem;">
                    <button type="button" class="btn btn-secondary modal-close">Cancel</button>
                    <button type="submit" class="btn btn-primary" <%= approvedApps.isEmpty() ? "disabled" : "" %>><i class="fa-solid fa-check"></i> Assign Duty</button>
                </div>
            </form>
        </div>
    </div>

    <footer class="footer">
        &copy; 2026 Event Volunteer Management System.
    </footer>

    <script src="../js/main.js"></script>
</body>
</html>
