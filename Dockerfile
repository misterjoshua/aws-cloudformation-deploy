FROM python:3-alpine
RUN apk add bash rsync
RUN pip install awscli

COPY pipe.sh /pipe.sh
ENTRYPOINT /pipe.sh