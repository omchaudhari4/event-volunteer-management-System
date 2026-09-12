package com.event.servlet;

import com.event.dao.EventDao;
import com.event.model.Event;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/UpdateEventServlet")
public class UpdateEventServlet extends HttpServlet {
    private EventDao eventDao = new EventDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("eventId"));
        String action = request.getParameter("action");

        if ("delete".equalsIgnoreCase(action)) {
            eventDao.deleteEvent(id);
        } else {
            String name = request.getParameter("eventName");
            String date = request.getParameter("eventDate");
            String venue = request.getParameter("venue");
            String description = request.getParameter("description");
            String status = request.getParameter("status");
            String imageUrl = request.getParameter("imageUrl");
            if (imageUrl == null || imageUrl.trim().isEmpty()) {
                imageUrl = "images/event_tech_conf.png";
            }

            Event e = new Event(id, name, date, venue, description, status, imageUrl);
            eventDao.updateEvent(e);
        }

        response.sendRedirect("admin/events.jsp?msg=updated");
    }
}
