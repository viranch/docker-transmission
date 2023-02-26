# docker-transmission
My docker image for a slightly customized Transmission that includes https://github.com/transmission/transmission/pull/1080 but replaces the v3.00 web interface with v2.94's web interface for compatibility with its JS API used in [viranch/docker-tordash](https://github.com/viranch/docker-tordash).

### How to use?

- Install [docker](https://docs.docker.com/installation/#installation).

- Run the container:
```
docker run -d --name transmission -v $PWD/data:/data -p 80:9091 ghcr.io/viranch/transmission
```

- [OPTIONAL] For getting push notifications of download complete on your phone, there are various options:
  - Install the one of the Transmission Android apps ([Remote Transmission](https://play.google.com/store/apps/details?id=com.neogb.rtac) or [Transmission Remote](https://play.google.com/store/apps/details?id=net.yupol.transmissionremote.app)) and configure the remote server, then enable download finished notifications in app settings.
  - Another alternate is to use [Pushover](https://www.pushover.net/). The image has in-built support for Pushover, just declare your API token as `PUSHOVER_APP_TOKEN` environment variable and user key as `PUSHOVER_USER_KEY` env var.
```
docker run -d --name transmission -v $PWD/data:/data -p 80:9091 -e PUSHOVER_APP_TOKEN=XXXXX -e PUSHOVER_USER_KEY=YYYYY ghcr.io/viranch/tv
```

- Navigate to `http://your-ip/`. You can change the port with the `-p` switch, eg: `-p 8000:9091`.
