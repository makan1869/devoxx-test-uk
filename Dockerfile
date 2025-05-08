FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Add application health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=15s --retries=3 \
  CMD wget -q --spider http://localhost:8080/actuator/health || exit 1

# Create a non-root user to run the application
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copy the executable JAR
COPY --chown=spring:spring target/*.jar app.jar

# Set the entrypoint to run the JAR
ENTRYPOINT ["java", "-jar", "app.jar"]

# Document that the container listens on port 8080
EXPOSE 8080
