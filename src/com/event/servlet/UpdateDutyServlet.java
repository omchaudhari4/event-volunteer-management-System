package com.event.servlet;

import com.event.dao.DutyDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/UpdateDutyServlet")
public class UpdateDutyServlet extends HttpServlet {
    private DutyDao dutyDao = new DutyDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
        String status = request.getParameter("status");

        dutyDao.updateStatus(assignmentId, status);

        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("userRole") : "";

        if ("ADMIN".equals(role)) {
            response.sendRedirect("admin/assign-duty.jsp?msg=updated");
        } else {
            response.sendRedirect("volunteer/my-duty.jsp?msg=updated");
        }
    }
}
