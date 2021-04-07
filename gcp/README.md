Sample Bigquery
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
