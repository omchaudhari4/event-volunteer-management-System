package com.event.servlet;

import com.event.dao.ApplicationDao;
import com.event.dao.DutyDao;
import com.event.model.DutyAssignment;
import com.event.model.EventApplication;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AssignDutyServlet")
public class AssignDutyServlet extends HttpServlet {
    private DutyDao dutyDao = new DutyDao();
    private ApplicationDao appDao = new ApplicationDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int applicationId = Integer.parseInt(request.getParameter("applicationId"));
        String dutyTitle = request.getParameter("dutyTitle");
        String dutyLocation = request.getParameter("dutyLocation");
        String startTime = request.getParameter("startTime");
        String endTime = request.getParameter("endTime");

        EventApplication app = appDao.getById(applicationId);
        if (app != null && "Approved".equalsIgnoreCase(app.getStatus())) {
            DutyAssignment d = new DutyAssignment();
            d.setApplicationId(app.getApplicationId());
            d.setVolunteerId(app.getVolunteerId());
            d.setEventId(app.getEventId());
            d.setDutyTitle(dutyTitle);
            d.setDutyLocation(dutyLocation);
            d.setStartTime(startTime);
            d.setEndTime(endTime);
            d.setStatus("Assigned");

            dutyDao.assignDuty(d);
            response.sendRedirect("admin/assign-duty.jsp?msg=assigned");
        } else {
            response.sendRedirect("admin/assign-duty.jsp?msg=error");
        }
    }
}
