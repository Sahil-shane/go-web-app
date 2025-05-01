# First stage: Build the Go app
FROM golang:1.22.5 AS builder

WORKDIR /app

# Copy go.mod and download dependencies first (for caching)
COPY go.mod .
RUN go mod download

# Copy the rest of the code
COPY . .

# Build the Go binary for Linux architecture
RUN GOOS=linux GOARCH=amd64 go build -o main .

# Final stage: Distroless image (secure and minimal)
FROM gcr.io/distroless/base

WORKDIR /app

COPY --from=builder /app/main .
COPY --from=builder /app/static ./static

EXPOSE 8080

CMD ["./main"]


