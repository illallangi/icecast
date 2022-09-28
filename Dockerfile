# main image
FROM ghcr.io/illallangi/debian:v0.0.6

# install icecast2
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && \
  apt-get install -y --no-install-recommends \
    icecast2=2.4.4-1 \
    mime-support=3.62 \
    uuid-runtime=2.33.1-0.1 \
  && \
  apt-get clean \
  && \
  rm -rf /var/lib/apt/lists/*

# add local files
COPY rootfs /
