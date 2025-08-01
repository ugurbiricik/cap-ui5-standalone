#!/bin/bash
set -e

cf_opts=
cf api ${INPUT_API:-$CF_API} ${cf_opts}

INPUT_USERNAME=${INPUT_USERNAME:-$CF_USERNAME}
INPUT_PASSWORD=${INPUT_PASSWORD:-$CF_PASSWORD}

# Use API token for authentication
echo "Using API token authentication..."
cf auth ${INPUT_USERNAME:-$CF_USERNAME} ${INPUT_PASSWORD:-$CF_PASSWORD}

if [ "x${INPUT_CREATESPACE}" = "xtrue" ]; then
  cf create-space ${INPUT_SPACE:-$CF_SPACE} -o "${INPUT_ORG:-$CF_ORG}"
fi

cf target -o "${INPUT_ORG:-$CF_ORG}" -s ${INPUT_SPACE:-$CF_SPACE}

cf deploy ${INPUT_MTAFILE} -f
