#!/bin/sh
set -e -x

# Apply configuration of snapshots on es cluster
curl -q \
  -XPUT "${ESEX_ES_HOST}:${ESEX_ES_PORT}/_snapshot/snapshot-repository" \
  -d "{\"type\":\"s3\",\"settings\":{\"bucket\":\"${ESEX_S3_BUCKET_NAME}\",\"region\":\"${ESEX_S3_BUCKET_REGION}\",\"role_arn\":\"${ESEX_S3_ROLE_ARN}\"}}"

curl -q \
  -X POST \
  "${ESEX_ES_HOST}:${ESEX_ES_PORT}/_snapshot/${ESEX_S3_BUCKET_NAME}/_verify?format=json"


# Building limit_date
LIMIT_DATE=$(date -d "${ESEX_ES_RETENTION_DAYS} days ago" +"%Y.%m.%d")
# Listing indices
INDICE_LIST=$(curl -q \
                -X GET \
                -H "Accept: application/json" \
                "${ESEX_ES_HOST}:${ESEX_ES_PORT}/_cat/indices?format=json" | jq -r '.[].index' |sort )

# For each indice
for INDICE in ${INDICE_LIST}
do
  echo "Processing: ${INDICE}"
  # Fetching current indice date
  INDICE_DATE=$(echo ${INDICE} | awk -F "-" '{ print $NF }')
  # If the indice date is smaller then the limit data
  if [ "${INDICE_DATE}" \< "${LIMIT_DATE}" ]; then
    if [[ "$INDICE_DATE" == *"kibana"* ]]; then
      echo "Indice '${INDICE}' is not eligible for snapshot!"
    else
      echo "Indice: '${INDICE}' is going to be snapshoted"
      # Asking for export
      curl -q \
        -X PUT \
        "${ESEX_ES_HOST}:${ESEX_ES_PORT}/_snapshot/${ESEX_S3_BUCKET_NAME}/${INDICE}" \
        -d "{\"indices\":\"${INDICE}\",\"include_global_state\":false,\"ignore_unavailable\":false}"
      # Waiting for export to be done
      SNAPSHOT_ONGOING="TRUE"
      while [ "${SNAPSHOT_ONGOING}" == "TRUE" ]
      do
        echo "Waiting for snapshot to finish"
        curl -q \
          -X GET \
          "${ESEX_ES_HOST}:${ESEX_ES_PORT}/_snapshot/${ESEX_S3_BUCKET_NAME}/${INDICE}?format=json"
        # TODO Parse result HERE
        SNAPSHOT_ONGOING="FALSE"
        sleep 10
      done
      # Asking for deletion
      #curl -q \
      #  -X DELETE \
      #"${ESEX_ES_HOST}:${ESEX_ES_PORT}/${INDICE}?format=json"
    fi
  else
    echo "Indice: '${INDICE}' is to recent for export, skipping."
  fi
done
