# Build
FROM golang:1.25-alpine AS build
WORKDIR /src
RUN apk add --no-cache git ca-certificates && update-ca-certificates
COPY go.mod go.sum ./
RUN go mod download && go mod verify
COPY . .
ENV CGO_ENABLED=0 GOOS=linux
RUN go build -o /out/main .

# Runtime (distroless ou scratch)
FROM gcr.io/distroless/static:nonroot
WORKDIR /app
COPY --from=build /out/main /app/main
USER nonroot:nonroot
EXPOSE 80
ENTRYPOINT ["/app/main"]
