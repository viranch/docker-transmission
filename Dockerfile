FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

# Build Transmission nightly that includes https://github.com/transmission/transmission/pull/1080
# but replace its v3.00 web interface with v2.94's web interface for JS API compatibility
# Also install other runtime dependencies of this docker image while we're apt-get'in stuff
RUN apt-get update && \
    apt-get install -y --no-install-recommends git cmake make g++ ca-certificates libcurl4-openssl-dev libssl-dev zlib1g-dev autotools-dev automake libtool && \
    git clone https://github.com/transmission/transmission /tmp/transmission && \
    cp -R /tmp/transmission /tmp/transmission2 && \
    cd /tmp/transmission && git checkout 0e2ecd8f63f9d0605d9798b0ae8e195a9d5bdc9b && git submodule update --init && \
    git -C /tmp/transmission2 checkout tags/2.94 && rm -rf web/* && cp -R /tmp/transmission2/web web/public_html && \
    mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DENABLE_WEB=OFF -DENABLE_TESTS=OFF -DINSTALL_DOC=OFF -DENABLE_UTILS=OFF .. && \
    make -j$(cat /proc/cpuinfo | grep processor -c) && make install && \
    apt-get remove -y --purge git cmake make g++ libcurl4-openssl-dev libssl-dev zlib1g-dev autotools-dev automake libtool && \
    apt-get autoremove -y && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/* /var/tmp/* /tmp/*

# Setup transmission
COPY assets/config/transmission.json /opt/

# Add required scripts
COPY assets/scripts/ /opt/scripts/

# Finally declare public things
VOLUME /data
EXPOSE 9091

# Define how to run the image
ENTRYPOINT ["/opt/scripts/start.sh"]
CMD ["/usr/local/bin/transmission-daemon", "-f", "--config-dir", "/data/transmission"]
