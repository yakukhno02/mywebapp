FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /app
COPY . .
RUN ./mvnw clean package -DskipTests

FROM eclipse-temurin:21-jre

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    postgresql-client=18* && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /app/target/*.jar app.jar

COPY migrate_db.sh .
RUN chmod +x migrate_db.sh

EXPOSE 5000

CMD ["sh", "-c", "sleep 10 && ./migrate_db.sh && java -jar app.jar"]
