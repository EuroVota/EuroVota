FROM  amazoncorretto:17.0.11-al2023-headless

WORKDIR /app

COPY /build/libs/users-0.0.1-SNAPSHOT.jar .

EXPOSE 9000

CMD ["java", "-jar", "users-0.0.1-SNAPSHOT.jar"]
