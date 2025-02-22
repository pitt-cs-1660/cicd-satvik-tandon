#!/bin/bash
set -e

chmod +x /app/entrypoint.sh  # Ensure script is executable
exec "$@"