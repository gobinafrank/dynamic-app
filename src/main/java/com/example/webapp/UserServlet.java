package com.example.webapp;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.example.webapp.dao.UserDAO;
import com.example.webapp.model.User;

@WebServlet("/users")
public class UserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = LogManager.getLogger(UserServlet.class);
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        logger.info("UserServlet doGet method called");
        
        // Get all users from the database
        List<User> users = userDAO.getAllUsers();
        
        request.setAttribute("users", users);
        request.getRequestDispatcher("/user.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            // Add a new user
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            
            User newUser = new User();
            newUser.setName(name);
            newUser.setEmail(email);
            
            boolean success = userDAO.addUser(newUser);
            if (success) {
                logger.info("New user added successfully");
            } else {
                logger.warn("Failed to add new user");
            }
        } else if ("delete".equals(action)) {
            // Delete a user
            int userId = Integer.parseInt(request.getParameter("id"));
            boolean success = userDAO.deleteUser(userId);
            if (success) {
                logger.info("User deleted successfully: ID = " + userId);
            } else {
                logger.warn("Failed to delete user: ID = " + userId);
            }
        }
        
        // Redirect back to the users page
        response.sendRedirect(request.getContextPath() + "/users");
    }
}
