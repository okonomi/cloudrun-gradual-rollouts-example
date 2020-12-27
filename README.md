# Cloud Run gradual rollouts example

Setup:

```
gcloud components install beta -y
gcloud auth login
gcloud auth configure-docker
gcloud config set project [gcp-project-id]
```

Build image:

```
docker build -t rails-cloudrun-sandbox .
```

Run locally:

```
docker run --rm -it -p 3000:3000 -e PORT=3000 rails-cloudrun-sandbox
```

Push to GCR:

```
docker tag rails-cloudrun-sandbox gcr.io/[gcp-project-id]/rails-cloudrun-sandbox
docker push gcr.io/[gcp-project-id]/rails-cloudrun-sandbox
```

Deploy to Cloud Run(no traffic):

```
gcloud beta run deploy rails-cloudrun-sandbox \
    --platform managed \
    --image gcr.io/[gcp-project-id]/rails-cloudrun-sandbox \
    --allow-unauthenticated \
    --region asia-northeast2 \
    --no-traffic --tag "latest"
```

Get revision url:

```
set revision_url (gcloud beta run services describe rails-cloudrun-sandbox \
    --platform managed \
    --format json \
  | jq -r '.status.traffic[] | select(.tag == "latest").url')
```

Wait application ready:

```
while true
  set status_code (curl $revision_url -o /dev/null -w '%{http_code}' -s -m 10)

  if test "$status_code" = "200"
    break
  end
end
```

Switch traffic to latest:

```
gcloud beta run services update-traffic rails-cloudrun-sandbox \
    --platform managed \
    --to-latest
```
