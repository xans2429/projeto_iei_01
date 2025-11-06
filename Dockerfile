# syntax=docker/dockerfile:1
FROM python:3.11-slim

LABEL maintainer="xans2429" purpose="dev container"

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential pkg-config cmake ca-certificates curl git \
    libasound2 libpulse0 \
    libsdl2-2.0-0 libsdl2-dev \
    libsdl2-image-2.0-0 libsdl2-image-dev \
    libsdl2-mixer-2.0-0 libsdl2-mixer-dev \
    libsdl2-ttf-2.0-0 libsdl2-ttf-dev \
    libfreetype6 libfreetype6-dev \
    libx11-6 libx11-dev libxext6 libxrender1 \
    libjpeg-dev zlib1g-dev libpng-dev \
    fontconfig fonts-dejavu-core \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
COPY requirements.txt /workspace/requirements.txt

RUN python -m pip install --upgrade pip setuptools wheel \
 && if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi

ARG UID=1000
ARG GID=1000
RUN groupadd -g ${GID} devgroup \
 && useradd -m -u ${UID} -g devgroup -s /bin/bash devuser \
 && mkdir -p /workspace \
 && chown -R devuser:devgroup /workspace

USER devuser
ENV HOME=/home/devuser
WORKDIR /workspace

CMD ["sleep", "infinity"]
