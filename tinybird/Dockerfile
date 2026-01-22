FROM python:3.14-slim@sha256:4ed33101ee7ec299041cc41dd268dae17031184be94384b1ce7936dc4e5dead3

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    jq \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd --system --gid 1001 tinybird && \
    useradd --system --uid 1001 --gid tinybird --home /home/tinybird --create-home tinybird

WORKDIR /home/tinybird

# Install Tinybird using the standard installation script (as tinybird user)
COPY --chown=tinybird:tinybird handleLogin.sh /usr/local/bin/tinybird-login
COPY --chown=tinybird:tinybird getTokens.sh /usr/local/bin/get-tokens
COPY --chown=tinybird:tinybird tb-wrapper /usr/local/bin/tb-wrapper

# Switch to tinybird user for installation
USER tinybird
RUN curl https://tinybird.co | sh

ENV PATH="/home/tinybird/.local/bin:$PATH"
