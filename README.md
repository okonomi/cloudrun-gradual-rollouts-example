# Rails Cloud Run Sandbox

Setup:

```
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

Deploy to Cloud Run:

```
gcloud run deploy rails-cloudrun-sandbox \
    --platform managed \
    --image gcr.io/[gcp-project-id]/rails-cloudrun-sandbox \
    --allow-unauthenticated \
    --region asia-northeast2
```
