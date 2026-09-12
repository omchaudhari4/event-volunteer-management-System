<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.event.dao.*, com.event.model.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (!"ADMIN".equals(role)) {
        response.sendRedirect("../login.jsp");
        return;
    }

    RoleDao roleDao = new RoleDao();
    EventDao eventDao = new EventDao();

    List<VolunteerRole> roleList = roleDao.getAllRoles();
    List<Event> eventList = eventDao.getAllEvents();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volunteer Roles - Admin</title>
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
            <li><a href="volunteer-roles.jsp" class="nav-link active"><i class="fa-solid fa-user-tag"></i> Roles</a></li>
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
                <h1 class="page-title">Volunteer Role Management</h1>
                <p class="page-subtitle">Define specific roles and headcount requirements for each event.</p>
            </div>
            <button class="btn btn-primary" data-modal-target="addRoleModal"><i class="fa-solid fa-plus"></i> Add Volunteer Role</button>
        </div>

        <% if ("saved".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Volunteer role saved successfully!</div>
        <% } %>

        <div class="glass-panel">
            <% if (roleList.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon"><i class="fa-solid fa-id-card-clip"></i></div>
                    <div class="empty-title">No Volunteer Roles Created</div>
                    <div class="empty-desc">Create roles for your events so volunteers can submit applications.</div>
                    <button class="btn btn-primary" data-modal-target="addRoleModal"><i class="fa-solid fa-plus"></i> Add First Role</button>
                </div>
            <% } else { %>
                <div class="table-container">
                    <table class="data-table" id="rolesTable">
                        <thead>
                            <tr>
                                <th>Role ID</th>
                                <th>Event Name</th>
                                <th>Role Title</th>
                                <th>Headcount Needed</th>
                                <th>Description</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (VolunteerRole r : roleList) { %>
                                <tr>
                                    <td>#<%= r.getRoleId() %></td>
                                    <td style="font-weight: 700; color: var(--accent-primary);"><%= r.getEventName() %></td>
                                    <td style="font-weight: 600;"><%= r.getRoleName() %></td>
                                    <td><span class="nav-badge"><%= r.getRequiredCount() %> Positions</span></td>
                                    <td style="color: var(--text-secondary);"><%= r.getDescription() != null ? r.getDescription() : "-" %></td>
                                    <td>
                                        <form action="../AddVolunteerRoleServlet" method="post" style="display: inline;">
                                            <input type="hidden" name="roleId" value="<%= r.getRoleId() %>">
                                            <input type="hidden" name="action" value="delete">
                                            <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Remove this role?');">
                                                <i class="fa-solid fa-trash"></i>
                                            </button>
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

    <!-- Modal to Add Role -->
    <div class="modal-overlay" id="addRoleModal">
        <div class="glass-panel modal-content">
            <div class="modal-header">
                <h3 style="font-size: 1.25rem;"><i class="fa-solid fa-user-plus" style="color: var(--accent-primary);"></i> Add Volunteer Role</h3>
                <button class="modal-close">&times;</button>
            </div>
            <form action="../AddVolunteerRoleServlet" method="post">
                <div class="form-group">
                    <label class="form-label">Select Event</label>
                    <select name="eventId" class="form-control" required>
                        <% if (eventList.isEmpty()) { %>
                            <option value="">No events available. Please create an event first.</option>
                        <% } else { %>
                            <% for (Event e : eventList) { %>
                                <option value="<%= e.getEventId() %>"><%= e.getEventName() %> (<%= e.getEventDate() %>)</option>
                            <% } %>
                        <% } %>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Role Name / Title</label>
                    <input type="text" name="roleName" class="form-control" placeholder="e.g. Registration Desk Lead" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Required Headcount</label>
                    <input type="number" name="requiredCount" class="form-control" value="5" min="1" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Role Description & Responsibilities</label>
                    <textarea name="description" class="form-control" placeholder="Describe role responsibilities..."></textarea>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 1rem; margin-top: 1.5rem;">
                    <button type="button" class="btn btn-secondary modal-close">Cancel</button>
                    <button type="submit" class="btn btn-primary" <%= eventList.isEmpty() ? "disabled" : "" %>><i class="fa-solid fa-check"></i> Save Role</button>
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
