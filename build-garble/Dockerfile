FROM golang:1.25-alpine

RUN apk add --no-cache git gcc musl-dev linux-headers ca-certificates

RUN go install mvdan.cc/garble@latest

WORKDIR /src

# ==========================================
ENV GARBLE_SEED="" \
    GIT_TOKEN="" 

ENV TARGET_BRANCH="master" \
    APP_FAMILY="pe"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]