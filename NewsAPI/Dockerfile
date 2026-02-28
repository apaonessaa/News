FROM maven:3.9.6-eclipse-temurin-21-jammy

# Create a group and non-root user
RUN addgroup --gid 1234 spring && adduser --gid 1234 --uid 1234 --home /home/spring --disabled-password spring

# Create a directory for the images and configurations
RUN mkdir -p /home/spring/images
ENV IMAGE_PATH=/home/spring/images/
RUN mkdir -p /home/spring/config && chown -R spring:spring /home/spring/
ENV IMAGE_CONFIG_PATH=/home/spring/config/validator.json

# Change user
USER spring:spring

WORKDIR /home/spring

# Copy the JAR file
COPY ./news-0.0.1-SNAPSHOT.jar ./app.jar
COPY ./validator.json ./config/validator.json

# Expose the server port
EXPOSE 8000

# Entry point
ENTRYPOINT ["java", "-jar", "/home/spring/app.jar"]
