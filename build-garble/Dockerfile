FROM golang:1.25-bookworm

WORKDIR /src
COPY . .
RUN ls -al /src

RUN chmod +x ./build-garble/entrypoint.sh

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* && go install mvdan.cc/garble@latest

ENV GARBLE_SEED="" \
    GIT_TOKEN="" \
    TARGET_BRANCH="master" \
    APP_FAMILY="pe"

ENTRYPOINT ["/src/build-garble/entrypoint.sh"]