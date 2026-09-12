package com.event.servlet;

import com.event.dao.AttendanceDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/CheckOutServlet")
public class CheckOutServlet extends HttpServlet {
    private AttendanceDao attendanceDao = new AttendanceDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
        attendanceDao.recordCheckOut(assignmentId);
        response.sendRedirect("volunteer/attendance.jsp?msg=checked_out");
    }
}
