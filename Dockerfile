FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends git curl tar ca-certificates python3 && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash -s -- --non-interactive --skip-browser --skip-computer-use
RUN /root/.local/bin/hermes config set model.default nvidia/nemotron-3-ultra-550b-a55b
RUN UV_BIN="$(find /root/.hermes/tools -name uv -type f | head -n1)" && cd /root/.hermes/hermes-agent && ("$UV_BIN" pip install --no-cache --python /root/.hermes/hermes-agent/.venv/bin/python yfinance pandas || "$UV_BIN" pip install --no-cache yfinance pandas)
COPY skills/forex-research/SKILL.md /root/.hermes/skills/forex-research/SKILL.md
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
