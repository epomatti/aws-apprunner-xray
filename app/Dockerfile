# syntax=docker/dockerfile:1

### Builder ###
FROM eclipse-temurin:21-jdk-jammy as builder
WORKDIR /opt/app
COPY . .
RUN ./mvnw dependency:go-offline -Dhttps.protocols=TLSv1.2
RUN ./mvnw clean install

### Runtime ###
FROM eclipse-temurin:21-jre-jammy
WORKDIR /opt/app
COPY --from=builder /opt/app/target/*.jar /opt/app/*.jar

# AWS X-Ray
ADD https://github.com/aws-observability/aws-otel-java-instrumentation/releases/latest/download/aws-opentelemetry-agent.jar /opt/aws-opentelemetry-agent.jar
ENV JAVA_TOOL_OPTIONS=-javaagent:/opt/aws-opentelemetry-agent.jar
ENV OTEL_PROPAGATORS=xray
ENV OTEL_TRACES_SAMPLER=xray
ENV OTEL_METRICS_EXPORTER=none
ENV OTEL_SERVICE_NAME=MyApp
# ENV OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317

EXPOSE 8080

# https://docs.aws.amazon.com/xray/latest/devguide/xray-sdk-java-configuration.html#xray-sdk-java-configuration-sampling
# ENTRYPOINT ["java", "-Dotel.javaagent.debug=true", "-jar","*.jar"]
ENTRYPOINT ["java", "-Dlogging.level.com.amazonaws.xray=DEBUG", "-Dotel.javaagent.debug=true", "-jar","*.jar"]
# ENTRYPOINT ["java", "-jar","*.jar"]