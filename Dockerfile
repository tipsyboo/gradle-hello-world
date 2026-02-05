FROM eclipse-temurin:17-jdk AS builder
WORKDIR /app

COPY gradlew .
COPY gradle gradle
COPY build.gradle.kts .

COPY src src

RUN ./gradlew shadowJar --no-daemon

FROM eclipse-temurin:25-jre-alpine
WORKDIR /app

RUN adduser -D app
USER app

COPY --from=builder --chown=app:app /app/build/libs/*-all.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
