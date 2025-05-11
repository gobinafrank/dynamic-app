# Single-stage Dockerfile that uses pre-built WAR file
FROM tomcat:11.0.6-jdk21-temurin-noble
LABEL maintainer="example@example.com"

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the pre-built WAR file (this assumes the WAR file is in the build context)
COPY app.war /usr/local/tomcat/webapps/ROOT.war

# Create a directory for logs
RUN mkdir -p /usr/local/tomcat/logs

# Set environment variables
ENV CATALINA_OPTS="-Xms512m -Xmx1024m"

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
