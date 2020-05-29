FROM us.icr.io/cdt-common-rns/base-images/ubi7-ibmjre:latest
ARG version=1

# Labels from https://github.com/opencontainers/image-spec/blob/master/annotations.md#pre-defined-annotation-keys (with additions prefixed ext)
LABEL org.opencontainers.image.vendor = "IBM" \
      org.opencontainers.image.title = "Avro Random Generator" \
      org.opencontainers.image.description = "Generator of randomized Avro records." \
      org.opencontainers.image.url = "https://ibm.com/" \
      org.opencontainers.image.source = "TBD" \
      org.opencontainers.image.authors = "IBM" \
      org.opencontainers.image.revision = "1" \
      org.opencontainers.image.licenses = "Apache-2.0" \
      org.opencontainers.image.created = "$BUILD_TIME" \
      org.opencontainers.image.version = "$version" \
      org.opencontainers.image.documentation = "TBD" \
      org.opencontainers.image.ext.docker.cmd = "docker run -d -p 8080:8080 odpi/egeria" \
      org.opencontainers.image.ext.docker.cmd.devel = "docker run -ti --rm -v /path/to/schema:/opt/ibm/arg/input arg:v1" \
      org.opencontainers.image.ext.docker.debug = "docker exec -it $CONTAINER /bin/sh"

RUN groupadd -r arg -g 8080 && \
    useradd --no-log-init -r -g arg -u 8080 -m -d /opt/ibm/arg arg

COPY --chown=arg:arg docker-entrypoint.sh /entrypoint.sh
COPY --chown=arg:arg bin/arg.jar /opt/ibm/arg/arg.jar


# Expose port 8080 (default) for client access, and allow for 5005 being used for remote java debug
# EXPOSE 8080 5005

WORKDIR /opt/ibm/arg
USER arg:arg

# Spring loader path for connectors etc
# ENV LOADER_PATH=/opt/ibm/arg/server/lib

# Launch server chassis by default
# CMD ["java", "-jar",  "/opt/egeria/server/server-chassis-spring-${version}.jar"]

ENTRYPOINT ["/entrypoint.sh"]
