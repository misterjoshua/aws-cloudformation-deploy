FROM python:3-alpine
RUN apk -v --update add \
        bash \
        rsync \
        jq \
        && \
    pip install awscli
COPY . /setup/