package com.acadify.listeners;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import com.acadify.util.AdminInitializer;
import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;

@WebListener
public class StartupListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Application starting...");
        AdminInitializer.ensureAdminExists();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Application shutting down...");
        try {
            AbandonedConnectionCleanupThread.checkedShutdown();
            System.out.println("MySQL cleanup thread shut down successfully");
        } catch (Exception e) {
            System.err.println("Error during MySQL connection cleanup:");
            e.printStackTrace();
        }
    }
}