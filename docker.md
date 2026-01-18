# pull, update, rebuild and repush all architectures with latest sendspin build
```
docker buildx build --annotation org.opencontainers.image.description="Contains sendspin-cli release 3.0.0" --platform linux/amd64,linux/arm64,linux/arm/v8,linux/arm/v7 -f Dockerfile.update -t ghcr.io/longlivethehud/sendspin-docker:latest --pull --push .
```

# Update shared manifest after separate image pushs
```
docker buildx imagetools create -t ghcr.io/longlivethehud/sendspin-docker:latest ghcr.io/longlivethehud/sendspin-docker:latest ghcr.io/longlivethehud/sendspin-docker:armhf
```