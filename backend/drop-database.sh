#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Check if an argument was provided
if [ -z "$1" ]; then
  echo "No environment supplied. Usage: ./drop-database.sh <env>"
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
DB_EXISTS=$(PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -U $POSTGRES_USERNAME -p $POSTGRES_PORT -d postgres -tc "SELECT 1 FROM pg_database WHERE datname = '$POSTGRES_DATABASE'" | grep -q 1 && echo "yes" || echo "no")

if [ "$DB_EXISTS" = "no" ]; then
  echo "Database $POSTGRES_DATABASE does not exist in $ENV environment."
  exit 0
fi

# Prompt user for confirmation to drop the database
read -p "Do you want to drop the existing database $POSTGRES_DATABASE? (y/n): " CONFIRM
if [ "$CONFIRM" != "y" ]; then
  echo "Aborting database drop."
  exit 0
fi

echo "Dropping database $POSTGRES_DATABASE..."
PGPASSWORD=$POSTGRES_PASSWORD psql -h $POSTGRES_HOST -U $POSTGRES_USERNAME -p $POSTGRES_PORT -d postgres -c "DROP DATABASE \"$POSTGRES_DATABASE\""
echo "Database $POSTGRES_DATABASE dropped successfully."
