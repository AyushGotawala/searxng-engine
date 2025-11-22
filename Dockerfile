# VedaOS SearxNG Service - Production Ready
# Based on SearxNG official image with optimized settings

FROM searxng/searxng:latest

# Set maintainer
LABEL maintainer="VedaOS Team"
LABEL description="Production SearxNG search service for VedaOS"

# Copy custom settings
COPY settings.yml /etc/searxng/settings.yml

# Environment variables (secrets should be passed at runtime)
ENV SEARXNG_BASE_URL=http://localhost:8080

# Note: SEARXNG_SECRET_KEY should be set at runtime via environment variables

# Health check endpoint
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/healthz || exit 1

# Expose the port
EXPOSE 8080

# Use the official SearxNG entrypoint (let the base image handle it)
# ENTRYPOINT and CMD are inherited from the base image