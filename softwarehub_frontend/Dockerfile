# Estágio 1: Build
FROM debian:latest AS build-env

RUN apt-get update && apt-get install -y curl git unzip

# Instala o Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

RUN flutter doctor
RUN flutter config --enable-web

# Copia os arquivos e faz o build
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release

# Estágio 2: Serve com Nginx
FROM nginx:alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]