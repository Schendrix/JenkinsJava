# Stage 1: Build the JAR
FROM maven:3.9.3-eclipse-temurin-20 AS build

# Set working directory
WORKDIR /app

# Copy Maven files and source code
COPY pom.xml .
COPY Java_App/ ./Java_App/

# Package the application
RUN mvn clean package -DskipTests

# Stage 2: Run the JAR
FROM eclipse-temurin:20-jre

WORKDIR /app

# Copy the JAR from the build stage
COPY --from=build /app/target/simple-web-app-1.0.0.jar app.jar

# Expose port
EXPOSE 8080

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]
