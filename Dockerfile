FROM alpine:3.19 as stage

ARG BRANCH
ARG VERSION

RUN apk add --no-cache \
    curl \
    xz
RUN mkdir -p /opt/Sonarr
RUN if [ "${BRANCH}" = "main" ]; then \
      curl -o /tmp/sonarr.tar.gz -sL "https://download.sonarr.tv/v4/${BRANCH}/${VERSION}/Sonarr.${BRANCH}.${VERSION}.linux-musl-x64.tar.gz"; \
    elif [ "${BRANCH}" = "develop" ]; then \
      curl -o /tmp/sonarr.tar.gz -sL "https://github.com/Sonarr/Sonarr/releases/download/v${VERSION}/Sonarr.${BRANCH}.${VERSION}.linux-musl-x64.tar.gz"; \
    fi
RUN tar xzf /tmp/sonarr.tar.gz -C /opt/Sonarr --strip-components=1
RUN rm -rf /opt/Sonarr/Sonarr.Update /tmp/*

FROM alpine:3.19 as mirror

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk add --no-cache --initdb -p /out \
    alpine-baselayout \
    busybox \
    chromaprint \
    gettext-libs \
    icu-libs \
    libcurl \
    libmediainfo \
    sqlite-libs \
    tzdata
RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache

FROM scratch
ENTRYPOINT []
CMD []
WORKDIR /
COPY --from=mirror /out/ /
COPY --from=stage /opt/Sonarr /opt/Sonarr/

EXPOSE 8989 9898
VOLUME [ "/data" ]
ENV HOME /data
WORKDIR $HOME
CMD ["/opt/Sonarr/Sonarr", "-nobrowser", "-data=/data"]

LABEL org.opencontainers.image.source="https://github.com/Sonarr/Sonarr"
LABEL org.opencontainers.image.description="Smart PVR for newsgroup and bittorrent users."
LABEL org.opencontainers.image.licenses="GPL-3.0-only"