FROM mesosphere/aws-cli
ADD pipe.sh /pipe.sh
ENTRYPOINT /pipe.sh