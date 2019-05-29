FROM maven:3-jdk-11 as BUILD

COPY . /usr/src/app
RUN mvn --batch-mode -f /usr/src/app/pom.xml clean package

FROM openjdk:11-jre-slim
ENV PORT 4567
EXPOSE 4567
COPY --from=BUILD /usr/src/app/target /opt/target
WORKDIR /opt/target

HEALTHCHECK --interval=30s \
            --timeout=30s \
            --start-period=5s \
            --retries=3 \
            CMD curl -f http://127.0.0.1:8080 || exit 1

CMD ["/bin/bash", "-c", "find -type f -name '*-with-dependencies.jar' | xargs java -jar"]
