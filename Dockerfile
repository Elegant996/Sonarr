FROM scratch AS source

ADD ./sonarr.tar.gz /

FROM alpine:3.20 AS build-sysroot

# Prepare sysroot
RUN mkdir -p /sysroot/etc/apk && cp -r /etc/apk/* /sysroot/etc/apk/

# Fetch runtime dependencies
RUN apk add --no-cache --initdb -p /sysroot \
    alpine-baselayout \
    busybox \
    gettext-libs \
    icu-libs \
    libcurl \
    libmediainfo \
    sqlite-libs \
    tzdata
RUN rm -rf /sysroot/etc/apk /sysroot/lib/apk /sysroot/var/cache

# Install Sonarr to new system root
RUN mkdir -p /sysroot/opt/Sonarr
COPY --from=source /Sonarr /sysroot/opt/Sonarr
RUN rm -rf /sysroot/opt/Sonarr/Sonarr.Update

# Install entrypoint
COPY --chmod 755 ./entrypoint.sh /sysroot/entrypoint.sh

# Build image
FROM scratch
COPY --from=build-sysroot /sysroot/ /

EXPOSE 8989 9898
VOLUME [ "/data" ]
ENV HOME=/data
WORKDIR $HOME
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/opt/Sonarr/Sonarr", "-nobrowser", "-data=/data"]

ARG VERSION

LABEL org.opencontainers.image.description="Smart PVR for newsgroup and bittorrent users."
LABEL org.opencontainers.image.licenses="GPL-3.0-only"
LABEL org.opencontainers.image.source="https://github.com/Sonarr/Sonarr"
LABEL org.opencontainers.image.title="Sonarr"
LABEL org.opencontainers.image.version=${VERSION}
LABEL org.opencontainers.image.url="https://sonarr.tv/"