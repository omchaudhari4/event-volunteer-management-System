package com.event.servlet;

import com.event.dao.FeedbackDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AddFeedbackServlet")
public class AddFeedbackServlet extends HttpServlet {
    private FeedbackDao feedbackDao = new FeedbackDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int assignmentId = Integer.parseInt(request.getParameter("assignmentId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String feedback = request.getParameter("feedback");

        feedbackDao.addFeedback(assignmentId, rating, feedback);
        response.sendRedirect("volunteer/history.jsp?msg=feedback_submitted");
    }
}
