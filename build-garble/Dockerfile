FROM golang:1.25-bookworm

COPY . /src
WORKDIR /src

RUN ls -al /src

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* && go install mvdan.cc/garble@latest

ENV GARBLE_SEED="" \
    GIT_TOKEN="" \
    TARGET_BRANCH="master" \
    APP_FAMILY="pe"

RUN chmod +x /src/build-garble/entrypoint.sh

ENTRYPOINT ["/src/build-garble/entrypoint.sh"]