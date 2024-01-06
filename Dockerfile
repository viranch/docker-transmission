FROM ubuntu:jammy

ARG DEBIAN_FRONTEND=noninteractive

# Build Transmission nightly that includes https://github.com/transmission/transmission/pull/1080
# but replace its v4.00 web interface with v2.94's web interface for JS API compatibility
# Also install other runtime dependencies of this docker image while we're apt-get'in stuff
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl xz-utils cmake make g++ libcurl4-openssl-dev libssl-dev python3 && \
    curl -L https://github.com/transmission/transmission/releases/download/4.0.5/transmission-4.0.5.tar.xz | tar xJ -C /tmp && \
    curl -L https://github.com/transmission/transmission/archive/refs/tags/2.94.tar.gz | tar xz -C /tmp && \
    cd /tmp/transmission-4.0.5 && rm -rf web && mkdir web && cp -R /tmp/transmission-2.94/web web/public_html && \
    cmake -B build -DCMAKE_BUILD_TYPE=Release -DENABLE_TESTS=OFF -DINSTALL_DOC=OFF -DENABLE_UTILS=OFF && \
    cd build && cmake --build . && cmake --install . && \
    apt-get remove -y --purge xz-utils cmake make g++ libcurl4-openssl-dev libssl-dev python3 && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# Setup transmission
COPY assets/config/transmission.json /opt/

# Add required scripts
COPY assets/scripts/ /opt/scripts/

# Finally declare public things
VOLUME /config
VOLUME /data
EXPOSE 9091

# Define how to run the image
ENTRYPOINT ["/opt/scripts/start.sh"]
CMD ["/usr/local/bin/transmission-daemon", "-f", "--config-dir", "/config"]
