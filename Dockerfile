# Use the offical Go image to create a build artifact.
# This is based on Debian and sets the GOPATH to /go.
# https://hub.docker.com/_/golang
FROM golang:1.22.2
# Specifies a parent image
 
# Creates an app directory to hold your app’s source code
WORKDIR /app
 
# Copies everything from your root directory into /app
COPY . .
 
# Installs Go dependencies
RUN go mod vendor
 
# Builds your app with optional configuration
RUN go build .
 
# Tells Docker which network port your container listens on
EXPOSE 15432
 
# Specifies the executable command that runs when the container starts
CMD [ “/godocker” ]