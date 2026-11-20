FROM debian:stable-slim

ARG TYPST_VERSION=v0.13.1
ARG TARGETARCH

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl xz-utils fontconfig \
      fonts-dejavu fonts-liberation fonts-noto-core fonts-noto-color-emoji \
      make entr nano vim git zip \
 && case "${TARGETARCH:-amd64}" in \
      amd64) T=x86_64-unknown-linux-musl ;; \
      arm64) T=aarch64-unknown-linux-musl ;; \
      *) echo "arch non supportée"; exit 1 ;; \
    esac \
 && curl -fsSL "https://github.com/typst/typst/releases/download/${TYPST_VERSION}/typst-${T}.tar.xz" \
    | tar -xJ --strip-components=1 -C /usr/local/bin "typst-${T}/typst" \
 && apt-get purge -y curl xz-utils && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

ENV TYPST_FONT_PATHS=/workspace/fonts
WORKDIR /workspace
CMD ["bash"]
