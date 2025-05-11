# Java Web Application - DevOps Sample

This is a sample Java web application designed to demonstrate a complete DevOps pipeline using GitHub, Jenkins, Maven, and Docker with Tomcat.

## Project Structure

- Java Servlets and JSP for the web application
- Maven for dependency management and build
- JUnit and Mockito for testing
- Log4j for logging
- HikariCP for database connection pooling
- Docker for containerization
- Jenkins pipeline for CI/CD

## Prerequisites

- JDK 21
- Maven 3.9.9
- Docker
- Jenkins with necessary plugins (Docker Pipeline, etc.)
- Git

## Local Development

### Building the Application

```bash
mvn clean package
