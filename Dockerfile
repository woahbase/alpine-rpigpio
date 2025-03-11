# syntax=docker/dockerfile:1
#
ARG IMAGEBASE=frommakefile
#
FROM ${IMAGEBASE}
#
ENV \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1
#
RUN set -xe \
    && apk add --no-cache -Uu --virtual .build-dependencies \
        build-base \
        libffi-dev \
        musl \
        openssl-dev \
        python3-dev \
    && pip3 install --no-cache-dir --upgrade --break-system-packages \
        setuptools \
        wheel \
    && pip3 install --no-cache-dir --break-system-packages \
        pyserial \
        RPi.GPIO \
    && apk del --purge .build-dependencies \
    && apk add --no-cache --purge \
        ca-certificates \
        musl \
        wiringpi \
    && rm -rf /var/cache/apk/* /tmp/* /root/.cache
#
COPY root/ /
#
ENTRYPOINT ["/usershell"]
# CMD ["/usr/bin/python"]
