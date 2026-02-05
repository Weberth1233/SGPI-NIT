# ====== STAGE 1: BUILD ======
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copia primeiro o pom pra aproveitar cache
COPY pom.xml .
RUN mvn -B -q dependency:go-offline

# Copia o resto do projeto e compila
COPY src ./src
RUN mvn -B clean package -DskipTests

# ====== STAGE 2: RUNTIME ======
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copia o jar gerado
COPY --from=build /app/target/NIT-SRPI-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8081
ENTRYPOINT ["java","-jar","app.jar"]
