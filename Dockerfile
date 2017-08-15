FROM alpine:3.6

ENV CURL_VERSION=7.55.0-r0 \
    JQ_VERSION=1.5-r3 \
    COREUTILS_VERSION=8.27-r0 \
    ESEX_ES_HOST=elasticsearch \
    ESEX_ES_PORT=9200 \
    ESEX_ES_RETENTION_DAYS=15 \
    ESEX_S3_BUCKET_NAME=s3-export-bucket \
    ESEX_S3_BUCKET_REGION=us-east-1 \
    ESEX_S3_ROLE_ARN="arn:aws:iam::123456789012:role/es-s3-repository"

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

ADD ./resources /resources

RUN /resources/build && rm -rf /resources

ENTRYPOINT ["/entrypoint.sh"]

USER esex

LABEL "maintainer"="cloudsquad@fxinnovation.com" \
      "org.label-schema.name"="esex" \
      "org.label-schema.base-image.name"="docker.io/library/alpine" \
      "org.label-schema.base-image.version"="3.6" \
      "org.label-schema.description"="ESEx in a container" \
      "org.label-schema.url"="https://bitbucket.org/fxadmin/public-common-docker-esex" \
      "org.label-schema.vcs-url"="https://bitbucket.org/fxadmin/public-common-docker-esex" \
      "org.label-schema.vendor"="FXinnovation" \
      "org.label-schema.schema-version"="1.0.0-rc.1" \
      "org.label-schema.applications.curl.version"=$CURL_VERSION \
      "org.label-schema.applications.jq.version"=$JQ_VERSION \
      "org.label-schema.applications.coreutils.version"=$COREUTILS_VERSION \
      "org.label-schema.vcs-ref"=$VCS_REF \
      "org.label-schema.version"=$VERSION \
      "org.label-schema.build-date"=$BUILD_DATE \
      "org.label-schema.usage"="https://bitbucket.org/fxadmin/public-common-docker-esex"
