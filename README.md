# psql2s3
Utility to backup postgresql databases in s3

* backup is a logical sql dump made with `pg_dumpall`, gzipped
* aws cli uses the default credentials chain to access the bucket. It's
  recommended to use UW's [vault
  setup](https://github.com/utilitywarehouse/documentation/blob/master/infra/vault-aws.md)
  to provide the credentials
* psql2s3 does not manage the amount of backups stored, so setting retention
  policies in the bucket is recommended
* backups are made periodically in configurable intervals, but are not
  schedulable
* a `psql2s3_last_successful_run` metric is available to alert on failed
  backups

## Configuration
* S3_BUCKET: bucket where the backups will live
* PSQL2S3_SLEEP: seconds to sleep between backups. Default: `86400`(24h)
* PSQL2S3_METRICS_PORT: port where the prometheus metrics are exposed. Default:
  `8080`
* PSQL_USER: username of the postgres instance. Default: `postgres`
* PSQL_HOSTNAME: hostname of the postgresql instance. Default: `localhost`
* PSQL_PORT: port where postgresql is listening. Default: `5432`

## Alerting on failed backup
It is recommended to setup an alert to detect failing backups. The expression
would depend on the sleep interval. For a 24h interval, a possible expression
would be : `time() - psql2s3_last_successful_run > 60 * 60 * 25`

## Recovering from a backup
Gunzip the backup and pipe it into psql with valid connection data. Eg:
`gunzip xxxx_pg_dumpall.gz | psql -U postgres -h localhost`

