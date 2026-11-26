# hermes-gateway

Runs the Hermes Agent Telegram gateway (@Keekabot) as a Render free web service.

- Dockerfile installs hermes-agent v0.23.4 and sets the NVIDIA free model.
- start.sh writes /root/.hermes/.env from Render env vars (NVIDIA_API_KEY, TELEGRAM_BOT_TOKEN, TELEGRAM_ALLOWED_USERS), serves a 200 health endpoint on $PORT, then runs `hermes gateway run` (Telegram long polling).
- Secrets live only as Render env vars, never in this repo.
