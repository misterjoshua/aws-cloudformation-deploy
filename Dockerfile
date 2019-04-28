FROM alpine:3.9
RUN apk -v --update add \
        bash \
        python \
        py-pip \
        rsync \
        jq \
        && \
    pip install awscli s3cmd python-magic && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*
COPY pipe.sh /pipe.sh
ENTRYPOINT /pipe.sh