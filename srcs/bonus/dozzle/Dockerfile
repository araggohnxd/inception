FROM debian:buster

# Set Go's environment variables:
# - GOROOT: where Go binary will be placed
# - GOPATH: where Go will store its packages and cache
# - PATH: update PATH so it can find Go's binary in its given directory
ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

# Install packages:
# - curl: used to update apt-get to download NodeJS latest release
RUN apt-get update && \
    apt-get install -y curl

# Curl the setup script from Node Source and install more packages:
# - wget: used to download Go's latest version tarball
# - tar: used to unzip Go's latest version tarball
# - git: used to clone Dozzle's official repository
# - nodejs: used to build Dozzle, since it uses pnpm
# - make: used to build Dozzle, since it uses make to build some dependencies
# - ca-certificates: used by Dozzle to create digital certificate
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y wget tar git nodejs make ca-certificates

# Install Go programming language from source, since the apt-get version
# is older than the one required by Dozzle
RUN wget https://go.dev/dl/go1.20.3.linux-amd64.tar.gz && \
    tar xvf go1.20.3.linux-amd64.tar.gz && \
    mv ./go /usr/local/go && \
    rm go1.20.3.linux-amd64.tar.gz

# Create Go's directory
RUN mkdir -p $GOPATH

# Install reflex, a Go tool used by Dozzle to monitor file updates
RUN go install github.com/cespare/reflex@latest

# Install pnpm globally, Dozzle uses it as package manager
RUN npm install -g pnpm

# Enable Corepack, Dozzle uses it to manage dependencies versioning
RUN corepack enable

# Clone Dozzle's official repository
RUN git clone https://github.com/amir20/dozzle.git

# Change the working directory to the cloned repository
WORKDIR /dozzle

# Build Dozzle's web application
RUN pnpm fetch --ignore-scripts --no-optional && \
    pnpm install --ignore-scripts --no-optional && \
    pnpm build

# Build Dozzle's binary
RUN go mod download && \
    go build -o dozzle

# Expose port 8080 for communication with the web and other containers
EXPOSE 8080

# Run dozzle
ENTRYPOINT ["/dozzle/dozzle"]
