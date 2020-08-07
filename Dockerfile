FROM ubuntu:18.04

ARG WINE_BRANCH
RUN [ -n "$WINE_BRANCH" ] || { echo "\$WINE_BRANCH is not set" >&2; exit 1; }

ARG DEBIAN_FRONTEND=noninteractive
ENV APT_CMD="apt-get -o=Dpkg::Use-Pty=0 -o=Acquire::ForceIPv4=true"
RUN \
 # install utils
    $APT_CMD update \
 && $APT_CMD install -y wget curl apt-transport-https gnupg nano unzip cabextract p7zip-full winbind \
 \
 # install wine
 && dpkg --add-architecture i386 \
 && curl -fsSL https://dl.winehq.org/wine-builds/winehq.key | apt-key add - \
 && echo "deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main" >> /etc/apt/sources.list.d/wine.list \
 && curl -fsSL https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/Release.key | apt-key add \
 && echo "deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./" >> /etc/apt/sources.list.d/wine.list \
 && $APT_CMD update \
 && $APT_CMD install -y winehq-$WINE_BRANCH \
 \
 # install winetricks
 && wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -O /usr/bin/winetricks \
 && chmod +x /usr/bin/winetricks \
 \
 # cleanup
 && apt-get clean \
 && find /var/lib/apt/lists/ /tmp/ /var/tmp/ -mindepth 1 -maxdepth 1 -exec rm -rf "{}" +

# create new user
RUN adduser --gecos "" --home /home/user --disabled-login user
USER user
WORKDIR /home/user

# set up wine
ENV WINEARCH=win32
ENV WINEPREFIX=/home/user/.wine32
RUN wine wineboot --init \
 && wineserver -w
