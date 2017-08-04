# ESEx
[![](https://images.microbadger.com/badges/version/fxinnovation/esex.svg)](https://microbadger.com/images/fxinnovation/esex "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/fxinnovation/esex.svg)](https://microbadger.com/images/fxinnovation/esex "Get your own image badge on microbadger.com")
## Description
This image contains ESEx. The image is based on the official alpine image to keep it light.

## Tags
We do NOT push a `latest` tag for this image. You should always pin a specific version for it.

*Note: We publish a `master` tag, this tag should not be used in production, we use it internally for testing purposes*

## Usage
```
docker run --rm -e [KEY]=[VALUE] fxinnovation/esex:[TAG]
```
| Key | Default Value |
|-----|:-------------:|
| ESEX_ES_HOST | elasticsearch |
| ESEX_ES_PORT | 9200 |
| ESEX_ES_RETENTION_DAYS | 15 |
| ESEX_S3_BUCKET_NAME | s3-export-bucket |
| ESEX_S3_BUCKET_REGION | us-east-1 |
| ESEX_S3_ROLE_ARN | arn:aws:iam::123456789012:role/es-s3-repository |

*Note: You can find information for setting this up usig AWS ES Service here: https://aws.amazon.com/blogs/database/use-amazon-s3-to-store-a-single-amazon-elasticsearch-service-index/*

*Note: For now, this container is basically a shell script, altough I know this is not ideal, this was the quickest way to have something working. Once there will be some time, we will make this tool evolve into something a bit more evolved*

## Labels
We set labels on our images with additional information on the image. we follow the guidelines defined at http://label-schema.org/. Visit their website for more information about those labels.

## Comments & Issues
If you have comments or detect an issue, please be advised we don't check the docker hub comments. You can always contact us through the repository.
