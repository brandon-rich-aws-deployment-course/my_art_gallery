#!/bin/bash
set -e

# Check for and run pending migrations
echo "Running db:migrate..."
bundle exec rake db:migrate

# Then exec the container's main process (what's set as CMD in the Dockerfile)
exec "$@"

