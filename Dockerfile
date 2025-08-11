# Dockerfile - Create-Host (Render-ready)
# Base image
FROM debian:12-slim

# Metadata
LABEL maintainer="create-host <you@example.com>"

# Arguments / defaults
ARG USERNAME=hostuser
ARG UID=1000
ARG GOTTY_VERSION=2.0.0

# Default envs (override in Render env or render.yaml)
ENV GOTTY_PORT=8080
ENV SHELL=/bin/bash
ENV GOTTY_AUTH=basic
# IMPORTANT: override this in Render env (use Render dashboard secrets)
ENV GOTTY_PASSWORD=admin:changeme
ENV GOTTY_TITLE="VPS"
ENV GOTTY_CORS="*"

# Install required packages: build tools for gotty, utilities
RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates wget curl gnupg2 build-essential git golang-go sudo procps less \
      neofetch htop locales xz-utils fish iproute2 iputils-ping dnsutils net-tools \
      apt-transport-https; \
    rm -rf /var/lib/apt/lists/*; \
    # Set locale (optional)
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen; locale-gen en_US.UTF-8

# Build gotty from maintained fork (go-gotty) via go install with proxy
ENV GOPROXY=https://proxy.golang.org,direct
RUN set -eux; \
    go install github.com/go-gotty/gotty/cmd/gotty@latest; \
    mv /root/go/bin/gotty /usr/local/bin/gotty; \
    chmod +x /usr/local/bin/gotty



# Create non-root user
RUN set -eux; \
    groupadd -g ${UID} ${USERNAME} || true; \
    useradd -m -u ${UID} -s /bin/bash ${USERNAME} || true; \
    mkdir -p /home/${USERNAME}/workspace; \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

WORKDIR /home/${USERNAME}/workspace

# Copy entrypoint
COPY run_gotty.sh /usr/local/bin/run_gotty.sh
RUN chmod +x /usr/local/bin/run_gotty.sh

# Provide a small helper to create user-owned files at runtime
COPY default_bashrc.sh /usr/local/bin/default_bashrc.sh
RUN chmod +x /usr/local/bin/default_bashrc.sh

# Expose port
EXPOSE 8080

# Drop to non-root
USER ${USERNAME}

# Entrypoint
ENTRYPOINT ["/usr/local/bin/run_gotty.sh"]

# Default command is provided by run_gotty.sh
