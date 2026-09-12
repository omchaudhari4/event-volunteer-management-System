<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Event Volunteer Management System</title>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .login-wrapper {
            max-width: 480px;
            width: 100%;
            margin: 3rem auto;
            border-radius: var(--radius-lg);
            overflow: hidden;
        }
        .login-card {
            padding: 3rem 2.5rem;
        }
        .role-tabs {
            display: flex;
            background: rgba(15, 23, 42, 0.8);
            padding: 0.35rem;
            border-radius: var(--radius-sm);
            margin-bottom: 1.75rem;
            border: 1px solid var(--border-color);
        }
        .role-tab {
            flex: 1;
            padding: 0.65rem;
            text-align: center;
            font-weight: 600;
            font-size: 0.88rem;
            color: var(--text-secondary);
            border-radius: 6px;
            cursor: pointer;
            transition: var(--transition);
        }
        .role-tab.active {
            background: var(--accent-gradient);
            color: #fff;
            box-shadow: 0 4px 12px var(--accent-glow);
        }
        .demo-chip {
            background: rgba(255, 255, 255, 0.06);
            border: 1px dashed var(--border-color);
            padding: 0.5rem 0.75rem;
            border-radius: var(--radius-sm);
            font-size: 0.8rem;
            color: var(--text-secondary);
            cursor: pointer;
            transition: var(--transition);
        }
        .demo-chip:hover {
            border-color: var(--accent-primary);
            color: var(--text-primary);
            background: rgba(99, 102, 241, 0.1);
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <a href="index.jsp" class="brand">
            <div class="brand-icon"><i class="fa-solid fa-hands-holding-child"></i></div>
            <span class="brand-title">EventVolunteer</span>
        </a>
        <div class="user-menu">
            <a href="volunteer/register.jsp" class="btn btn-primary"><i class="fa-solid fa-user-plus"></i> Join as Volunteer</a>
        </div>
    </nav>

    <div class="container" style="display: flex; align-items: center; justify-content: center; min-height: 80vh;">
        <div class="glass-panel login-wrapper" style="padding: 0;">
            <!-- Form Card -->
            <div class="login-card">
                <h2 style="font-size: 1.75rem; margin-bottom: 0.35rem;">Portal Login</h2>
                <p style="color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 1.25rem;">Choose your portal role to continue</p>

                <div style="background: rgba(15, 23, 42, 0.5); padding: 0.85rem; border-radius: var(--radius-md); border: 1px solid var(--border-color); margin-bottom: 1.5rem;">
                    <div style="font-size: 0.78rem; font-weight: 700; color: var(--accent-primary); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 0.4rem;">
                        <i class="fa-solid fa-key"></i> Quick Demo Access:
                    </div>
                    <div style="display: flex; gap: 0.5rem; flex-wrap: wrap;">
                        <button class="demo-chip" type="button" onclick="fillDemo('admin@event.com', 'admin123', 'admin')">
                            <i class="fa-solid fa-user-gear"></i> Admin Demo
                        </button>
                        <button class="demo-chip" type="button" onclick="fillDemo('john@volunteer.com', 'vol123', 'volunteer')">
                            <i class="fa-solid fa-user"></i> Volunteer Demo
                        </button>
                    </div>
                </div>

                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div class="alert alert-danger">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                <% } %>

                <% if ("registered".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-success">
                        <i class="fa-solid fa-circle-check"></i> Account registered successfully! Please login below.
                    </div>
                <% } %>

                <% if ("logged_out".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-info">
                        <i class="fa-solid fa-info-circle"></i> Logged out safely.
                    </div>
                <% } %>

                <form action="LoginServlet" method="post" id="loginForm">
                    <input type="hidden" name="role" id="roleInput" value="volunteer">

                    <div class="role-tabs">
                        <div class="role-tab active" id="tabVolunteer" onclick="selectRole('volunteer')">
                            <i class="fa-solid fa-user"></i> Volunteer
                        </div>
                        <div class="role-tab" id="tabAdmin" onclick="selectRole('admin')">
                            <i class="fa-solid fa-user-gear"></i> Admin / Coordinator
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" id="emailLabel">Email Address</label>
                        <input type="email" name="email" id="emailInput" class="form-control" placeholder="name@example.com" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Password</label>
                        <input type="password" name="password" id="passwordInput" class="form-control" placeholder="••••••••" required>
                    </div>

                    <button type="submit" class="btn btn-primary" style="width: 100%; justify-content: center; margin-top: 1.25rem; padding: 0.85rem;">
                        <i class="fa-solid fa-right-to-bracket"></i> Sign In to Portal
                    </button>
                </form>

                <div style="text-align: center; margin-top: 1.75rem; font-size: 0.88rem; color: var(--text-secondary);">
                    New volunteer? <a href="volunteer/register.jsp" style="color: var(--accent-primary); font-weight: 600; text-decoration: none;">Create Account</a>
                </div>
            </div>
        </div>
    </div>

    <footer class="footer">
        &copy; 2026 Event Volunteer Management System
    </footer>

    <script src="js/main.js"></script>
    <script>
        function selectRole(role) {
            document.getElementById('roleInput').value = role;
            const tabVol = document.getElementById('tabVolunteer');
            const tabAdm = document.getElementById('tabAdmin');
            if (role === 'volunteer') {
                tabVol.classList.add('active');
                tabAdm.classList.remove('active');
                document.getElementById('emailLabel').innerText = 'Volunteer Email Address';
            } else {
                tabAdm.classList.add('active');
                tabVol.classList.remove('active');
                document.getElementById('emailLabel').innerText = 'Admin Email Address';
            }
        }

        function fillDemo(email, pass, role) {
            selectRole(role);
            document.getElementById('emailInput').value = email;
            document.getElementById('passwordInput').value = pass;
        }
    </script>
</body>
</html>
