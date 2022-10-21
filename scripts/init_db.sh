#!/usr/bin/env bash

# -x = print commands and their args as they're executed
# -e = exit immediately if command exits with non-zero status
# -o pipefail = return value = last command to exit with non-zero status or zero if exits successfully
set -xeo pipefail

# Check if a custom user has been set, otherwise default to 'postgres'
DB_USER="${POSTGRES_USER:=postgres}"
DB_PASSWORD="${POSTGRES_PASSWORD:=password}"
DB_NAME="${POSTGRES_DB:=newsletter}"
DB_PORT="${POSTGRES_PORT:=5432}"

# Skip docker if postgres container is already running
if [[ -z "${SKIP_DOCKER}" ]]
then
  docker run \
  -e POSTGRES_USER=${DB_USER} \
  -e POSTGRES_PASSWORD=${DB_PASSWORD} \
  -e POSTGRES_DB=${DB_NAME} \
  -p "${DB_PORT}":5432 \
  -d postgres \
  postgres -N 500
  # ^ Increased maximum number of connections for testing purposes
fi