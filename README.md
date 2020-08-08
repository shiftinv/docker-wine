# docker-wine

Docker images with Wine (win32), optionally including .NET Framework 4.x and/or VNC.

[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/shiftinv/wine?label=docker%20build%20%28wine%29)](https://hub.docker.com/r/shiftinv/wine/builds)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/shiftinv/wine-dotnet?label=docker%20build%20%28wine-dotnet%29)](https://hub.docker.com/r/shiftinv/wine-dotnet/builds)

## Tags

The default Wine branch is `staging`, the default .NET version is `4.8` (unless specified otherwise in tag).

| Type | Image name | Tags |
| ---- | ---------- | ---- |
| Wine only | [`shiftinv/wine:<wine_branch>`](https://hub.docker.com/r/shiftinv/wine/tags) | <ul><li>`latest`, `staging`</li><li>`stable`</li></ul> |
| Wine + VNC | [`shiftinv/wine:<wine_branch>-vnc`](https://hub.docker.com/r/shiftinv/wine/tags?name=vnc) | <ul><li>`vnc`, `staging-vnc`</li><li>`stable-vnc`</li></ul> |
| Wine + .NET | [`shiftinv/wine-dotnet:[<wine_branch>-]<dotnet_version>`](https://hub.docker.com/r/shiftinv/wine-dotnet/tags) | <ul><li>`latest`, `48`, `staging-48`</li><li>`471`, `staging-471`</li><li>`46`, `staging-46`</li><li>`45`, `staging-45`</li><li>`stable-48`</li><li>`stable-471`</li><li>`stable-46`</li><li>`stable-45`</li></ul> |
| Wine + .NET + VNC | [`shiftinv/wine-dotnet:[<wine_branch>-]<dotnet_version>-vnc`](https://hub.docker.com/r/shiftinv/wine-dotnet/tags?name=vnc) | <ul><li>`vnc`, `48-vnc`, `staging-48-vnc`</li><li>`471-vnc`, `staging-471-vnc`</li><li>`46-vnc`, `staging-46-vnc`</li><li>`45-vnc`, `staging-45-vnc`</li><li>`stable-48-vnc`</li><li>`stable-471-vnc`</li><li>`stable-46-vnc`</li><li>`stable-45-vnc`</li></ul> |


## Building

- `make build|build-vnc [WINE_BRANCH=...]`
- `make build-dotnet|build-dotnet-vnc [WINE_BRANCH=...] [DOTNET_VERSION=...]`

