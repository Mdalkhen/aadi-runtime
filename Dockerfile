# aadi-runtime: public tools only (no keys, no episode files). Used by the «عادي جداً» pipeline on rented vast.ai boxes
# so a fresh instance starts in ~2 minutes instead of installing everything (~10-15 min).
FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04
ENV DEBIAN_FRONTEND=noninteractive PIP_NO_CACHE_DIR=1
RUN apt-get update && apt-get install -y --no-install-recommends \
      python3 python3-pip ffmpeg curl ca-certificates unzip git \
      libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 \
      libxfixes3 libxrandr2 libgbm1 libasound2 libpango-1.0-0 libcairo2 \
 && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && apt-get install -y nodejs \
 && curl -s https://rclone.org/install.sh | bash \
 && rm -rf /var/lib/apt/lists/*
RUN pip3 install faster-whisper numpy pillow
COPY remotion-package.json /opt/remotion/package.json
RUN cd /opt/remotion && npm install --no-audit --no-fund && npx remotion browser ensure
RUN ln -sf "$(command -v python3)" /usr/local/bin/aadipy && touch /opt/aadi_runtime_ready
