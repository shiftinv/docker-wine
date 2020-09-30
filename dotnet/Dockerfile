ARG BASE_TAG=latest
FROM shiftinv/wine:$BASE_TAG

USER root
RUN $APT_CMD update \
 && $APT_CMD install -y xvfb \
 && apt-get clean \
 && find /var/lib/apt/lists/ /tmp/ /var/tmp/ -mindepth 1 -maxdepth 1 -exec rm -rf "{}" +
USER user

ARG DOTNET_VERSION
RUN [ -n "$DOTNET_VERSION" ] || { echo "\$DOTNET_VERSION is not set" >&2; exit 1; }
RUN export DISPLAY=:0 \
 && (Xvfb ${DISPLAY} &) \
 # --force: https://bugs.winehq.org/show_bug.cgi?id=49897
 && winetricks -q --verify --force dotnet${DOTNET_VERSION} \
 && rm -rf ~/.cache/winetricks
