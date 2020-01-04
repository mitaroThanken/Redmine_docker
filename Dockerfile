FROM redmine:4-alpine

RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN mkdir -p /run/.secrets

COPY .secrets/* /run/.secrets/

HEALTHCHECK --interval=15s --timeout=3s CMD wget -q http://localhost:3000 -O /dev/null || exit 1
