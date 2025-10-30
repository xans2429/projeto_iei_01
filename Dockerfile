# syntax=docker/dockerfile:1
FROM python:3.11-slim

LABEL maintainer="xans2429" purpose="dev container"

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential git curl ca-certificates gcc libpq-dev \
 && rm -rf /var/lib/apt/lists/*

ARG UID=1000
ARG GID=1000
RUN groupadd -g ${GID} devgroup \
 && useradd -m -u ${UID} -g devgroup -s /bin/bash devuser

WORKDIR /workspace
COPY requirements.txt /workspace/requirements.txt
USER devuser

RUN python -m pip install --upgrade pip setuptools wheel \
 && if [ -f requirements.txt ]; then pip install -r requirements.txt; fi

CMD ["sleep", "infinity"]

