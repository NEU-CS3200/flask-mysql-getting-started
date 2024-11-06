-- ============================================
-- Database: ToDoApp
-- ============================================

DROP DATABASE IF EXISTS ToDoApp;
CREATE DATABASE IF NOT EXISTS ToDoApp;
USE ToDoApp;

-- Drop existing tables to avoid conflicts
DROP TABLE IF EXISTS ToDoTags;
DROP TABLE IF EXISTS Tags;
DROP TABLE IF EXISTS ToDoItems;
DROP TABLE IF EXISTS TeamMembers;
DROP TABLE IF EXISTS Teams;
DROP TABLE IF EXISTS Users;

-- ============================================
-- 1. Create Users Table
-- ============================================
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================
-- 2. Create Teams Table
-- ============================================
CREATE TABLE Teams (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ============================================
-- 3. Create TeamMembers Table (Junction Table)
-- ============================================
CREATE TABLE TeamMembers (
    team_id INT,
    user_id INT,
    role VARCHAR(50),
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (team_id, user_id),
    FOREIGN KEY (team_id) REFERENCES Teams(team_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================
-- 4. Create ToDoItems Table
-- ============================================
CREATE TABLE ToDoItems (
    todo_id INT AUTO_INCREMENT PRIMARY KEY,
    team_id INT,
    user_id INT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    priority ENUM('Low', 'Medium', 'High') DEFAULT 'Medium',
    due_date DATE,
    status ENUM('Pending', 'In Progress', 'Completed') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id) ON DELETE SET NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================
-- 5. Create Tags Table
-- ============================================
CREATE TABLE Tags (
    tag_id INT AUTO_INCREMENT PRIMARY KEY,
    tag_name VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- ============================================
-- 6. Create ToDoTags Table (Junction Table)
-- ============================================
CREATE TABLE ToDoTags (
    todo_id INT,
    tag_id INT,
    PRIMARY KEY (todo_id, tag_id),
    FOREIGN KEY (todo_id) REFERENCES ToDoItems(todo_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES Tags(tag_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ============================================
-- Insert Sample Data into Users
-- ============================================
INSERT INTO Users (username, email, password_hash, full_name) VALUES
('jdoe', 'jdoe@example.com', 'hashed_password_1', 'John Doe'),
('asmith', 'asmith@example.com', 'hashed_password_2', 'Alice Smith'),
('bwilliams', 'bwilliams@example.com', 'hashed_password_3', 'Bob Williams'),
('cmiller', 'cmiller@example.com', 'hashed_password_4', 'Carol Miller');

-- ============================================
-- Insert Additional Users into Users
-- ============================================
INSERT INTO Users (username, email, password_hash, full_name) VALUES
('djohnson', 'djohnson@example.com', 'hashed_password_5', 'David Johnson'),
('emartinez', 'emartinez@example.com', 'hashed_password_6', 'Emily Martinez'),
('fgarcia', 'fgarcia@example.com', 'hashed_password_7', 'Frank Garcia'),
('hlee', 'hlee@example.com', 'hashed_password_8', 'Helen Lee'),
('ikim', 'ikim@example.com', 'hashed_password_9', 'Ian Kim'),
('jlane', 'jlane@example.com', 'hashed_password_10', 'Jessica Lane'),
('kmorris', 'kmorris@example.com', 'hashed_password_11', 'Kevin Morris'),
('lnguyen', 'lnguyen@example.com', 'hashed_password_12', 'Laura Nguyen'),
('omartin', 'omartin@example.com', 'hashed_password_13', 'Oscar Martin'),
('pturner', 'pturner@example.com', 'hashed_password_14', 'Paula Turner');

-- ============================================
-- Insert Sample Data into Teams
-- ============================================
INSERT INTO Teams (team_name, description) VALUES
('Backend Development', 'Team responsible for server-side logic and databases.'),
('Frontend Development', 'Team handling user interface and client-side applications.'),
('QA Team', 'Quality Assurance team ensuring product quality and reliability.');

-- ============================================
-- Insert Sample Data into TeamMembers
-- ============================================
-- Backend Development Team (Assuming team_id = 1)
INSERT INTO TeamMembers (team_id, user_id, role) VALUES
(1, 1, 'Team Lead'),
(1, 2, 'Developer'),
(1, 5, 'Senior Developer'),
(1, 6, 'Developer');

-- Frontend Development Team (Assuming team_id = 2)
INSERT INTO TeamMembers (team_id, user_id, role) VALUES
(2, 3, 'Team Lead'),
(2, 4, 'Developer'),
(2, 7, 'Senior Developer'),
(2, 8, 'Developer');

-- QA Team (Assuming team_id = 3)
INSERT INTO TeamMembers (team_id, user_id, role) VALUES
(3, 2, 'QA Engineer'),
(3, 4, 'QA Engineer'),
(3, 9, 'Senior QA Engineer'),
(3, 10, 'QA Engineer'),
(3, 11, 'Automation Engineer'),
(3, 12, 'QA Engineer'),
(3, 13, 'QA Engineer'),
(3, 14, 'QA Engineer');

-- ============================================
-- Insert Sample Data into Tags
-- ============================================
INSERT INTO Tags (tag_name) VALUES
('#bug'),
('#feature'),
('#urgent'),
('#frontend'),
('#backend'),
('#documentation'),
('#testing'),
('#deployment'),
('#performance'),
('#design'),
('#automation');

-- ============================================
-- Insert Sample Data into ToDoItems
-- ============================================
INSERT INTO ToDoItems (team_id, user_id, title, description, priority, due_date, status) VALUES
-- Backend Development Team
(1, 1, 'Implement Authentication Module', 'Develop JWT-based authentication for the API.', 'High', '2024-12-15', 'In Progress'),
(1, 2, 'Optimize Database Queries', 'Improve the performance of user data retrieval.', 'Medium', '2024-12-20', 'Pending'),
(1, 5, 'Set Up CI/CD Pipeline', 'Automate the deployment process using Jenkins.', 'High', '2024-12-25', 'Pending'),
(1, 6, 'Refactor User Service', 'Clean up and optimize the user service codebase.', 'Low', '2025-01-10', 'Pending'),

-- Frontend Development Team
(2, 3, 'Design Landing Page', 'Create responsive design for the landing page.', 'High', '2024-12-10', 'In Progress'),
(2, 4, 'Integrate API Endpoints', 'Connect frontend with backend APIs for user data.', 'Medium', '2024-12-18', 'Pending'),
(2, 7, 'Develop Dashboard UI', 'Build the user dashboard with real-time data visualization.', 'High', '2024-12-22', 'Pending'),
(2, 8, 'Improve Mobile Responsiveness', 'Ensure the application is fully responsive on mobile devices.', 'Medium', '2025-01-05', 'Pending'),

-- QA Team
(3, 2, 'Write Test Cases for Authentication', 'Develop comprehensive test cases for the new auth module.', 'High', '2024-12-12', 'Pending'),
(3, 4, 'Automate Regression Testing', 'Set up automation scripts for regression tests.', 'Low', '2025-01-05', 'Pending'),
(3, 9, 'Conduct Load Testing', 'Evaluate system performance under high load conditions.', 'Medium', '2025-01-15', 'Pending'),
(3, 10, 'Bug Tracking and Reporting', 'Monitor and report bugs found during testing.', 'High', '2024-12-20', 'Pending'),
(3, 11, 'Develop Automation Scripts', 'Create scripts to automate repetitive testing tasks.', 'High', '2025-01-10', 'Pending'),
(3, 12, 'User Acceptance Testing', 'Coordinate UAT sessions with stakeholders.', 'Medium', '2025-01-20', 'Pending'),
(3, 13, 'Security Testing', 'Perform security assessments to identify vulnerabilities.', 'High', '2025-02-01', 'Pending'),
(3, 14, 'Performance Benchmarking', 'Establish performance benchmarks for the application.', 'Medium', '2025-02-10', 'Pending');

-- ============================================
-- Insert Sample Data into ToDoTags
-- ============================================
-- Assuming the following tag_ids based on insertion order:
-- 1: #bug
-- 2: #feature
-- 3: #urgent
-- 4: #frontend
-- 5: #backend
-- 6: #documentation
-- 7: #testing
-- 8: #deployment
-- 9: #performance
-- 10: #design
-- 11: #automation

-- ToDoItem 1: Implement Authentication Module (todo_id = 1)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(1, 5),  -- #backend
(1, 2),  -- #feature
(1, 3);  -- #urgent

-- ToDoItem 2: Optimize Database Queries (todo_id = 2)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(2, 5),  -- #backend
(2, 9);  -- #performance

-- ToDoItem 3: Set Up CI/CD Pipeline (todo_id = 3)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(3, 8),  -- #deployment
(3, 11); -- #automation

-- ToDoItem 4: Refactor User Service (todo_id = 4)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(4, 5),  -- #backend
(4, 6);  -- #documentation

-- ToDoItem 5: Design Landing Page (todo_id = 5)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(5, 4),  -- #frontend
(5, 10), -- #design
(5, 3);  -- #urgent

-- ToDoItem 6: Integrate API Endpoints (todo_id = 6)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(6, 4),  -- #frontend
(6, 5);  -- #backend

-- ToDoItem 7: Develop Dashboard UI (todo_id = 7)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(7, 4),  -- #frontend
(7, 2),  -- #feature
(7, 9);  -- #performance

-- ToDoItem 8: Improve Mobile Responsiveness (todo_id = 8)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(8, 4),  -- #frontend
(8, 10); -- #design

-- ToDoItem 9: Write Test Cases for Authentication (todo_id = 9)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(9, 7),  -- #testing
(9, 5),  -- #backend
(9, 6);  -- #documentation

-- ToDoItem 10: Automate Regression Testing (todo_id = 10)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(10, 7),  -- #testing
(10, 11); -- #automation

-- ToDoItem 11: Conduct Load Testing (todo_id = 11)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(11, 7),  -- #testing
(11, 9);  -- #performance

-- ToDoItem 12: Bug Tracking and Reporting (todo_id = 12)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(12, 1),  -- #bug
(12, 7);  -- #testing

-- ToDoItem 13: Develop Automation Scripts (todo_id = 13)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(13, 11), -- #automation
(13, 7);  -- #testing

-- ToDoItem 14: User Acceptance Testing (todo_id = 14)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(14, 7),  -- #testing
(14, 6);  -- #documentation

-- ToDoItem 15: Security Testing (todo_id = 15)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(15, 7),  -- #testing
(15, 1);  -- #bug

-- ToDoItem 16: Performance Benchmarking (todo_id = 16)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(16, 9),  -- #performance
(16, 7);  -- #testing

-- ============================================
-- Insert 100 Additional ToDoItems and ToDoTags
-- ============================================

-- For brevity, we'll insert the additional 100 ToDoItems and their corresponding ToDoTags.
-- This section includes ToDoItems from todo_id = 17 to todo_id = 116.

-- ============================================
-- Insert Additional ToDoItems into ToDoItems
-- ============================================
DELETE from ToDoItems;
INSERT INTO ToDoItems (team_id, user_id, title, description, priority, due_date, status) VALUES
-- Backend Development Team ToDoItems (todo_id = 17-56)
(1, 1, 'Develop Payment Gateway Integration', 'Integrate Stripe API for processing payments.', 'High', '2024-12-20', 'Pending'),
(1, 2, 'Implement Caching Mechanism', 'Use Redis to cache frequently accessed data.', 'Medium', '2024-12-25', 'Pending'),
(1, 5, 'Migrate Database to PostgreSQL', 'Transfer all data from MySQL to PostgreSQL.', 'High', '2025-01-15', 'Pending'),
(1, 6, 'Create API Documentation', 'Document all RESTful API endpoints using Swagger.', 'Low', '2025-02-01', 'Pending'),
(1, 7, 'Set Up Monitoring Tools', 'Implement monitoring using Prometheus and Grafana.', 'Medium', '2025-01-20', 'Pending'),
(1, 8, 'Implement Rate Limiting', 'Prevent abuse by limiting API request rates.', 'High', '2024-12-30', 'Pending'),
(1, 9, 'Optimize Image Storage', 'Store images in AWS S3 and serve via CDN.', 'Medium', '2025-01-25', 'Pending'),
(1, 10, 'Develop Notification Service', 'Create a service for sending email and SMS notifications.', 'High', '2025-02-10', 'Pending'),
(1, 11, 'Integrate Third-Party Analytics', 'Connect Google Analytics for tracking user behavior.', 'Low', '2025-02-15', 'Pending'),
(1, 12, 'Implement OAuth2 Authentication', 'Allow users to log in using Google and Facebook accounts.', 'Medium', '2025-01-05', 'Pending'),
(1, 13, 'Database Backup Automation', 'Automate daily backups of the production database.', 'Low', '2025-01-30', 'Pending'),
(1, 14, 'Refactor Legacy Codebase', 'Modernize the existing code for better maintainability.', 'High', '2025-02-20', 'Pending'),
(1, 1, 'Develop Microservices Architecture', 'Break down monolithic application into microservices.', 'High', '2025-03-01', 'Pending'),
(1, 2, 'Implement GraphQL API', 'Create a GraphQL interface for frontend queries.', 'Medium', '2025-02-10', 'Pending'),
(1, 5, 'Enhance Security Measures', 'Implement additional security layers like two-factor authentication.', 'High', '2025-03-15', 'Pending'),
(1, 6, 'Optimize Server Performance', 'Improve server response times and reduce latency.', 'Medium', '2025-02-25', 'Pending'),
(1, 7, 'Set Up Continuous Integration', 'Automate testing and building using CI tools.', 'High', '2025-03-05', 'Pending'),
(1, 8, 'Implement Data Encryption', 'Encrypt sensitive data at rest and in transit.', 'High', '2025-03-10', 'Pending'),
(1, 9, 'Develop API Rate Monitoring', 'Track and monitor API usage rates.', 'Medium', '2025-02-20', 'Pending'),
(1, 10, 'Create Developer Portal', 'Build a portal for third-party developers to access APIs.', 'Low', '2025-03-25', 'Pending'),
(1, 11, 'Implement Webhooks', 'Allow external systems to receive real-time data via webhooks.', 'Medium', '2025-03-15', 'Pending'),
(1, 12, 'Database Indexing Optimization', 'Improve query performance through indexing.', 'High', '2025-02-28', 'Pending'),
(1, 13, 'Implement API Versioning', 'Support multiple API versions for backward compatibility.', 'Medium', '2025-03-20', 'Pending'),
(1, 14, 'Set Up SSL Certificates', 'Ensure all communications are secured with SSL.', 'High', '2025-02-05', 'Pending'),
(1, 1, 'Develop Real-Time Chat Feature', 'Implement a real-time chat system using WebSockets.', 'High', '2025-03-30', 'Pending'),
(1, 2, 'Optimize Backend Load Balancing', 'Enhance load balancing for better scalability.', 'Medium', '2025-04-10', 'Pending'),
(1, 5, 'Implement Serverless Functions', 'Use AWS Lambda for specific backend tasks.', 'Low', '2025-04-15', 'Pending'),
(1, 6, 'Develop Admin Dashboard', 'Create an admin interface for managing users and data.', 'High', '2025-04-20', 'Pending'),
(1, 7, 'Integrate Payment Notifications', 'Receive and process payment success and failure notifications.', 'Medium', '2025-04-25', 'Pending'),
(1, 8, 'Set Up Error Logging', 'Implement comprehensive error logging using ELK stack.', 'Low', '2025-05-01', 'Pending'),
(1, 9, 'Implement API Throttling', 'Control the rate of incoming API requests.', 'Medium', '2025-05-05', 'Pending'),
(1, 10, 'Develop API Health Check', 'Create endpoints to monitor API health and status.', 'Low', '2025-05-10', 'Pending'),
(1, 11, 'Optimize Backend Codebase', 'Refactor code for better performance and readability.', 'Medium', '2025-05-15', 'Pending'),
(1, 12, 'Implement Data Migration Scripts', 'Automate data migration processes for future updates.', 'High', '2025-05-20', 'Pending'),
(1, 13, 'Set Up Automated Testing', 'Integrate automated tests into the CI pipeline.', 'Medium', '2025-05-25', 'Pending'),
(1, 14, 'Develop API Rate Limiting Policies', 'Define and enforce rate limiting policies for different user tiers.', 'High', '2025-06-01', 'Pending'),
-- Frontend Development Team ToDoItems (todo_id = 58-98)
(2, 3, 'Implement Dark Mode', 'Allow users to switch between light and dark themes.', 'Medium', '2024-12-18', 'Pending'),
(2, 4, 'Optimize Asset Loading', 'Improve the loading times of images and scripts.', 'High', '2024-12-22', 'Pending'),
(2, 7, 'Develop User Profile Page', 'Create a page where users can view and edit their profiles.', 'Medium', '2024-12-28', 'Pending'),
(2, 8, 'Implement Drag and Drop', 'Add drag-and-drop functionality to the task board.', 'Low', '2025-01-08', 'Pending'),
(2, 9, 'Create Responsive Navigation Bar', 'Ensure the navigation bar works seamlessly on all devices.', 'Medium', '2025-01-12', 'Pending'),
(2, 10, 'Integrate Real-Time Notifications', 'Display real-time updates and notifications to users.', 'High', '2025-01-18', 'Pending'),
(2, 11, 'Develop Search Functionality', 'Allow users to search for tasks and projects.', 'Medium', '2025-01-22', 'Pending'),
(2, 12, 'Implement Lazy Loading', 'Load images and components only when they are in the viewport.', 'Low', '2025-01-28', 'Pending'),
(2, 13, 'Enhance Accessibility Features', 'Ensure the application is accessible to all users.', 'High', '2025-02-02', 'Pending'),
(2, 14, 'Create Interactive Charts', 'Display data using interactive charting libraries.', 'Medium', '2025-02-06', 'Pending'),
(2, 3, 'Optimize CSS for Performance', 'Reduce CSS size and improve rendering times.', 'Low', '2025-02-10', 'Pending'),
(2, 4, 'Implement Form Validation', 'Add client-side validation to all forms.', 'Medium', '2025-02-14', 'Pending'),
(2, 7, 'Develop Mobile App Integration', 'Ensure the web app integrates seamlessly with the mobile app.', 'High', '2025-02-20', 'Pending'),
(2, 8, 'Create Multi-language Support', 'Allow users to select their preferred language.', 'Low', '2025-02-24', 'Pending'),
(2, 9, 'Implement Infinite Scrolling', 'Load more content as the user scrolls down.', 'Medium', '2025-02-28', 'Pending'),
(2, 10, 'Develop Interactive Tutorials', 'Guide new users with interactive tutorials.', 'High', '2025-03-04', 'Pending'),
(2, 11, 'Optimize JavaScript Bundles', 'Reduce the size of JS bundles for faster loading.', 'Medium', '2025-03-08', 'Pending'),
(2, 12, 'Implement Client-side Caching', 'Cache data on the client to reduce server requests.', 'Low', '2025-03-12', 'Pending'),
(2, 13, 'Develop Custom UI Components', 'Create reusable UI components for the application.', 'Medium', '2025-03-16', 'Pending'),
(2, 14, 'Integrate Third-Party Libraries', 'Incorporate libraries like lodash and moment.js as needed.', 'Low', '2025-03-20', 'Pending'),
(2, 3, 'Enhance Animation Effects', 'Add smooth animations to improve user experience.', 'Medium', '2025-03-24', 'Pending'),
(2, 4, 'Implement SEO Best Practices', 'Optimize the application for search engines.', 'High', '2025-03-28', 'Pending'),
(2, 7, 'Develop User Onboarding Flow', 'Create a seamless onboarding process for new users.', 'Medium', '2025-04-01', 'Pending'),
(2, 8, 'Create Custom Themes', 'Allow users to customize the look and feel of the app.', 'Low', '2025-04-05', 'Pending'),
(2, 9, 'Implement Real-Time Data Updates', 'Use WebSockets to display live data updates.', 'High', '2025-04-09', 'Pending'),
(2, 10, 'Optimize Image Assets', 'Compress and optimize images for faster loading.', 'Medium', '2025-04-13', 'Pending'),
(2, 11, 'Develop Interactive Forms', 'Enhance forms with interactive elements and feedback.', 'Medium', '2025-04-17', 'Pending'),
(2, 12, 'Implement Breadcrumb Navigation', 'Add breadcrumb trails for better navigation.', 'Low', '2025-04-21', 'Pending'),
(2, 13, 'Create Custom Scrollbars', 'Design and implement custom scrollbar styles.', 'Low', '2025-04-25', 'Pending'),
(2, 14, 'Develop Single Page Application (SPA)', 'Ensure the frontend behaves as an SPA for better UX.', 'High', '2025-04-29', 'Pending'),
-- QA Team ToDoItems (todo_id = 99-116)
(3, 2, 'Review API Endpoints', 'Ensure all API endpoints meet the required standards.', 'High', '2024-12-15', 'Pending'),
(3, 4, 'Test Cross-Browser Compatibility', 'Verify application works across different browsers.', 'Medium', '2024-12-18', 'Pending'),
(3, 9, 'Conduct Security Audits', 'Identify and address security vulnerabilities.', 'High', '2025-01-25', 'Pending'),
(3, 10, 'Perform Usability Testing', 'Assess the applications ease of use.', 'Medium', '2025-01-30', 'Pending'),
(3, 11, 'Set Up Automated Test Suites', 'Create and maintain automated tests.', 'High', '2025-02-05', 'Pending'),
(3, 12, 'Conduct Beta Testing', 'Coordinate beta testing with selected users.', 'Medium', '2025-02-10', 'Pending'),
(3, 13, 'Develop Test Plans', 'Outline comprehensive test plans for upcoming features.', 'Low', '2025-02-15', 'Pending'),
(3, 14, 'Integrate Testing Tools', 'Incorporate tools like Selenium and JUnit.', 'Medium', '2025-02-20', 'Pending'),
(3, 2, 'Monitor Bug Reports', 'Track and manage incoming bug reports.', 'High', '2025-02-25', 'Pending'),
(3, 4, 'Validate Data Integrity', 'Ensure data consistency and accuracy across the application.', 'Medium', '2025-03-01', 'Pending'),
(3, 9, 'Conduct Regression Tests', 'Verify that new changes do not break existing functionality.', 'High', '2025-03-05', 'Pending'),
(3, 10, 'Perform Load Testing', 'Assess how the application performs under heavy load.', 'Medium', '2025-03-10', 'Pending'),
(3, 11, 'Set Up Continuous Testing', 'Integrate testing into the CI/CD pipeline.', 'High', '2025-03-15', 'Pending'),
(3, 12, 'Develop Testing Metrics', 'Define metrics to evaluate testing effectiveness.', 'Low', '2025-03-20', 'Pending'),
(3, 13, 'Implement Smoke Testing', 'Quickly verify major functionalities after deployments.', 'Medium', '2025-03-25', 'Pending'),
(3, 14, 'Create Test Data Sets', 'Generate realistic data for testing purposes.', 'Low', '2025-03-30', 'Pending'),
(3, 2, 'Review User Stories', 'Ensure all user stories have corresponding test cases.', 'High', '2025-04-04', 'Pending'),
(3, 4, 'Conduct Compatibility Testing', 'Test application compatibility with various devices.', 'Medium', '2025-04-09', 'Pending'),
(3, 9, 'Perform Accessibility Testing', 'Ensure the application meets accessibility standards.', 'High', '2025-04-14', 'Pending'),
(3, 10, 'Monitor Testing Coverage', 'Track the extent of code covered by tests.', 'Medium', '2025-04-19', 'Pending'),
(3, 11, 'Conduct API Testing', 'Verify the functionality and reliability of APIs.', 'High', '2025-04-24', 'Pending'),
(3, 12, 'Develop Test Automation Framework', 'Create a framework to support automated testing.', 'High', '2025-04-29', 'Pending'),
(3, 13, 'Implement Performance Testing', 'Measure application performance metrics.', 'Medium', '2025-05-04', 'Pending'),
(3, 14, 'Coordinate with Development Team', 'Ensure seamless collaboration between QA and Dev teams.', 'Low', '2025-05-09', 'Pending'),
(3, 2, 'Update Test Documentation', 'Maintain up-to-date test plans and cases.', 'Low', '2025-05-14', 'Pending'),
(3, 4, 'Conduct End-to-End Testing', 'Validate the complete workflow of the application.', 'High', '2025-05-19', 'Pending'),
(3, 9, 'Implement Continuous Monitoring', 'Set up monitoring tools to track application health.', 'Medium', '2025-05-24', 'Pending'),
(3, 10, 'Perform Data Migration Testing', 'Ensure data is accurately migrated during updates.', 'High', '2025-05-29', 'Pending'),
(3, 11, 'Develop Integration Tests', 'Test the integration points between different modules.', 'Medium', '2025-06-03', 'Pending'),
(3, 12, 'Conduct Localization Testing', 'Verify the application works correctly in different locales.', 'Low', '2025-06-08', 'Pending'),
(3, 13, 'Set Up Test Environments', 'Create and manage environments for testing purposes.', 'Medium', '2025-06-13', 'Pending'),
(3, 14, 'Monitor Test Execution', 'Track the progress and results of test runs.', 'Low', '2025-06-18', 'Pending'),
(3, 2, 'Conduct Security Penetration Testing', 'Identify potential security breaches.', 'High', '2025-06-23', 'Pending'),
(3, 4, 'Review Test Results', 'Analyze and report on testing outcomes.', 'Medium', '2025-06-28', 'Pending'),
(3, 9, 'Update Testing Tools', 'Upgrade and maintain testing tools and software.', 'Low', '2025-07-03', 'Pending'),
(3, 10, 'Develop User Feedback Surveys', 'Create surveys to gather user feedback on the application.', 'Medium', '2025-07-08', 'Pending'),
(3, 11, 'Implement Test Data Management', 'Organize and manage test data efficiently.', 'Low', '2025-07-13', 'Pending'),
(3, 12, 'Conduct Exploratory Testing', 'Explore the application to find hidden defects.', 'High', '2025-07-18', 'Pending'),
(3, 13, 'Automate UI Testing', 'Use tools like Selenium to automate UI tests.', 'Medium', '2025-07-23', 'Pending'),
(3, 14, 'Perform API Load Testing', 'Test API performance under various load conditions.', 'High', '2025-07-28', 'Pending'),
(3, 2, 'Develop Test Reporting Dashboards', 'Create dashboards to visualize test metrics.', 'Medium', '2025-08-02', 'Pending'),
(3, 4, 'Set Up Continuous Feedback Loop', 'Ensure feedback from QA is continuously integrated.', 'High', '2025-08-07', 'Pending'),
(3, 9, 'Conduct Cross-Functional Testing', 'Collaborate with other teams for comprehensive testing.', 'Medium', '2025-08-12', 'Pending'),
(3, 10, 'Implement Test Case Management', 'Organize and manage test cases effectively.', 'Low', '2025-08-17', 'Pending'),
(3, 11, 'Develop Mobile App Test Plans', 'Create test plans specifically for the mobile application.', 'High', '2025-08-22', 'Pending'),
(3, 12, 'Perform Data Integrity Checks', 'Ensure data remains consistent after operations.', 'Medium', '2025-08-27', 'Pending'),
(3, 13, 'Set Up Test Data Generation Scripts', 'Automate the creation of test data.', 'Low', '2025-09-01', 'Pending'),
(3, 14, 'Conduct Smoke Tests Post-Deployment', 'Quickly verify major functionalities after deployment.', 'High', '2025-09-06', 'Pending'),
(3, 2, 'Monitor Application Logs', 'Regularly check logs for errors and anomalies.', 'Medium', '2025-09-11', 'Pending'),
(3, 4, 'Develop API Security Tests', 'Create tests to ensure API security measures are effective.', 'High', '2025-09-16', 'Pending'),
(3, 9, 'Implement Test Data Anonymization', 'Ensure test data does not contain sensitive information.', 'Low', '2025-09-21', 'Pending'),
(3, 10, 'Conduct Stress Testing', 'Determine the applications robustness under extreme conditions.', 'High', '2025-09-26', 'Pending'),
(3, 11, 'Develop Test Automation Scripts', 'Write scripts to automate repetitive testing tasks.', 'Medium', '2025-10-01', 'Pending'),
(3, 12, 'Perform Compatibility Testing with Third-Party Services', 'Ensure compatibility with integrated third-party services.', 'High', '2025-10-06', 'Pending'),
(3, 13, 'Set Up Test Case Versioning', 'Manage different versions of test cases effectively.', 'Low', '2025-10-11', 'Pending'),
(3, 14, 'Conduct Recovery Testing', 'Verify the application can recover from failures.', 'Medium', '2025-10-16', 'Pending');

INSERT INTO ToDoItems (team_id, user_id, title, description, priority, due_date, status) VALUES
(3, 2, 'Implement Automated Test Reporting', 'Create a system to automatically generate test reports after test runs.', 'High', '2025-08-30', 'Pending'),
(3, 4, 'Review Security Test Cases', 'Ensure all security-related test cases are comprehensive and up-to-date.', 'Medium', '2025-09-05', 'Pending'),
(3, 9, 'Conduct Vulnerability Scans', 'Perform regular vulnerability scans to identify security weaknesses.', 'High', '2025-09-10', 'Pending'),
(3, 10, 'Develop Test Data Anonymization Processes', 'Implement processes to anonymize sensitive test data.', 'Medium', '2025-09-15', 'Pending'),
(3, 11, 'Set Up Continuous Integration for QA', 'Integrate QA testing into the CI pipeline for automated testing.', 'High', '2025-09-20', 'Pending'),
(3, 12, 'Coordinate Regression Testing Cycles', 'Organize and manage regression testing cycles for new releases.', 'Medium', '2025-09-25', 'Pending'),
(3, 13, 'Develop Test Case Optimization Strategies', 'Optimize test cases to reduce redundancy and improve efficiency.', 'Low', '2025-09-30', 'Pending'),
(3, 14, 'Implement Real-Time Test Monitoring', 'Set up tools to monitor test execution in real-time.', 'High', '2025-10-05', 'Pending'),
(3, 2, 'Review and Update Test Documentation', 'Ensure all test documentation is current and accurate.', 'Medium', '2025-10-10', 'Pending'),
(3, 4, 'Conduct API Security Testing', 'Test APIs for security vulnerabilities and compliance.', 'High', '2025-10-15', 'Pending');
-- Additional ToDoItems (todo_id = 99-116) can be filled similarly if needed.

-- ============================================
-- Insert Additional ToDoTags into ToDoTags
-- ============================================

-- ToDoItem 17: Develop Payment Gateway Integration (todo_id = 17)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(17, 2),  -- #feature
(17, 8),  -- #deployment
(17, 5);  -- #backend

-- ToDoItem 18: Implement Caching Mechanism (todo_id = 18)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(18, 5),  -- #backend
(18, 9);  -- #performance

-- ToDoItem 19: Migrate Database to PostgreSQL (todo_id = 19)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(19, 5),  -- #backend
(19, 6),  -- #documentation
(19, 9);  -- #performance

-- ToDoItem 20: Create API Documentation (todo_id = 20)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(20, 6),  -- #documentation
(20, 2);  -- #feature

-- ToDoItem 21: Set Up Monitoring Tools (todo_id = 21)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(21, 9),  -- #performance
(21, 8);  -- #deployment

-- ToDoItem 22: Implement Rate Limiting (todo_id = 22)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(22, 5),  -- #backend
(22, 3);  -- #urgent

-- ToDoItem 23: Optimize Image Storage (todo_id = 23)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(23, 5),  -- #backend
(23, 9);  -- #performance

-- ToDoItem 24: Develop Notification Service (todo_id = 24)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(24, 2),  -- #feature
(24, 8);  -- #deployment

-- ToDoItem 25: Integrate Third-Party Analytics (todo_id = 25)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(25, 2),  -- #feature
(25, 6);  -- #documentation

-- ToDoItem 26: Implement OAuth2 Authentication (todo_id = 26)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(26, 5),  -- #backend
(26, 2);  -- #feature

-- ToDoItem 27: Database Backup Automation (todo_id = 27)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(27, 5),  -- #backend
(27, 6);  -- #documentation

-- ToDoItem 28: Refactor Legacy Codebase (todo_id = 28)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(28, 5),  -- #backend
(28, 2);  -- #feature

-- ToDoItem 29: Develop Microservices Architecture (todo_id = 29)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(29, 5),  -- #backend
(29, 2);  -- #feature

-- ToDoItem 30: Implement GraphQL API (todo_id = 30)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(30, 5),  -- #backend
(30, 2);  -- #feature

-- ToDoItem 31: Enhance Security Measures (todo_id = 31)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(31, 1),  -- #bug
(31, 5),  -- #backend
(31, 3);  -- #urgent

-- ToDoItem 32: Optimize Server Performance (todo_id = 32)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(32, 5),  -- #backend
(32, 9);  -- #performance

-- ToDoItem 33: Set Up Continuous Integration (todo_id = 33)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(33, 8),  -- #deployment
(33, 11); -- #automation

-- ToDoItem 34: Implement Data Encryption (todo_id = 34)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(34, 1),  -- #bug
(34, 5),  -- #backend
(34, 3);  -- #urgent

-- ToDoItem 35: Develop Admin Dashboard (todo_id = 35)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(35, 2),  -- #feature
(35, 6);  -- #documentation

-- ToDoItem 36: Integrate Payment Notifications (todo_id = 36)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(36, 2),  -- #feature
(36, 8);  -- #deployment

-- ToDoItem 37: Set Up Error Logging (todo_id = 37)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(37, 1),  -- #bug
(37, 6);  -- #documentation

-- ToDoItem 38: Implement API Throttling (todo_id = 38)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(38, 5),  -- #backend
(38, 3);  -- #urgent

-- ToDoItem 39: Create API Health Check (todo_id = 39)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(39, 2),  -- #feature
(39, 6);  -- #documentation

-- ToDoItem 40: Optimize Backend Codebase (todo_id = 40)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(40, 5),  -- #backend
(40, 2);  -- #feature

-- ToDoItem 41: Implement Data Migration Scripts (todo_id = 41)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(41, 5),  -- #backend
(41, 6);  -- #documentation

-- ToDoItem 42: Set Up Automated Testing (todo_id = 42)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(42, 7),  -- #testing
(42, 11); -- #automation

-- ToDoItem 43: Develop API Rate Limiting Policies (todo_id = 43)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(43, 5),  -- #backend
(43, 3);  -- #urgent

-- ToDoItem 44: Implement Dark Mode (todo_id = 44)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(44, 4),  -- #frontend
(44, 10); -- #design

-- ToDoItem 45: Optimize Asset Loading (todo_id = 45)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(45, 4),  -- #frontend
(45, 9);  -- #performance

-- ToDoItem 46: Develop User Profile Page (todo_id = 46)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(46, 4),  -- #frontend
(46, 2);  -- #feature

-- ToDoItem 47: Implement Drag and Drop (todo_id = 47)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(47, 4),  -- #frontend
(47, 2);  -- #feature

-- ToDoItem 48: Create Responsive Navigation Bar (todo_id = 48)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(48, 4),  -- #frontend
(48, 10); -- #design

-- ToDoItem 49: Integrate Real-Time Notifications (todo_id = 49)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(49, 4),  -- #frontend
(49, 2);  -- #feature

-- ToDoItem 50: Develop Search Functionality (todo_id = 50)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(50, 4),  -- #frontend
(50, 2);  -- #feature

-- ToDoItem 51: Implement Lazy Loading (todo_id = 51)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(51, 4),  -- #frontend
(51, 9);  -- #performance

-- ToDoItem 52: Enhance Accessibility Features (todo_id = 52)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(52, 4),  -- #frontend
(52, 10); -- #design

-- ToDoItem 53: Create Interactive Charts (todo_id = 53)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(53, 4),  -- #frontend
(53, 2);  -- #feature

-- ToDoItem 54: Optimize CSS for Performance (todo_id = 54)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(54, 4),  -- #frontend
(54, 9);  -- #performance

-- ToDoItem 55: Implement Form Validation (todo_id = 55)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(55, 4),  -- #frontend
(55, 7);  -- #testing

-- ToDoItem 56: Develop Mobile App Integration (todo_id = 56)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(56, 4),  -- #frontend
(56, 2);  -- #feature

-- ToDoItem 57: Create Multi-language Support (todo_id = 57)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(57, 4),  -- #frontend
(57, 10); -- #design

-- ToDoItem 58: Implement Infinite Scrolling (todo_id = 58)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(58, 4),  -- #frontend
(58, 9);  -- #performance

-- ToDoItem 59: Develop Interactive Tutorials (todo_id = 59)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(59, 4),  -- #frontend
(59, 2);  -- #feature

-- ToDoItem 60: Optimize Image Assets (todo_id = 60)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(60, 4),  -- #frontend
(60, 9);  -- #performance

-- ToDoItem 61: Develop Interactive Forms (todo_id = 61)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(61, 4),  -- #frontend
(61, 2);  -- #feature

-- ToDoItem 62: Implement Breadcrumb Navigation (todo_id = 62)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(62, 4),  -- #frontend
(62, 10); -- #design

-- ToDoItem 63: Create Custom Scrollbars (todo_id = 63)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(63, 4),  -- #frontend
(63, 10); -- #design

-- ToDoItem 64: Develop Single Page Application (SPA) (todo_id = 64)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(64, 4),  -- #frontend
(64, 2);  -- #feature

-- ToDoItem 65: Review API Endpoints (todo_id = 65)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(65, 1),  -- #bug
(65, 5);  -- #backend

-- ToDoItem 66: Test Cross-Browser Compatibility (todo_id = 66)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(66, 4),  -- #frontend
(66, 7);  -- #testing

-- ToDoItem 67: Conduct Security Audits (todo_id = 67)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(67, 1),  -- #bug
(67, 5);  -- #backend

-- ToDoItem 68: Perform Usability Testing (todo_id = 68)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(68, 7),  -- #testing
(68, 6);  -- #documentation

-- ToDoItem 69: Set Up Automated Test Suites (todo_id = 69)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(69, 7),  -- #testing
(69, 11); -- #automation

-- ToDoItem 70: Conduct Beta Testing (todo_id = 70)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(70, 7),  -- #testing
(70, 2);  -- #feature

-- ToDoItem 71: Develop Test Plans (todo_id = 71)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(71, 7),  -- #testing
(71, 6);  -- #documentation

-- ToDoItem 72: Integrate Testing Tools (todo_id = 72)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(72, 7),  -- #testing
(72, 11); -- #automation

-- ToDoItem 73: Monitor Bug Reports (todo_id = 73)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(73, 1),  -- #bug
(73, 7);  -- #testing

-- ToDoItem 74: Validate Data Integrity (todo_id = 74)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(74, 7),  -- #testing
(74, 5);  -- #backend

-- ToDoItem 75: Conduct Regression Tests (todo_id = 75)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(75, 7),  -- #testing
(75, 1);  -- #bug

-- ToDoItem 76: Perform Load Testing (todo_id = 76)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(76, 7),  -- #testing
(76, 9);  -- #performance

-- ToDoItem 77: Set Up Continuous Testing (todo_id = 77)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(77, 7),  -- #testing
(77, 11); -- #automation

-- ToDoItem 78: Develop Testing Metrics (todo_id = 78)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(78, 7),  -- #testing
(78, 6);  -- #documentation

-- ToDoItem 79: Implement Smoke Testing (todo_id = 79)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(79, 7),  -- #testing
(79, 1);  -- #bug

-- ToDoItem 80: Create Test Data Sets (todo_id = 80)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(80, 7),  -- #testing
(80, 6);  -- #documentation

-- ToDoItem 81: Review User Stories (todo_id = 81)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(81, 7),  -- #testing
(81, 6);  -- #documentation

-- ToDoItem 82: Conduct Compatibility Testing (todo_id = 82)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(82, 7),  -- #testing
(82, 4);  -- #frontend

-- ToDoItem 83: Perform Accessibility Testing (todo_id = 83)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(83, 7),  -- #testing
(83, 10); -- #design

-- ToDoItem 84: Monitor Testing Coverage (todo_id = 84)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(84, 7),  -- #testing
(84, 9);  -- #performance

-- ToDoItem 85: Conduct API Testing (todo_id = 85)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(85, 5),  -- #backend
(85, 7);  -- #testing

-- ToDoItem 86: Develop Test Automation Framework (todo_id = 86)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(86, 7),  -- #testing
(86, 11); -- #automation

-- ToDoItem 87: Perform Performance Testing (todo_id = 87)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(87, 7),  -- #testing
(87, 9);  -- #performance

-- ToDoItem 88: Coordinate with Development Team (todo_id = 88)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(88, 7),  -- #testing
(88, 2);  -- #feature

-- ToDoItem 89: Update Test Documentation (todo_id = 89)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(89, 6),  -- #documentation
(89, 7);  -- #testing

-- ToDoItem 90: Conduct End-to-End Testing (todo_id = 90)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(90, 7),  -- #testing
(90, 2);  -- #feature

-- ToDoItem 91: Implement Continuous Monitoring (todo_id = 91)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(91, 9),  -- #performance
(91, 7);  -- #testing

-- ToDoItem 92: Perform Data Migration Testing (todo_id = 92)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(92, 7),  -- #testing
(92, 5);  -- #backend

-- ToDoItem 93: Develop Integration Tests (todo_id = 93)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(93, 7),  -- #testing
(93, 2);  -- #feature

-- ToDoItem 94: Conduct Localization Testing (todo_id = 94)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(94, 7),  -- #testing
(94, 10); -- #design

-- ToDoItem 95: Set Up Test Environments (todo_id = 95)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(95, 7),  -- #testing
(95, 6);  -- #documentation

-- ToDoItem 96: Monitor Test Execution (todo_id = 96)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(96, 7),  -- #testing
(96, 9);  -- #performance

-- ToDoItem 97: Develop API Security Tests (todo_id = 97)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(97, 1),  -- #bug
(97, 5);  -- #backend

-- ToDoItem 98: Implement Test Data Anonymization (todo_id = 98)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(98, 7),  -- #testing
(98, 6);  -- #documentation

-- ToDoItem 99: Conduct Stress Testing (todo_id = 99)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(99, 7),  -- #testing
(99, 9);  -- #performance

-- ToDoItem 100: Set Up Continuous Feedback Loop (todo_id = 100)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(100, 7),  -- #testing
(100, 2);  -- #feature

-- ToDoItem 101: Conduct Cross-Functional Testing (todo_id = 101)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(101, 7),  -- #testing
(101, 2);  -- #feature

-- ToDoItem 102: Implement Test Case Management (todo_id = 102)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(102, 7),  -- #testing
(102, 6);  -- #documentation

-- ToDoItem 103: Develop Mobile App Test Plans (todo_id = 103)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(103, 7),  -- #testing
(103, 2);  -- #feature

-- ToDoItem 104: Perform Data Integrity Checks (todo_id = 104)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(104, 7),  -- #testing
(104, 5);  -- #backend

-- ToDoItem 105: Set Up Test Data Generation Scripts (todo_id = 105)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(105, 7),  -- #testing
(105, 11); -- #automation

-- ToDoItem 106: Conduct Recovery Testing (todo_id = 106)
INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(106, 7),  -- #testing
(106, 1);  -- #bug

INSERT INTO ToDoTags (todo_id, tag_id) VALUES
(107, 7),  -- #testing
(107, 11), -- #automation

(108, 7),  -- #testing
(108, 6),  -- #documentation

(109, 7),  -- #testing
(109, 1),  -- #bug

(110, 7),  -- #testing
(110, 6),  -- #documentation

(111, 7),  -- #testing
(111, 11), -- #automation

(112, 7),  -- #testing
(112, 2),  -- #feature

(113, 7),  -- #testing
(113, 6),  -- #documentation

(114, 7),  -- #testing
(114, 9),  -- #performance

(115, 7),  -- #testing
(115, 2),  -- #feature

(116, 7),  -- #testing
(116, 1);  -- #bug

-- ============================================
-- End of Enhanced Database Script
-- ============================================