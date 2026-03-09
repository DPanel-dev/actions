FROM alpine:latest AS unpacker
RUN apk add --no-cache tar xz bzip2 bash binutils
WORKDIR /opt
COPY artifacts/ /tmp/artifacts/

RUN /bin/bash -o pipefail -e -c ' \
    for pkg in /tmp/artifacts/*; do \
        filename=$(basename "$pkg"); \
        if [[ "$filename" == *.tar.bz2 || "$filename" == *.txz ]]; then \
            DIR=$(echo "$filename" | sed -E "s/\.(tar\.bz2|txz)$//"); \
            mkdir -p "toolchains/$DIR"; \
            [[ "$filename" == *.bz2 ]] && OPT="-j" || OPT="-J"; \
            tar ${OPT}xf "$pkg" -C "toolchains/$DIR" --strip-components=1; \
            rm -rf "toolchains/$DIR"/{share,doc,man,info}; \
            find "toolchains/$DIR/bin" "toolchains/$DIR/libexec" -type f -executable -exec strip --strip-unneeded {} + 2>/dev/null || true; \
        else \
            mkdir -p tools; cp "$pkg" "tools/$filename"; chmod +x "tools/$filename"; \
        fi \
    done'

FROM scratch
COPY --from=unpacker /opt/ /