#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Check if an argument was provided
if [ -z "$1" ]; then
  echo "No environment supplied. Usage: ./create-db.sh <env>"
  exit 1
fi

# Assign the first argument to ENV variable
ENV=$1

# Load environment variables from the appropriate .env file
if [ -f "./envs/.env.$ENV" ]; then
  echo "Loading environment variables from .env.$ENV file..."
  export $(grep -v '^#' ./envs/.env.$ENV | xargs)
else
  echo ".env.$ENV file not found!"
  exit 1
fi

# Check if the database exists
DB_EXISTS=$(PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -U $POSTGRES_USERNAME -p $POSTGRES_PORT -tc "SELECT 1 FROM pg_database WHERE datname = '$POSTGRES_DATABASE'" -d postgres | grep -q 1 && echo "yes" || echo "no")

if [ "$DB_EXISTS" = "yes" ]; then
  echo "Database $POSTGRES_DATABASE already exists in $ENV environment."
  exit 0
else
  echo "Creating database \"$POSTGRES_DATABASE\"..."
  PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -U $POSTGRES_USERNAME -p $POSTGRES_PORT -c 'CREATE DATABASE "'$POSTGRES_DATABASE'"' -d postgres 
  echo "Database \"$POSTGRES_DATABASE\" created successfully for $ENV environment!"
fi
