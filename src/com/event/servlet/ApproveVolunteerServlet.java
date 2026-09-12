package com.event.servlet;

import com.event.dao.ApplicationDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ApproveVolunteerServlet")
public class ApproveVolunteerServlet extends HttpServlet {
    private ApplicationDao appDao = new ApplicationDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int applicationId = Integer.parseInt(request.getParameter("applicationId"));
        String remark = request.getParameter("remark");

        appDao.updateStatus(applicationId, "Approved", remark != null ? remark : "Application approved by coordinator");
        response.sendRedirect("admin/applications.jsp?msg=approved");
    }
}
