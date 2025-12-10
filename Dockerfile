# Ghost with Cloudflare R2 Storage Adapter
# Extends official Ghost image with ghost-storage-cloudflare-r2 for media offload
#
# Required environment variables for R2 storage:
#   storage__active=r2
#   storage__r2__bucket=<BUCKET_NAME>
#   storage__r2__endpoint=https://<ACCOUNT_ID>.r2.cloudflarestorage.com
#   storage__r2__accessKeyId=<R2_ACCESS_KEY_ID>
#   storage__r2__secretAccessKey=<R2_SECRET_ACCESS_KEY>
#   storage__r2__publicDomain=https://<CUSTOM_DOMAIN> (optional, for public URL)
#
# Optional settings:
#   imageOptimization__resize=false (recommended to disable Ghost's built-in resizing)

FROM ghost:6.10.1-alpine3.23

# Install git for cloning adapter (will be removed after install)
RUN apk add --no-cache --virtual .build-deps git

# Create storage adapters directory
RUN mkdir -p /var/lib/ghost/content/adapters/storage

# Install ghost-storage-cloudflare-r2 adapter
# The adapter is cloned into the 'r2' directory, making it available as storage__active=r2
WORKDIR /var/lib/ghost/content/adapters/storage
RUN git clone --depth 1 https://github.com/cinntiq/ghost-storage-cloudflare-r2.git r2 && \
    cd r2 && \
    npm install --production --omit=dev && \
    npm cache clean --force

# Remove build dependencies to keep image small
RUN apk del .build-deps

# Reset working directory
WORKDIR /var/lib/ghost

# The adapter is configured via environment variables:
# - storage__active=r2 activates the adapter
# - storage__r2__* configures the R2 connection
