# Using debian since aws install does not work on alpine
FROM debian:bullseye-slim

RUN apt-get update \
    && apt-get install --yes curl unzip busybox postgresql-client \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install 

COPY psql2s3 /usr/bin/psql2s3

CMD ["psql2s3"]
