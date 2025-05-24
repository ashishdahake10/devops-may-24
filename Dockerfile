# ====== Stage 1: Build React frontend ======
FROM node:18 
WORKDIR /app
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# ====== Stage 2: Build Java backend ======
FROM eclipse-temurin:17-jdk 
WORKDIR /app
COPY backend/ ./
RUN ./mvnw clean package

# ====== Stage 3: Image ======
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY --from=backend-build /app/target/*.jar app.jar
COPY --from=frontend-build /app/build /app/public
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

