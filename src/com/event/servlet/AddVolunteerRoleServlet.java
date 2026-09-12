package com.event.servlet;

import com.event.dao.RoleDao;
import com.event.model.VolunteerRole;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AddVolunteerRoleServlet")
public class AddVolunteerRoleServlet extends HttpServlet {
    private RoleDao roleDao = new RoleDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equalsIgnoreCase(action)) {
            int roleId = Integer.parseInt(request.getParameter("roleId"));
            roleDao.deleteRole(roleId);
        } else {
            int eventId = Integer.parseInt(request.getParameter("eventId"));
            String roleName = request.getParameter("roleName");
            int requiredCount = Integer.parseInt(request.getParameter("requiredCount"));
            String description = request.getParameter("description");

            VolunteerRole r = new VolunteerRole(0, eventId, roleName, requiredCount, description);
            roleDao.addRole(r);
        }

        response.sendRedirect("admin/volunteer-roles.jsp?msg=saved");
    }
}
