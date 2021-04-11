1. Sample Bigquery
```
SELECT *  
FROM `cloud-training-prod-bucket.arch_infra.billing_data`

```

```
SELECT *  
FROM `cloud-training-prod-bucket.arch_infra.billing_data`
ORDER BY cost DESC
```

In the same Query editor box, delete the existing contents, and enter the below query to find all charges that were more than 3 dollars
```
SELECT product, resource_type, start_time, end_time,  
cost, project_id, project_name, project_labels_key, currency, currency_conversion_rate,
usage_amount, usage_unit
FROM `cloud-training-prod-bucket.arch_infra.billing_data`
WHERE (cost > 3)

```

Next let’s find which product had the highest total number of records:
```
SELECT product, COUNT(*)
FROM `cloud-training-prod-bucket.arch_infra.billing_data`
GROUP BY product
LIMIT 200
```

Looks like Pub/Sub is pretty popular here...

```
SELECT product, cost, COUNT(*)
FROM `cloud-training-prod-bucket.arch_infra.billing_data`
WHERE (cost > 1)
GROUP BY cost, product
LIMIT 200
```

2. Sample commands for gcloud

```
gcloud config list

gsutil ls

gsutil ls gs://storagename

gsutil ls gs://storagename/**

gsutil mb --help

gsutil mb-l northamerica-northeast1 gs://storagename

gsutil lable get gs://storagename/

gsutil label set <jsonvalue> gs://storagenamenew

gsutil label ch -l "extralabel:extravalue" gs://storagename

gsutil versioning get gs://storagenamenew

gsutil versioning set on gs://storagenamenew

gsutil cp <filename> gs://storagenamenew/

gsutil ls -a gs://storagenamenew/

gsutil rm gs://storagenamenew/<filename>

gsutil cp gs://storagename/** gs://storagenamenew/

gsutil acl ch -u AllUsers:R  gs://storagenamenew/<filename>

```

3. Google Compute Engine

```
gcloud config get-value project

gcloud compute instances list

gcloud services list

gcloud services list -h

gcloud services list --enabled

gcloud services list --available | grep compute

gcloud services -h 

gcloud compute instances create myvm

gcloud compute instances delete myvm


```

4. GCE in and out 

```
gcloud config list

curl -kv api.ipify.org

gcloud compute instances create newvm -h 

gcloud compute instances create newvm -help

gcloud compute machine-types list

gcloud topic filters

gcloud compute machine-types list --filter="NAME:f1-micro"

gcloud compute machine-types list --filter="NAME:f1-micro AND ZONE~us-west"

gcloud config set compute/zone us-west2-b

gcloud config set compute/region us-west2

gcloud compute instances create --machine-types=f1-micro newvm 

ping -c 2 externalip

gcloud compute ssh newvm

curl -H "Metadata-Flavor:Google" metadata.google.internal/computeMetadata/v1

curl -H "Metadata-Flavor:Google" metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/email

Run inside vm `gcloud config list and gcloud compute instances delete newvm`



```
