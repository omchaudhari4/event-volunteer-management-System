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
    FeedbackDao feedbackDao = new FeedbackDao();

    List<DutyAssignment> myDuties = dutyDao.getByVolunteer(volunteerId);
    List<VolunteerFeedback> myFeedback = feedbackDao.getByVolunteer(volunteerId);

    // Map assignment ID to feedback existence
    Set<Integer> feedbackGivenSet = new HashSet<Integer>();
    for (VolunteerFeedback fb : myFeedback) {
        feedbackGivenSet.add(fb.getAssignmentId());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Participation History & Feedback - Volunteer Portal</title>
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
            <li><a href="attendance.jsp" class="nav-link"><i class="fa-solid fa-clock"></i> Attendance</a></li>
            <li><a href="history.jsp" class="nav-link active"><i class="fa-solid fa-history"></i> History & Feedback</a></li>
        </ul>
        <div class="user-menu">
            <a href="../LogoutServlet" class="btn btn-secondary btn-sm"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </nav>

    <div class="container">
        <div class="page-header">
            <div>
                <h1 class="page-title">Participation History & Feedback</h1>
                <p class="page-subtitle">Review completed event contributions and submit event experience ratings.</p>
            </div>
        </div>

        <% if ("feedback_submitted".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Thank you! Your feedback has been submitted to event coordinators.</div>
        <% } %>

        <div class="glass-panel" style="margin-bottom: 2rem;">
            <div style="padding: 1.5rem 1.5rem 0.5rem 1.5rem;">
                <h3 style="font-size: 1.25rem;"><i class="fa-solid fa-award" style="color: var(--accent-secondary);"></i> Shift History</h3>
            </div>

            <% if (myDuties.isEmpty()) { %>
                <div class="empty-state">
                    <div class="empty-icon"><i class="fa-solid fa-box-open"></i></div>
                    <div class="empty-title">No Participation History Recorded</div>
                    <div class="empty-desc">Your completed event assignments will be archived here for your volunteer portfolio.</div>
                </div>
            <% } else { %>
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Assignment ID</th>
                                <th>Event Name</th>
                                <th>Role</th>
                                <th>Duty Task</th>
                                <th>Status</th>
                                <th>Submit Feedback</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (DutyAssignment d : myDuties) { 
                                boolean feedbackSubmitted = feedbackGivenSet.contains(d.getAssignmentId());
                                String st = d.getStatus() != null ? d.getStatus() : "Assigned";
                            %>
                                <tr>
                                    <td>#<%= d.getAssignmentId() %></td>
                                    <td style="font-weight: 700; color: var(--accent-primary);"><%= d.getEventName() %></td>
                                    <td><span class="nav-badge"><%= d.getRoleName() %></span></td>
                                    <td><%= d.getDutyTitle() %></td>
                                    <td>
                                        <span class="badge badge-<%= st.toLowerCase().replace(" ", "-") %>"><%= st %></span>
                                    </td>
                                    <td>
                                        <% if (feedbackSubmitted) { %>
                                            <span style="color: #10b981; font-weight: 600; font-size: 0.85rem;"><i class="fa-solid fa-star"></i> Feedback Shared</span>
                                        <% } else { %>
                                            <button class="btn btn-secondary btn-sm" data-modal-target="feedbackModal_<%= d.getAssignmentId() %>">
                                                <i class="fa-regular fa-star"></i> Rate & Review
                                            </button>

                                            <!-- Feedback Modal for each duty -->
                                            <div class="modal-overlay" id="feedbackModal_<%= d.getAssignmentId() %>">
                                                <div class="glass-panel modal-content">
                                                    <div class="modal-header">
                                                        <h3 style="font-size: 1.2rem;"><i class="fa-solid fa-star" style="color: #f59e0b;"></i> Submit Duty Feedback</h3>
                                                        <button class="modal-close">&times;</button>
                                                    </div>
                                                    <form action="../AddFeedbackServlet" method="post">
                                                        <input type="hidden" name="assignmentId" value="<%= d.getAssignmentId() %>">

                                                        <div class="form-group">
                                                            <label class="form-label">Event & Task</label>
                                                            <div style="font-weight: 600; color: var(--text-primary);"><%= d.getEventName() %> &mdash; <%= d.getDutyTitle() %></div>
                                                        </div>

                                                        <div class="form-group">
                                                            <label class="form-label">Overall Rating (1 to 5 Stars)</label>
                                                            <select name="rating" class="form-control" required>
                                                                <option value="5">★★★★★ - Excellent Experience (5 Stars)</option>
                                                                <option value="4">★★★★☆ - Great Experience (4 Stars)</option>
                                                                <option value="3">★★★☆☆ - Average / Satisfactory (3 Stars)</option>
                                                                <option value="2">★★☆☆☆ - Needs Improvement (2 Stars)</option>
                                                                <option value="1">★☆☆☆☆ - Poor Experience (1 Star)</option>
                                                            </select>
                                                        </div>

                                                        <div class="form-group">
                                                            <label class="form-label">Feedback & Suggestions</label>
                                                            <textarea name="feedback" class="form-control" placeholder="Share your experience, coordinator support feedback, or suggestions..." required></textarea>
                                                        </div>

                                                        <div style="display: flex; justify-content: flex-end; gap: 1rem; margin-top: 1.5rem;">
                                                            <button type="button" class="btn btn-secondary modal-close">Cancel</button>
                                                            <button type="submit" class="btn btn-primary"><i class="fa-solid fa-paper-plane"></i> Submit Feedback</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
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
