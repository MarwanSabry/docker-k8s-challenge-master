####### Builder Stage #######
FROM golang:1.23 AS builder
# Install dependencies
RUN apt update && apt install git -y
# Create and set the working directory
WORKDIR /app
# Copy the application code & dependencies
COPY app/ /app
# Get Go dependencies
RUN go mod tidy
# Build the Go application
RUN go build -o myapp ./main.go

####### Runtime Stage #######
FROM ubuntu:latest
# Set working directory in the runtime image
WORKDIR /app
# Copy from the builder stage
COPY --from=builder /app/ /app/
# Expose the app port
EXPOSE 80
# Run the Go application
#CMD ["/bin/myapp"] #This isnot the right path the right path is "/app/myapp" that i just created and copy app content to it
CMD ["/app/myapp"]