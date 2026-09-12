<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (!"ADMIN".equals(role)) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Event - Admin</title>
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
                <h1 class="page-title">Create New Event</h1>
                <p class="page-subtitle">Publish event details to allow volunteer role applications.</p>
            </div>
            <a href="events.jsp" class="btn btn-secondary"><i class="fa-solid fa-arrow-left"></i> Back to Events</a>
        </div>

        <div class="glass-panel" style="max-width: 680px; margin: 0 auto; padding: 2.5rem;">
            <form action="../AddEventServlet" method="post">
                <div class="form-group">
                    <label class="form-label">Event Name</label>
                    <input type="text" name="eventName" class="form-control" placeholder="e.g. Annual Tech Summit 2026" required>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label class="form-label">Event Date</label>
                        <input type="date" name="eventDate" class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Event Status</label>
                        <select name="status" class="form-control">
                            <option value="Upcoming">Upcoming</option>
                            <option value="Active">Active</option>
                            <option value="Completed">Completed</option>
                            <option value="Cancelled">Cancelled</option>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Venue / Location</label>
                    <input type="text" name="venue" class="form-control" placeholder="e.g. Grand Convention Center, Hall B" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Description & Details</label>
                    <textarea name="description" class="form-control" placeholder="Provide overview, key objectives, and volunteer expectations..."></textarea>
                </div>

                <div style="display: flex; justify-content: flex-end; gap: 1rem; margin-top: 2rem;">
                    <a href="events.jsp" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary"><i class="fa-solid fa-check"></i> Publish Event</button>
                </div>
            </form>
        </div>
    </div>

    <footer class="footer">
        &copy; 2026 Event Volunteer Management System.
    </footer>

</body>
</html>
