# Build stage
FROM rust:1.82-alpine AS builder

# Install build dependencies
RUN apk add --no-cache musl-dev

# Set working directory
WORKDIR /app

# Copy Cargo files
COPY Cargo.toml Cargo.lock ./

# Copy source code
COPY src ./src

# Build the application
RUN cargo build --release

# Runtime stage
FROM alpine:latest

# Install CA certificates for HTTPS requests
RUN apk --no-cache add ca-certificates

# Create app user
RUN addgroup -g 1001 -S appgroup && \
    adduser -S appuser -u 1001 -G appgroup

# Set working directory
WORKDIR /app

# Copy the binary from builder stage
COPY --from=builder /app/target/release/hello-world-rust /app/

# Change ownership to app user
RUN chown -R appuser:appgroup /app
USER appuser

# Expose port
EXPOSE 3000

# Set environment
ENV PORT=3000

# Run the application
CMD ["./hello-world-rust"]