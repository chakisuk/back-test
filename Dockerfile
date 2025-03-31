FROM openjdk:17-jdk-slim
VOLUME /tmp
EXPOSE 8080
ARG JAR_FILE=./build/libs/farmdora-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} farmdora-BE.jar
ENTRYPOINT ["java", "-jar", "farmdora-BE.jar"]