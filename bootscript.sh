#!/bin/bash
# =============================================================================
# Boot script for aws-test-project Flask app
# Intended for use as EC2 User Data or a standalone server bootstrap script.
# Tested on Amazon Linux 2023 / Ubuntu 22.04
# =============================================================================

set -euo pipefail

APP_DIR="/opt/aws-test-project"
REPO_URL="https://github.com/atulkamble/aws-test-project.git"
SERVICE_NAME="flaskapp"
APP_PORT=5000

# -----------------------------------------------------------------------------
# 1. System update & install dependencies
# -----------------------------------------------------------------------------
if command -v dnf &>/dev/null; then
    # Amazon Linux 2023 / RHEL
    dnf update -y
    dnf install -y python3 python3-pip git
elif command -v apt-get &>/dev/null; then
    # Ubuntu / Debian
    apt-get update -y
    apt-get install -y python3 python3-pip git
else
    echo "ERROR: Unsupported package manager. Install Python 3, pip, and git manually."
    exit 1
fi

# -----------------------------------------------------------------------------
# 2. Clone / update the repository
# -----------------------------------------------------------------------------
if [ -d "$APP_DIR/.git" ]; then
    echo "Repository already exists — pulling latest changes..."
    git -C "$APP_DIR" pull
else
    echo "Cloning repository..."
    git clone "$REPO_URL" "$APP_DIR"
fi

# -----------------------------------------------------------------------------
# 3. Install Python dependencies
# -----------------------------------------------------------------------------
pip3 install --upgrade pip
pip3 install -r "$APP_DIR/requirements.txt"
pip3 install gunicorn   # production WSGI server

# -----------------------------------------------------------------------------
# 4. Create a systemd service so the app starts on reboot
# -----------------------------------------------------------------------------
cat > /etc/systemd/system/${SERVICE_NAME}.service <<EOF
[Unit]
Description=Flask Hello World App
After=network.target

[Service]
User=root
WorkingDirectory=${APP_DIR}/src
ExecStart=/usr/local/bin/gunicorn --workers 2 --bind 0.0.0.0:${APP_PORT} app:app
Restart=always
RestartSec=5
Environment="FLASK_ENV=production"

[Install]
WantedBy=multi-user.target
EOF

# -----------------------------------------------------------------------------
# 5. Enable & start the service
# -----------------------------------------------------------------------------
systemctl daemon-reload
systemctl enable "$SERVICE_NAME"
systemctl restart "$SERVICE_NAME"

echo "======================================================"
echo " Flask app is running on http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):${APP_PORT}"
echo "======================================================"
