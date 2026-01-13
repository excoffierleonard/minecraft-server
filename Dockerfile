# Build stage - download the server jar
FROM alpine:latest AS downloader

ARG MC_VERSION
ARG LOADER_VERSION=0.18.4
ARG INSTALLER_VERSION=1.1.1

RUN apk add --no-cache curl

WORKDIR /download

RUN curl -o server.jar -L "https://meta.fabricmc.net/v2/versions/loader/${MC_VERSION}/${LOADER_VERSION}/${INSTALLER_VERSION}/server/jar"

# Final stage - minimal runtime image
FROM eclipse-temurin:21-jre

WORKDIR /data

COPY --from=downloader /download/server.jar .

CMD ["java", "-jar", "server.jar", "nogui"]