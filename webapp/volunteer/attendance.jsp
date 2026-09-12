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
    AttendanceDao attDao = new AttendanceDao();

    List<DutyAssignment> myDuties = dutyDao.getByVolunteer(volunteerId);
    List<Attendance> myAtt = attDao.getByVolunteer(volunteerId);

    // Map assignment ID to attendance object
    Map<Integer, Attendance> attMap = new HashMap<Integer, Attendance>();
    for (Attendance a : myAtt) {
        attMap.put(a.getAssignmentId(), a);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Attendance - Volunteer Portal</title>
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
            <li><a href="my-duty.jsp" class="nav-link"><i class="fa-solid fa-user-gear"></i> Assigned Duty</a></li>
            <li><a href="attendance.jsp" class="nav-link active"><i class="fa-solid fa-clock"></i> Attendance</a></li>
            <li><a href="history.jsp" class="nav-link"><i class="fa-solid fa-history"></i> History & Feedback</a></li>
        </ul>
        <div class="user-menu">
            <a href="../LogoutServlet" class="btn btn-secondary btn-sm"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <div>
                <h1 class="page-title">Duty Attendance Check-In & Check-Out</h1>
                <p class="page-subtitle">Record your shift arrival and departure timestamps for assigned event duties.</p>
            </div>
        </div>

        <% if ("checked_in".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Check-In recorded successfully! Welcome to your shift.</div>
        <% } else if ("checked_out".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-info"><i class="fa-solid fa-circle-info"></i> Check-Out recorded! Thank you for your volunteer service.</div>
        <% } %>

        <div class="glass-panel">
            <% if (myDuties.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon"><i class="fa-solid fa-clock-rotate-left"></i></div>
                    <div class="empty-title">No Active Duty Shifts Available</div>
                    <div class="empty-desc">Once you are assigned to a duty shift, attendance check-in controls will unlock here.</div>
                </div>
            <% } else { %>
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Assignment ID</th>
                                <th>Event Name</th>
                                <th>Duty Task</th>
                                <th>Shift Hours</th>
                                <th>Check-In Time</th>
                                <th>Check-Out Time</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (DutyAssignment d : myDuties) { 
                                Attendance att = attMap.get(d.getAssignmentId());
                                boolean isCheckedIn = (att != null && att.getCheckIn() != null);
                                boolean isCheckedOut = (att != null && att.getCheckOut() != null);
                            %>
                                <tr>
                                    <td>#<%= d.getAssignmentId() %></td>
                                    <td style="font-weight: 700; color: var(--accent-primary);"><%= d.getEventName() %></td>
                                    <td style="font-weight: 600;"><%= d.getDutyTitle() %></td>
                                    <td><%= d.getStartTime() %> - <%= d.getEndTime() %></td>
                                    <td>
                                        <i class="fa-solid fa-arrow-right-to-bracket" style="color: #10b981;"></i>
                                        <%= (att != null && att.getCheckIn() != null) ? att.getCheckIn() : "Not Checked In" %>
                                    </td>
                                    <td>
                                        <i class="fa-solid fa-arrow-right-from-bracket" style="color: #ef4444;"></i>
                                        <%= (att != null && att.getCheckOut() != null) ? att.getCheckOut() : "Not Checked Out" %>
                                    </td>
                                    <td>
                                        <% if (isCheckedOut) { %>
                                            <span class="badge badge-completed">Shift Completed</span>
                                        <% } else if (isCheckedIn) { %>
                                            <span class="badge badge-active">On Duty (Present)</span>
                                        <% } else { %>
                                            <span class="badge badge-pending">Pending Check-In</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if (!isCheckedIn) { %>
                                            <form action="../CheckInServlet" method="post">
                                                <input type="hidden" name="assignmentId" value="<%= d.getAssignmentId() %>">
                                                <button type="submit" class="btn btn-primary btn-sm"><i class="fa-solid fa-arrow-right-to-bracket"></i> Check-In</button>
                                            </form>
                                        <% } else if (!isCheckedOut) { %>
                                            <form action="../CheckOutServlet" method="post">
                                                <input type="hidden" name="assignmentId" value="<%= d.getAssignmentId() %>">
                                                <button type="submit" class="btn btn-danger btn-sm"><i class="fa-solid fa-arrow-right-from-bracket"></i> Check-Out</button>
                                            </form>
                                        <% } else { %>
                                            <span style="color: #10b981; font-weight: 700; font-size: 0.85rem;"><i class="fa-solid fa-circle-check"></i> Shift Closed</span>
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
