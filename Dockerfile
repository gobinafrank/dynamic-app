# Multi-stage build
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Final image
FROM tomcat:10-jdk21-temurin
LABEL maintainer="example@example.com"

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file to Tomcat webapps directory
COPY --from=build /app/target/java-webapp-devops.war /usr/local/tomcat/webapps/ROOT.war

# Create a directory for logs
RUN mkdir -p /usr/local/tomcat/logs

# Set environment variables
ENV CATALINA_OPTS="-Xms512m -Xmx1024m"

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
