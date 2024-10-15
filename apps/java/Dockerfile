# syntax=docker/dockerfile:1

### Builder ###
FROM eclipse-temurin:21-jdk-jammy AS builder

ENV OBSERVABILITY_ENABLED="1"
ENV XRAY_LOGGING_LEVEL="INFO"
ENV OTEL_JAVAAGENT_DEBUG="false"

WORKDIR /opt/app
COPY . .
RUN ./mvnw dependency:go-offline -Dhttps.protocols=TLSv1.2
RUN ./mvnw clean install

### Runtime ###
FROM eclipse-temurin:21-jre-jammy
WORKDIR /opt/app
COPY --from=builder /opt/app/target/*.jar /opt/app/*.jar

# THIS + execute permissions
COPY --from=builder /opt/app/entrypoint.sh /opt/app/entrypoint.sh

# AWS X-Ray
ADD https://github.com/aws-observability/aws-otel-java-instrumentation/releases/latest/download/aws-opentelemetry-agent.jar /opt/aws-opentelemetry-agent.jar

EXPOSE 8080
ENTRYPOINT ["./entrypoint.sh"]
