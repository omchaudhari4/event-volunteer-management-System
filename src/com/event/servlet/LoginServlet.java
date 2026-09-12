package com.event.servlet;

import com.event.dao.VolunteerDao;
import com.event.model.Volunteer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private VolunteerDao volunteerDao = new VolunteerDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role = request.getParameter("role"); // admin or volunteer
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        HttpSession session = request.getSession();

        if ("admin".equalsIgnoreCase(role)) {
            // Admin authentication
            if ("Omiii@gmail.com".equalsIgnoreCase(email) && "Omiii1234".equals(password)) {
                session.setAttribute("userRole", "ADMIN");
                session.setAttribute("userName", "Admin Coordinator");
                session.setAttribute("userEmail", email);
                response.sendRedirect("admin/dashboard.jsp");
                return;
            } else {
                request.setAttribute("errorMessage", "Invalid Admin credentials.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
        } else {
            // Volunteer authentication
            Volunteer v = volunteerDao.authenticate(email, password);
            if (v != null) {
                session.setAttribute("userRole", "VOLUNTEER");
                session.setAttribute("volunteerId", v.getVolunteerId());
                session.setAttribute("volunteer", v);
                session.setAttribute("userName", v.getName());
                session.setAttribute("userEmail", v.getEmail());
                response.sendRedirect("volunteer/events.jsp");
                return;
            } else {
                request.setAttribute("errorMessage", "Invalid volunteer email or password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
        }
    }
}
