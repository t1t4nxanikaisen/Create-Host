#!/usr/bin/env bash
# default_bashrc.sh <home-dir>
set -euo pipefail
HOME_DIR="${1:-/home/hostuser}"

mkdir -p "$HOME_DIR"
chown -R $(id -u):$(id -g) "$HOME_DIR"

cat > "$HOME_DIR/.bashrc" <<'EOF'
# .bashrc - default for Create-Host
export TERM=xterm-256color
[ -x /usr/bin/neofetch ] && neofetch --ascii_distro Debian || true
PS1='\u@\h:\w\$ '
# allow color ls
alias ls='ls --color=auto'
EOF

# Ensure ownership
chown $(id -u):$(id -g) "$HOME_DIR/.bashrc"
