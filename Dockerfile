# Use a slim Debian base
FROM debian:12-slim

# Install packages (gotty + bash + sudo + curl)
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates \
    sudo \
    wget \
    curl \
    git \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Install gotty (latest releases may change — pinned to a reliable binary)
ENV GOTTY_VERSION 1.0.1

RUN set -eux; \
    ARCH=$(dpkg --print-architecture); \
    case "$ARCH" in \
      amd64) GOTTY_ARCH=linux-amd64 ;; \
      arm64) GOTTY_ARCH=linux-arm64 ;; \
      *) echo "unsupported arch $ARCH"; exit 1 ;; \
    esac; \
    wget -qO /tmp/gotty.tar.gz "https://github.com/yudai/gotty/releases/download/v${GOTTY_VERSION}/gotty_${GOTTY_VERSION}_${GOTTY_ARCH}.tar.gz"; \
    tar -xzf /tmp/gotty.tar.gz -C /usr/local/bin gotty; \
    chmod +x /usr/local/bin/gotty; \
    rm -f /tmp/gotty.tar.gz

# Create non-root user
ARG USERNAME=user
ARG UID=1000
RUN useradd -m -u ${UID} -s /bin/bash ${USERNAME} && \
    mkdir -p /home/${USERNAME}/workspace && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

WORKDIR /home/${USERNAME}/workspace

# Copy start script
COPY run_gotty.sh /usr/local/bin/run_gotty.sh
RUN chmod +x /usr/local/bin/run_gotty.sh

# Expose http port used by gotty
EXPOSE 8080

# Default envs (can be overridden in Render dashboard or render.yaml)
ENV GOTTY_PORT=8080
ENV SHELL=/bin/bash
ENV GOTTY_AUTH=password
ENV GOTTY_PASSWORD=changeme
ENV GOTTY_TITLE="VPS"
ENV GOTTY_CORS="*"

# Start gotty as non-root user
USER ${USERNAME}

ENTRYPOINT ["/usr/local/bin/run_gotty.sh"]
