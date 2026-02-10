FROM maven:3.9.6-eclipse-temurin-21-jammy
COPY ./src/main/resources/backend.env backend.env
COPY ./NewsAPI-0.0.1.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java","-jar","/app.jar"]
