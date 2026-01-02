# Update shared manifest after image push
```
docker buildx imagetools create -t ghcr.io/longlivethehud/sendspin-docker:latest ghcr.io/longlivethehud/sendspin-docker:aarch64 ghcr.io/longlivethehud/sendspin-docker:amd64 ghcr.io/longlivethehud/sendspin-docker:armhf
```