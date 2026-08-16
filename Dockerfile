# syntax=docker/dockerfile:1

FROM maven:3.9-eclipse-temurin-25 AS build
WORKDIR /workspace

# Copy the POM first so dependency resolution is cached between source changes.
COPY pom.xml ./
RUN mvn --batch-mode --update-snapshots dependency:go-offline

COPY src ./src
RUN mvn --batch-mode --update-snapshots clean package -DskipTests \
    && cp target/*.jar /tmp/app.jar

FROM eclipse-temurin:25-jre
WORKDIR /app

RUN groupadd --system spring && useradd --system --gid spring spring
COPY --from=build /tmp/app.jar app.jar

USER spring
EXPOSE 9088

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
