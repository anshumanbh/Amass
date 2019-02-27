FROM golang:alpine as build
RUN apk add --no-cache --upgrade git openssh-client ca-certificates
RUN go get -u github.com/golang/dep/cmd/dep
WORKDIR /go/src/app

# Cache the dependencies early
COPY Gopkg.toml Gopkg.lock ./
RUN dep ensure -vendor-only -v

# Install
RUN go get -u github.com/OWASP/Amass/...
COPY wordlists/ wordlists/
COPY include-data-sources.txt .
COPY exclude-data-sources.txt .

ENTRYPOINT ["amass"]
