FROM golang:1.25-alpine

RUN apk add --no-cache git gcc musl-dev linux-headers ca-certificates

RUN go install mvdan.cc/garble@latest

WORKDIR /src

CMD ["/bin/sh"]