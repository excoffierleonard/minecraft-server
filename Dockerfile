# Global ARGs (must be before FROM to use in base image)
ARG JAVA_VERSION=21

# Build stage - download the server jar
FROM alpine:latest AS downloader

ARG MC_VERSION

RUN apk add --no-cache curl jq

WORKDIR /download

RUN LOADER=$(curl -s "https://meta.fabricmc.net/v2/versions/loader/${MC_VERSION}" | jq -r '.[0].loader.version') && \
    INSTALLER=$(curl -s "https://meta.fabricmc.net/v2/versions/installer" | jq -r '.[0].version') && \
    curl -o server.jar -L "https://meta.fabricmc.net/v2/versions/loader/${MC_VERSION}/${LOADER}/${INSTALLER}/server/jar"

# Final stage - minimal runtime image
FROM eclipse-temurin:${JAVA_VERSION}-jre

ENV JAVA_XMS=1G
ENV JAVA_XMX=1G

COPY --from=downloader /download/server.jar /app/server.jar

WORKDIR /data

CMD exec java -Xms${JAVA_XMS} -Xmx${JAVA_XMX} -jar /app/server.jar nogui