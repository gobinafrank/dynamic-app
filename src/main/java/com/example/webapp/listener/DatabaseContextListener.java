package com.example.webapp.listener;

import com.example.webapp.db.DatabaseConnection;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class DatabaseContextListener implements ServletContextListener {
    private static final Logger logger = LogManager.getLogger(DatabaseContextListener.class);
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        logger.info("Application context initialized, database connection pool is ready");
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        logger.info("Application context being destroyed, closing database connection pool");
        DatabaseConnection.closeDataSource();
    }
}
