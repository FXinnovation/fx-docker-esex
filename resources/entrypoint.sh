#!/bin/sh
set -e -x

# Verifying configuration of snapshots on es cluster

# Building limit_date
LIMIT_DATE=$(date -d "${ESEX_ES_RETENTION_DAYS} days ago" +"%Y.%m.%d")
# Listing indices
INDICE_LIST=$(curl -q \
                -X GET \
                -H "Accept: application/json" \
                "$1:$2/_cat/indices?format=json" | jq -r '.[].index' |sort )

# For each indice
for INDICE in ${INDICE_LIST}
do
  echo "Processing: ${INDICE}"
  # Fetching current indice date
  INDICE_DATE=$(echo ${INDICE} | awk -F "-" '{ print $NF }')
  # If the indice date is smaller then the limit data
  if [ "${INDICE_DATE}" < "${LIMIT_DATE}" ]; then
    echo "Indice: '${INDICE}' is going to be snapshoted"
    # Asking for export
    
    # Waiting for export to be done

  else
    echo "Indice: '${INDICE}' is to recent for export, skipping."
  fi
done
