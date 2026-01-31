# pull, update, rebuild and repush all architectures with latest sendspin build
```
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v8,linux/arm/v7 --build-arg VERSION="4.3.0" --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") --no-cache-filter upgrade-sendspin -f Dockerfile -t ghcr.io/longlivethehud/sendspin-docker:latest --pull --push .
```

# Update shared manifest after separate image pushs
```
docker buildx imagetools create -t ghcr.io/longlivethehud/sendspin-docker:latest ghcr.io/longlivethehud/sendspin-docker:latest ghcr.io/longlivethehud/sendspin-docker:armhf
```