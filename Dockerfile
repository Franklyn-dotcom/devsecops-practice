FROM adoptopenjdk/openjdk8:alpine-slim
EXPOSE 8080
ARG JAR_FILE=target/numeric-0.0.1.jar
RUN ls target/
ADD ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
