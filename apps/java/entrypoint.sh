#!/bin/bash

echo "Variable OBSERVABILITY_ENABLED: $OBSERVABILITY_ENABLED"

if [ "$OBSERVABILITY_ENABLED" = "1" ] || [ "$OBSERVABILITY_ENABLED" = "TRUE" ] || [ "$OBSERVABILITY_ENABLED" = "true" ]; then
  echo "Observability enabled. Initializing the application with AWS X-Ray and OpenTelemetry".

  export JAVA_TOOL_OPTIONS=-javaagent:/opt/aws-opentelemetry-agent.jar
  export OTEL_PROPAGATORS=xray
  export OTEL_TRACES_SAMPLER=xray
  export OTEL_METRICS_EXPORTER=none
  export OTEL_SERVICE_NAME=MyApp

  # java -Dlogging.level.com.amazonaws.xray=DEBUG -Dotel.javaagent.debug=true -jar "*.jar"
  java -Dotel.javaagent.debug=true -jar "*.jar"
else
   echo "Observability disabled. Initializing the application only without telemetry".
   java -jar "*.jar"
fi
