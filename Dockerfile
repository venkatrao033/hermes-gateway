FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends git curl tar ca-certificates python3 && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash -s -- --non-interactive --skip-browser --skip-computer-use
RUN /root/.local/bin/hermes config set model.default nvidia/nemotron-3-ultra-550b-a55b
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
