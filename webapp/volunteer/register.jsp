<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Volunteer Registration - Event Volunteer System</title>
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .reg-card {
            max-width: 520px;
            width: 100%;
            margin: 3rem auto;
            padding: 2.5rem;
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <a href="../index.jsp" class="brand">
            <div class="brand-icon"><i class="fa-solid fa-hands-holding-child"></i></div>
            <span class="brand-title">EventVolunteer</span>
        </a>
        <div class="user-menu">
            <a href="../login.jsp" class="btn btn-secondary"><i class="fa-solid fa-right-to-bracket"></i> Sign In</a>
        </div>
    </nav>

    <div class="container">
        <div class="glass-panel reg-card">
            <h2 style="text-align: center; font-size: 1.75rem; margin-bottom: 0.5rem;">Join as a Volunteer</h2>
            <p style="text-align: center; color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 1.5rem;">Create your profile to apply for exciting event roles</p>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <form action="../VolunteerRegisterServlet" method="post">
                <div class="form-group">
                    <label class="form-label">Full Name</label>
                    <input type="text" name="name" class="form-control" placeholder="e.g. Sarah Jenkins" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Email Address</label>
                    <input type="email" name="email" class="form-control" placeholder="sarah@example.com" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" placeholder="Create a strong password" required>
                </div>

                <div class="form-group">
                    <label class="form-label">Contact Number</label>
                    <input type="tel" name="contact" class="form-control" placeholder="+1 (555) 019-2834">
                </div>

                <div class="form-group">
                    <label class="form-label">Profile Avatar Image Path/URL</label>
                    <input type="text" name="avatarUrl" id="avatarInput" class="form-control" value="images/avatar_default.png" placeholder="images/avatar_default.png">
                </div>

                <div class="form-group">
                    <label class="form-label">Skills & Expertise</label>
                    <textarea name="skills" class="form-control" placeholder="e.g. Event Coordination, Stage Support, First Aid, Media & Photography, Technical Logistics"></textarea>
                </div>

                <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center; margin-top: 1rem; padding: 0.8rem;">
                    <i class="fa-solid fa-user-plus"></i> Register Profile
                </button>
            </form>

            <div style="text-align: center; margin-top: 1.5rem; font-size: 0.88rem; color: var(--text-secondary);">
                Already have an account? <a href="../login.jsp" style="color: var(--accent-primary); font-weight: 600; text-decoration: none;">Sign in here</a>
            </div>
        </div>
    </div>

    <footer class="footer">
        &copy; 2026 Event Volunteer Management System.
    </footer>

</body>
</html>
