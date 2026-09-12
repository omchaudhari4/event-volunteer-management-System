<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.event.dao.*, com.event.model.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (!"ADMIN".equals(role)) {
        response.sendRedirect("../login.jsp");
        return;
    }

    AttendanceDao attDao = new AttendanceDao();
    List<Attendance> attList = attDao.getAllAttendance();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attendance Monitor - Admin</title>
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
            <li><a href="attendance.jsp" class="nav-link active"><i class="fa-solid fa-clock-rotate-left"></i> Attendance</a></li>
            <li><a href="reports.jsp" class="nav-link"><i class="fa-solid fa-chart-line"></i> Reports</a></li>
        </ul>
        <div class="user-menu">
            <a href="../LogoutServlet" class="btn btn-secondary btn-sm"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <div>
                <h1 class="page-title">Volunteer Attendance Log</h1>
                <p class="page-subtitle">Real-time tracking of check-in, check-out timestamps, and attendance status.</p>
            </div>
        </div>

        <div class="glass-panel">
            <% if (attList.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon"><i class="fa-solid fa-user-clock"></i></div>
                    <div class="empty-title">No Attendance Logs Recorded Yet</div>
                    <div class="empty-desc">When volunteers perform check-in/check-out for their assigned shift duties, logs will update here automatically.</div>
                </div>
            <% } else { %>
                <div class="table-container">
                    <table class="data-table" id="attTable">
                        <thead>
                            <tr>
                                <th>Log ID</th>
                                <th>Volunteer Name</th>
                                <th>Event</th>
                                <th>Duty Task</th>
                                <th>Check-In Time</th>
                                <th>Check-Out Time</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Attendance a : attList) { 
                                String st = a.getStatus() != null ? a.getStatus() : "Present";
                            %>
                                <tr>
                                    <td>#<%= a.getAttendanceId() %></td>
                                    <td style="font-weight: 700;"><%= a.getVolunteerName() %></td>
                                    <td style="color: var(--accent-primary); font-weight: 600;"><%= a.getEventName() %></td>
                                    <td><%= a.getDutyTitle() %></td>
                                    <td><i class="fa-solid fa-arrow-right-to-bracket" style="color: #10b981;"></i> <%= a.getCheckIn() != null ? a.getCheckIn() : "Pending" %></td>
                                    <td><i class="fa-solid fa-arrow-right-from-bracket" style="color: #ef4444;"></i> <%= a.getCheckOut() != null ? a.getCheckOut() : "Active" %></td>
                                    <td>
                                        <span class="badge badge-<%= st.toLowerCase() %>">
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

    <footer class="footer">
        &copy; 2026 Event Volunteer Management System.
    </footer>

    <script src="../js/main.js"></script>
</body>
</html>
