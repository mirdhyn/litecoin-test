ARG LITECOIN_VERSION=0.18.1
ARG LITECOIN_ARCH=x86_64
ARG TINI_VERSION=v0.19.0
ARG TINI_ARCH=amd64

FROM ubuntu:21.10

ARG LITECOIN_VERSION
ARG LITECOIN_ARCH
ARG TINI_VERSION
ARG TINI_ARCH
WORKDIR /tmp

# Get litecoin release & signature
RUN apt-get update && apt-get install -y wget gpg
RUN wget https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-${LITECOIN_ARCH}-linux-gnu.tar.gz
RUN wget https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-${LITECOIN_ARCH}-linux-gnu.tar.gz.asc

# validate litecoin archive
RUN gpg --keyserver pgp.mit.edu --recv-key FE3348877809386C
RUN gpg --verify litecoin-${LITECOIN_VERSION}-${LITECOIN_ARCH}-linux-gnu.tar.gz.asc

RUN tar xzvf litecoin-${LITECOIN_VERSION}-${LITECOIN_ARCH}-linux-gnu.tar.gz

# get tini for better init signals handling
RUN wget https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-${TINI_ARCH}
RUN wget https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-${TINI_ARCH}.asc
RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7
RUN gpg --verify tini-${TINI_ARCH}.asc
RUN chmod +x tini-${TINI_ARCH}


# Final docker image
FROM ubuntu:21.10
ARG LITECOIN_VERSION
ARG LITECOIN_ARCH
ARG TINI_ARCH
COPY --from=0 /tmp/litecoin-${LITECOIN_VERSION}/bin/litecoind /usr/local/bin/litecoind
COPY --from=0 /tmp/tini-${TINI_ARCH} /usr/local/bin/tini
RUN mkdir /.litecoin && chown 1000 /.litecoin

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates
RUN update-ca-certificates

# Run vulnerability scan
COPY --from=aquasec/trivy:latest /usr/local/bin/trivy /usr/local/bin/trivy
RUN trivy rootfs --exit-code 1 --no-progress /


# Switch to non-root user
USER 1000

ENTRYPOINT ["/usr/local/bin/tini", "--"]
CMD ["/usr/local/bin/litecoind"]
