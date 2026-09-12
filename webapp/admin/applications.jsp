<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.event.dao.*, com.event.model.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (!"ADMIN".equals(role)) {
        response.sendRedirect("../login.jsp");
        return;
    }

    ApplicationDao appDao = new ApplicationDao();
    List<EventApplication> appList = appDao.getAllApplications();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Applications - Admin</title>
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
            <li><a href="applications.jsp" class="nav-link active"><i class="fa-solid fa-file-signature"></i> Applications</a></li>
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
                <h1 class="page-title">Volunteer Registrations & Applications</h1>
                <p class="page-subtitle">Review volunteer application details, approve candidates, and provide coordinator remarks.</p>
            </div>
        </div>

        <% if ("approved".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Volunteer application approved!</div>
        <% } else if ("rejected".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-danger"><i class="fa-solid fa-circle-xmark"></i> Volunteer application rejected.</div>
        <% } %>

        <div class="glass-panel" style="padding: 1rem 1.5rem; margin-bottom: 1.5rem; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
            <div style="display: flex; gap: 0.5rem;">
                <button class="btn btn-secondary btn-sm active" data-status-filter="all" data-target-table="appsTable">All Applications</button>
                <button class="btn btn-secondary btn-sm" data-status-filter="Pending" data-target-table="appsTable">Pending</button>
                <button class="btn btn-secondary btn-sm" data-status-filter="Approved" data-target-table="appsTable">Approved</button>
                <button class="btn btn-secondary btn-sm" data-status-filter="Rejected" data-target-table="appsTable">Rejected</button>
            </div>
            <div style="width: 260px;">
                <input type="text" class="form-control" placeholder="Search applicant/role..." data-table-search="appsTable">
            </div>
        </div>

        <div class="glass-panel">
            <% if (appList.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon"><i class="fa-solid fa-inbox"></i></div>
                    <div class="empty-title">No Applications Received Yet</div>
                    <div class="empty-desc">When volunteers apply for event roles, their registration applications will appear here for review.</div>
                </div>
            <% } else { %>
                <div class="table-container">
                    <table class="data-table" id="appsTable">
                        <thead>
                            <tr>
                                <th>App ID</th>
                                <th>Volunteer Name</th>
                                <th>Email</th>
                                <th>Event</th>
                                <th>Applied Role</th>
                                <th>Status</th>
                                <th>Remark</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (EventApplication app : appList) { 
                                String st = app.getStatus() != null ? app.getStatus() : "Pending";
                            %>
                                <tr data-status="<%= st %>">
                                    <td>#<%= app.getApplicationId() %></td>
                                    <td style="font-weight: 700;"><%= app.getVolunteerName() %></td>
                                    <td style="color: var(--text-secondary);"><%= app.getVolunteerEmail() %></td>
                                    <td style="color: var(--accent-primary); font-weight: 600;"><%= app.getEventName() %></td>
                                    <td><span class="nav-badge"><%= app.getRoleName() %></span></td>
                                    <td>
                                        <span class="badge badge-<%= st.toLowerCase() %>">
                                            <span class="badge-dot" style="background: currentColor;"></span> <%= st %>
                                        </span>
                                    </td>
                                    <td style="color: var(--text-secondary); max-width: 200px;"><%= app.getRemark() != null ? app.getRemark() : "-" %></td>
                                    <td>
                                        <% if ("Pending".equalsIgnoreCase(st)) { %>
                                            <div style="display: flex; gap: 0.4rem;">
                                                <form action="../ApproveVolunteerServlet" method="post">
                                                    <input type="hidden" name="applicationId" value="<%= app.getApplicationId() %>">
                                                    <button type="submit" class="btn btn-primary btn-sm" title="Approve Volunteer"><i class="fa-solid fa-check"></i> Approve</button>
                                                </form>
                                                <form action="../RejectVolunteerServlet" method="post">
                                                    <input type="hidden" name="applicationId" value="<%= app.getApplicationId() %>">
                                                    <button type="submit" class="btn btn-danger btn-sm" title="Reject Application"><i class="fa-solid fa-xmark"></i> Reject</button>
                                                </form>
                                            </div>
                                        <% } else if ("Approved".equalsIgnoreCase(st)) { %>
                                            <a href="assign-duty.jsp?appId=<%= app.getApplicationId() %>" class="btn btn-secondary btn-sm"><i class="fa-solid fa-user-gear"></i> Assign Duty</a>
                                        <% } else { %>
                                            <span style="color: var(--text-muted); font-size: 0.85rem;">Reviewed</span>
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

    <script src="../js/main.js"></script>
</body>
</html>
