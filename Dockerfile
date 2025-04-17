#-- build web server
FROM golang:1.16-buster as server_builder
WORKDIR /builder
COPY server .
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o fileServer \
    && mkdir keys \
    && openssl req -x509 -sha256 -newkey rsa:2048 -keyout ./keys/certificate.key -out ./keys/certificate.crt -days 1024 -nodes -subj '/CN=itential.io'

#-- build trial-workspace SPA
FROM node:20-buster-slim as react_builder

# These values are required at build time
ARG VITE_KEYCLOAK_URL
ARG VITE_KEYCLOAK_CLIENT_ID
ARG VITE_TOKEN_EXCHANGE_AUDIENCE_CUSTOMER_CONTROL
ARG VITE_HUB_URL
ARG VITE_CUSTOMER_CONTROL_URL
ARG VITE_TRIAL_DATASET_NUMBER
ARG VITE_FEATURE_TRAINING_URL
ARG VITE_ARC_API_GATEWAY_URL
ARG VITE_IAP_MODELER_URL
ARG VITE_GILAB_MODULAR_URL

# these are exposed after the container starts up
ENV VITE_KEYCLOAK_URL=$VITE_KEYCLOAK_URL
ENV VITE_KEYCLOAK_CLIENT_ID=$VITE_KEYCLOAK_CLIENT_ID
ENV VITE_TOKEN_EXCHANGE_AUDIENCE_CUSTOMER_CONTROL=$VITE_TOKEN_EXCHANGE_AUDIENCE_CUSTOMER_CONTROL
ENV VITE_HUB_URL=$VITE_HUB_URL
ENV VITE_CUSTOMER_CONTROL_URL=$VITE_CUSTOMER_CONTROL_URL
ENV VITE_TRIAL_DATASET_NUMBER=$VITE_TRIAL_DATASET_NUMBER
ENV VITE_FEATURE_TRAINING_URL=$VITE_FEATURE_TRAINING_URL
ENV VITE_ARC_API_GATEWAY_URL=$VITE_ARC_API_GATEWAY_URL
ENV VITE_IAP_MODELER_URL=$VITE_IAP_MODELER_URL
ENV VITE_GILAB_MODULAR_URL=$VITE_GILAB_MODULAR_URL

WORKDIR /builder
COPY . .
SHELL ["/bin/bash", "-c"]
RUN echo node_version \
    && node --version \
    # && npm install --location=global npm@latest \
    && echo npm_version \
    && npm --version \
    && cp ./.npmrc ./secrets \
    && npm ci \
    && npm run build

#-- serve the SPA with the web server
FROM alpine:latest
ARG ORIGIN
ENV ORIGIN=$ORIGIN
WORKDIR /trial-workspace
RUN apk upgrade --no-cache
COPY --from=server_builder /builder/fileServer ./server/fileServer
COPY --from=server_builder /builder/keys ./keys
COPY --from=react_builder /builder/dist ./dist
CMD ["./server/fileServer"]

# Uncomment for debugging
#CMD ["tail", "-f", "/dev/null"]
