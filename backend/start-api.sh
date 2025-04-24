#!/bin/bash

# Check if the first argument (NODE_ENV) is provided
if [ -z "$1" ]; then
  echo "Error: NODE_ENV is not provided. Please specify the environment (e.g., dev, production)."
  exit 1
fi

# Assign the first argument to NODE_ENV
NODE_ENV=$1
export NODE_ENV=$NODE_ENV

# Print NODE_ENV
echo "Starting with NODE_ENV: $NODE_ENV"
# Run docker-compose with the provided options
docker compose up -d && npm run start

# Start the NestJS application with the provided NODE_ENV
