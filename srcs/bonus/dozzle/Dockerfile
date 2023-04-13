FROM debian:buster

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

RUN apt-get update && \
    apt-get install -y curl

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install -y wget tar git nodejs make ca-certificates

RUN wget https://go.dev/dl/go1.20.3.linux-amd64.tar.gz && \
    tar xvf go1.20.3.linux-amd64.tar.gz && \
    mv ./go /usr/local/go && \
    rm go1.20.3.linux-amd64.tar.gz

RUN mkdir -p $GOPATH

RUN go install github.com/cespare/reflex@latest

RUN npm install -g pnpm

RUN corepack enable

RUN git clone https://github.com/amir20/dozzle.git

WORKDIR /dozzle

RUN pnpm fetch --ignore-scripts --no-optional && \
    pnpm install --ignore-scripts --no-optional && \
    pnpm build

RUN go mod download && \
    go build -o dozzle

EXPOSE 8080

ENTRYPOINT ["/dozzle/dozzle"]
