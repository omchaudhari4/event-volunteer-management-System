package com.event.servlet;

import com.event.dao.AttendanceDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/CheckInServlet")
public class CheckInServlet extends HttpServlet {
    private AttendanceDao attendanceDao = new AttendanceDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
        attendanceDao.recordCheckIn(assignmentId);
        response.sendRedirect("volunteer/attendance.jsp?msg=checked_in");
    }
}
