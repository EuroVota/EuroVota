FROM  amazoncorretto:17.0.11-al2023-headless

WORKDIR /app

COPY users-0.0.1-SNAPSHOT.jar .

WORKDIR /app/users

COPY .env .

WORKDIR /app

EXPOSE 8080

CMD ["java", "-jar", "users-0.0.1-SNAPSHOT.jar"]
