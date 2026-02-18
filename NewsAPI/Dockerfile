FROM maven:3.9.6-eclipse-temurin-21-jammy

# Create a group and non-root user
RUN addgroup --gid 1234 spring && adduser --gid 1234 --uid 1234 --home /home/spring --disabled-password spring

# Create a directory for the images
RUN mkdir -p /home/spring/images && chown -R spring:spring /home/spring
ENV IMAGE_STORAGE_PATH=/home/spring/images/

# Change user
USER spring:spring

WORKDIR /home/spring

# Copy the JAR file
COPY ./news-0.0.1-SNAPSHOT.jar ./app.jar

# Expose the server port
EXPOSE 8081

# Entry point
ENTRYPOINT ["java", "-jar", "/home/spring/app.jar"]
