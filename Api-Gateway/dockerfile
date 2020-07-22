FROM openjdk:8-jdk-alpine
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} apigateway.jar
ENTRYPOINT ["java","-jar","/apigateway.jar"]