#!/bin/sh
set -e
PORT="${PORT:-8080}"
UUID="${UUID:?UUID env required}"
WS_PATH="${WS_PATH:-/ray}"
if [ ! -x /app/xray ]; then
  echo "downloading xray-core official release..."
  curl -fsSL -o /tmp/xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
  unzip -o -q /tmp/xray.zip -d /app/ xray
  chmod +x /app/xray
  rm -f /tmp/xray.zip
fi
cat > /app/config.json <<EOF
{
  "log": {"loglevel": "warning"},
  "inbounds": [
    {
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [{"id": "${UUID}"}],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {"path": "${WS_PATH}"}
      }
    }
  ],
  "outbounds": [{"protocol": "freedom"}]
}
EOF
exec /app/xray run -c /app/config.json
