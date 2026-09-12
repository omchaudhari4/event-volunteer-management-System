package com.event.servlet;

import com.event.dao.ApplicationDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/ApplyEventServlet")
public class ApplyEventServlet extends HttpServlet {
    private ApplicationDao appDao = new ApplicationDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("volunteerId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int volunteerId = (Integer) session.getAttribute("volunteerId");
        int eventId = Integer.parseInt(request.getParameter("eventId"));
        int roleId = Integer.parseInt(request.getParameter("roleId"));
        String remark = request.getParameter("remark");

        if (appDao.hasAlreadyApplied(eventId, volunteerId)) {
            response.sendRedirect("volunteer/my-applications.jsp?msg=already_applied");
            return;
        }

        boolean success = appDao.applyEvent(eventId, volunteerId, roleId, remark);
        if (success) {
            response.sendRedirect("volunteer/my-applications.jsp?msg=applied");
        } else {
            response.sendRedirect("volunteer/events.jsp?msg=error");
        }
    }
}
