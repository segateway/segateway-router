ARG REGISTRY=ghcr.io/segateway/containers/segateway-destination
ARG BASEVERSION=3.2.0
FROM $REGISTRY:$BASEVERSION as builder


RUN apk add -U --upgrade --no-cache \
    python3-dev \
    libffi-dev

COPY python /app/plugin

RUN python3 -m venv /app/.venv ;\
    . /app/.venv/bin/activate ;\
    cd  /app/plugin;\
    poetry install --only main -n

FROM $REGISTRY:$BASEVERSION

ENV VIRTUAL_ENV=/app/.venv
COPY --from=builder /app/.venv /app/.venv
COPY etc/syslog-ng/ /etc/syslog-ng/
# COPY python /app/plugin

USER ${uid}:${gid}
