# sendspin-docker
sendspin-docker is a fully dockerized instance of the cli player from [Sendspin](https://www.sendspin-audio.com/), the in-development synchronized playback protocol from the Open Home Foundaton, and new default player provider  used in [Music Assistant](https://www.music-assistant.io/).

The docker container runs the Python [sendspin-cli](https://github.com/Sendspin/sendspin-cli) in headless mode. It will work natively as a player for [Music Assistant](https://www.music-assistant.io/) v2.7 and greater.

# The basics
- prebuilt Debian Trixie containers for amd64, arm64 and armvh
- should run on Raspberry Pi 2 and newer
- plays to Alsa CARD "0" by default
- suppoerts mDNS discovery of a local sendspin server (running by default in Music Assistant)
- docker-compose.yml provided to simplify startup, but default sendspin command flags can be overridden to run any supported flags

# Getting started
1. Install docker [the official way](https://docs.docker.com/engine/install/)
2. Clone this repository locally
3. From the root of the cloned repository, run the container using docker Compose
```bash 
docker compose up
```

# Runtime customization
The only flag passsed to sendspin by defualt is *--headless*. You can override this and pass any sendspin flag you like by either editing **docker-compose.yml** or using `docker compose run sendspin <some flags>`. For example, to see runnnig sendspin servers on your local network...
```bash
docker compose run sendspin --list-servers
```
>Note: every unique `docker compose run` command creates a new container instance.

The **docker-compose.yml** also specifies which alsa sound card to expose to the container. The default is CARD="0".

# Anyway, why dockerize Sendspin?
The sendspin-cli requires Python >=3.12 and PyAV, both of which can be challenging to set up correctly on older Debian and Ubuntu based distros, requiring a lot of lib*something*-dev packages. Couple that with the fact that many installs of FFmpeg are a hot mess, and the reuslt is that just running `pipx install sendspin` is not a sure thing. 
