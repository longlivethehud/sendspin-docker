# pull, update, rebuild and repush all architectures with latest sendspin build
```
docker buildx build --annotation index.org.opencontainers.image.description="Contains sendspin-cli release 4.2.2" --annotation org.opencontainers.image.description="Contains sendspin-cli release 4.2.2" --label index.org.opencontainers.image.description="Contains sendspin-cli release 4.2.2" --label org.opencontainers.image.description="Contains sendspin-cli release 4.2.2" --label index.org.opencontainers.image.source="https://github.com/longlivethehud/sendspin-docker" --label org.opencontainers.image.source="https://github.com/longlivethehud/sendspin-docker" --platform linux/amd64,linux/arm64,linux/arm/v8,linux/arm/v7 --no-cache-filter upgrade-sendspin -f Dockerfile -t ghcr.io/longlivethehud/sendspin-docker:latest --pull --push .
```

# Update shared manifest after separate image pushs
```
docker buildx imagetools create -t ghcr.io/longlivethehud/sendspin-docker:latest ghcr.io/longlivethehud/sendspin-docker:latest ghcr.io/longlivethehud/sendspin-docker:armhf
```