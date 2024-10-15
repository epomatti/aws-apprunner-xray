#!/bin/bash
echo "Starting docker entrypoint..."

echo "Value for variable \"OBSERVABILITY_ENABLED\": $OBSERVABILITY_ENABLED"
echo "Value for variable \"XRAY_LOGGING_LEVEL\": $XRAY_LOGGING_LEVEL"
echo "Value for variable \"OTEL_JAVAAGENT_DEBUG\": $OTEL_JAVAAGENT_DEBUG"

if [ "$OBSERVABILITY_ENABLED" = "1" ] || [ "$OBSERVABILITY_ENABLED" = "TRUE" ] || [ "$OBSERVABILITY_ENABLED" = "true" ]; then
  echo "Observability enabled. Initializing the application with AWS X-Ray and OpenTelemetry".

  export JAVA_TOOL_OPTIONS=-javaagent:/opt/aws-opentelemetry-agent.jar
  export OTEL_PROPAGATORS=xray
  export OTEL_TRACES_SAMPLER=xray
  export OTEL_METRICS_EXPORTER=none
  export OTEL_SERVICE_NAME=MyApp

  # Troubleshooting references:
  # - https://docs.aws.amazon.com/xray/latest/devguide/xray-sdk-java-configuration.html#xray-sdk-java-configuration-logging
  # - https://github.com/open-telemetry/opentelemetry-java-instrumentation?tab=readme-ov-file#troubleshooting
  java -Dlogging.level.com.amazonaws.xray=$XRAY_LOGGING_LEVEL -Dotel.javaagent.debug=$OTEL_JAVAAGENT_DEBUG -jar "*.jar"
else
  echo "Observability disabled. Initializing the application only without telemetry".
  java -jar "*.jar"
fi
