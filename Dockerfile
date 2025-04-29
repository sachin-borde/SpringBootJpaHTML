# Use a lightweight JDK image
FROM openjdk:17-jdk-alpine

# Copy the Spring Boot fat JAR
COPY target/*.jar app.jar

# Expose default port
EXPOSE 8080

# Launch the application
ENTRYPOINT ["java","-jar","/app.jar"]
