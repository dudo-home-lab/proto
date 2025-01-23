# Fetch the Protobuf compiler
FROM ubuntu:22.04 AS protoc

ARG PROTOC_VERSION=29.1

RUN apt-get update && apt-get install -y --no-install-recommends curl unzip ca-certificates

RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-aarch_64.zip \
    && unzip protoc-${PROTOC_VERSION}-linux-aarch_64.zip -d /usr/local

# Install the Go Protobuf plugin
FROM golang:1.23 AS go

ENV GOPATH=/root/go

RUN go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
RUN go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Install the JavaScript Protobuf plugin
FROM node:22 AS js

# RUN npm install -g TODO

# Final minimal image with scratch
FROM scratch

# Copy protoc
COPY --from=protoc /usr/local/bin/protoc /usr/local/bin/protoc
COPY --from=protoc /usr/local/include /usr/local/include

# Copy Go plugins
COPY --from=go /root/go/bin/protoc-gen-go /usr/local/bin/protoc-gen-go
COPY --from=go /root/go/bin/protoc-gen-go-grpc /usr/local/bin/protoc-gen-go-grpc

# Copy JavaScript plugins
# COPY --from=js /usr/local/bin/protoc-gen-js /usr/local/bin/protoc-gen-js

ENV PATH="/usr/local/bin:${PATH}"

WORKDIR /usr/src/app

ENTRYPOINT ["protoc"]
