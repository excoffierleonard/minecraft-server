# Build stage - download the server jar
FROM alpine:latest AS downloader

RUN apk add --no-cache curl

WORKDIR /download

RUN curl -o server.jar -L https://meta.fabricmc.net/v2/versions/loader/1.21.11/0.18.4/1.1.1/server/jar

# Final stage - minimal runtime image
FROM eclipse-temurin:21-jre

WORKDIR /data

COPY --from=downloader /download/server.jar .

CMD ["java", "-jar", "server.jar", "nogui"]