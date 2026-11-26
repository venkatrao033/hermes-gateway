#!/bin/bash
set -e
mkdir -p /root/.hermes
umask 077
printf 'NVIDIA_API_KEY=%s\nTELEGRAM_BOT_TOKEN=%s\nTELEGRAM_ALLOWED_USERS=%s\n' "$NVIDIA_API_KEY" "$TELEGRAM_BOT_TOKEN" "$TELEGRAM_ALLOWED_USERS" > /root/.hermes/.env
python3 - <<'PYEOF' &
from http.server import BaseHTTPRequestHandler, HTTPServer
import os
class H(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"ok")
    def log_message(self, *a):
        pass
HTTPServer(("0.0.0.0", int(os.environ.get("PORT", "10000"))), H).serve_forever()
PYEOF
exec /root/.local/bin/hermes gateway run
