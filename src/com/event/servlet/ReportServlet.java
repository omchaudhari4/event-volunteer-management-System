package com.event.servlet;

import com.event.dao.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ReportServlet")
public class ReportServlet extends HttpServlet {
    private EventDao eventDao = new EventDao();
    private VolunteerDao volunteerDao = new VolunteerDao();
    private ApplicationDao appDao = new ApplicationDao();
    private DutyDao dutyDao = new DutyDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("totalEvents", eventDao.getCount());
        request.setAttribute("totalVolunteers", volunteerDao.getCount());
        request.setAttribute("pendingApps", appDao.getCountByStatus("Pending"));
        request.setAttribute("approvedApps", appDao.getCountByStatus("Approved"));

        request.getRequestDispatcher("admin/reports.jsp").forward(request, response);
    }
}
