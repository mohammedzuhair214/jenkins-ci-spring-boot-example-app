FROM openjdk:17-jdk-alpine
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} spring-data-jpa-mysql-1.0.jar
ENTRYPOINT ["java","-jar","/spring-data-jpa-mysql-1.0.jar"]
