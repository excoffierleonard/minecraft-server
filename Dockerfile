# Build stage - download the server jar
FROM alpine:latest AS downloader

ARG MC_VERSION

RUN apk add --no-cache curl jq

WORKDIR /download

RUN LOADER=$(curl -s "https://meta.fabricmc.net/v2/versions/loader/${MC_VERSION}" | jq -r '.[0].loader.version') && \
    INSTALLER=$(curl -s "https://meta.fabricmc.net/v2/versions/installer" | jq -r '.[0].version') && \
    curl -o server.jar -L "https://meta.fabricmc.net/v2/versions/loader/${MC_VERSION}/${LOADER}/${INSTALLER}/server/jar"

# Final stage - minimal runtime image
FROM eclipse-temurin:21-jre

WORKDIR /data

COPY --from=downloader /download/server.jar .

CMD ["java", "-jar", "server.jar", "nogui"]