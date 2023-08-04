FROM adoptopenjdk/openjdk8:alpine-slim
EXPOSE 8080
ARG JAR_FILE=target/numeric-0.0.1.jar
RUN addgroup -S pipeline && adduser -S opa-pipeline -G pipeline
COPY ${JAR_FILE} /home/opa-pipeline/app.jar
USER opa-pipeline
ENTRYPOINT ["java","-jar","/home/opa-pipeline/app.jar"]
