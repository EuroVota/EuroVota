FROM  amazoncorretto:17.0.11-al2023-headless

WORKDIR /app

COPY /build/libs/votes-0.0.1-SNAPSHOT.jar .

WORKDIR /app/votes

COPY .env .

WORKDIR /app

EXPOSE 9002

CMD ["java", "-jar", "votes-0.0.1-SNAPSHOT.jar"]
