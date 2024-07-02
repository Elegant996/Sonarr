# Sonarr
Sonarr is a PVR for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new episodes of your favorite shows and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.

Docker
-----------------------------------------------
This repo will periodically check Sonarr for updates and build a container image from scratch using an Alpine base layout.

For `main` branch releases use:
```
docker pull ghcr.io/elegant996/sonarr:4.0.6.1805
docker pull ghcr.io/elegant996/sonarr:main
```

For `develop` branch pre-releases use:
```
docker pull ghcr.io/elegant996/sonarr:4.0.5.1791
docker pull ghcr.io/elegant996/sonarr:develop
```