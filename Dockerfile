# toolbx image
FROM ghcr.io/illallangi/toolbx:v0.0.8 as toolbx

# main image
FROM docker.io/library/debian:buster-20220912

# install confd from toolbx image
COPY --from=toolbx /usr/local/bin/confd /usr/local/bin/confd

# install prerequisites and icecast2
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && \
  apt-get install -y --no-install-recommends \
    ca-certificates=20200601~deb10u2 \
    icecast2=2.4.4-1 \
    mime-support=3.62 \
    musl=1.1.21-2 \
    uuid-runtime=2.33.1-0.1 \
    xz-utils=5.2.4-1+deb10u1 \
  && \
  apt-get clean \
  && \
  rm -rf /var/lib/apt/lists/*

# set version for s6 overlay
ARG OVERLAY_VERSION="v2.2.0.3"
ARG OVERLAY_ARCH="amd64"

# add s6 overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}-installer /tmp/
RUN chmod +x /tmp/s6-overlay-${OVERLAY_ARCH}-installer && /tmp/s6-overlay-${OVERLAY_ARCH}-installer / && rm /tmp/s6-overlay-${OVERLAY_ARCH}-installer
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# add local files
COPY rootfs /

# set command
CMD ["/init"]
