package com.event.servlet;

import com.event.dao.VolunteerDao;
import com.event.model.Volunteer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/VolunteerRegisterServlet")
public class VolunteerRegisterServlet extends HttpServlet {
    private VolunteerDao volunteerDao = new VolunteerDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String contact = request.getParameter("contact");
        String skills = request.getParameter("skills");
        String avatarUrl = request.getParameter("avatarUrl");
        if (avatarUrl == null || avatarUrl.trim().isEmpty()) {
            avatarUrl = "images/avatar_default.png";
        }

        if (name == null || email == null || password == null || name.trim().isEmpty() || email.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Name, email and password are required.");
            request.getRequestDispatcher("volunteer/register.jsp").forward(request, response);
            return;
        }

        Volunteer v = new Volunteer(0, name, email, password, contact, skills, "Active", avatarUrl);
        boolean success = volunteerDao.registerVolunteer(v);

        if (success) {
            response.sendRedirect("login.jsp?msg=registered");
        } else {
            request.setAttribute("errorMessage", "Email already registered or error creating account.");
            request.getRequestDispatcher("volunteer/register.jsp").forward(request, response);
        }
    }
}
