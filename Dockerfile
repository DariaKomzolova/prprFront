FROM ubuntu:22.04 AS builder

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    curl git unzip xz-utils zip libglu1-mesa ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/flutter
WORKDIR /opt/flutter
RUN curl -L \
    https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.32.4-stable.tar.xz \
  -o flutter.tar.xz \
 && tar xf flutter.tar.xz --strip-components=1 \
 && rm flutter.tar.xz

RUN git config --global --add safe.directory /opt/flutter

ENV PATH="/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter precache --disable-analytics

WORKDIR /app

COPY pubspec.* ./
RUN flutter pub get

COPY . .
RUN flutter build web --release


FROM python:3.11-slim
WORKDIR /app

RUN apt-get update \
 && apt-get install -y --no-install-recommends lsof psmisc \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/build/web ./build/web
COPY server/server.sh ./server.sh

RUN chmod +x server.sh

EXPOSE 9000
CMD ["./server.sh"]