# Use Debian 12 slim base image
FROM debian:12-slim

# Set environment variables to avoid prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Install required tools and dependencies in one go
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        wget \
        curl \
        ca-certificates \
        fish \
        neofetch \
        sudo \
        procps \
        iproute2 \
        net-tools \
        vim \
        less \
        gnupg2 \
        locales; \
    rm -rf /var/lib/apt/lists/*; \
    \
    # Setup locale (optional but useful for UTF-8 support)
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen; \
    locale-gen en_US.UTF-8; \
    update-locale LANG=en_US.UTF-8; \
    \
    # Add fish as default shell for root
    chsh -s /usr/bin/fish root

# Install gotty binary properly:  
# 1. We fetch the latest release info from GitHub API, parse URL, download, and install.
RUN set -eux; \
    GOTTY_LATEST_URL=$(curl -s https://api.github.com/repos/sorenisanerd/gotty/releases/latest \
        | grep browser_download_url \
        | grep linux_amd64.tar.gz \
        | cut -d '"' -f 4); \
    echo "Downloading gotty from $GOTTY_LATEST_URL"; \
    wget -O /tmp/gotty.tar.gz "$GOTTY_LATEST_URL"; \
    tar -xzf /tmp/gotty.tar.gz -C /tmp; \
    mv /tmp/gotty /usr/local/bin/gotty; \
    chmod +x /usr/local/bin/gotty; \
    rm /tmp/gotty.tar.gz

# Expose port 8080 for gotty
EXPOSE 8080

# Entrypoint script that starts gotty with fish shell for root (adjust as needed)
CMD ["gotty", "-w", "-p", "8080", "fish"]
