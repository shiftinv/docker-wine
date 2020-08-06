FROM ubuntu:18.04

ARG WINE_BRANCH=staging

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
 # install DE + firefox + vncserver
 && $APT_CMD install -y xfce4 xfce4-terminal xterm \
 && $APT_CMD purge -y --autoremove pm-utils xscreensaver* \
 \
 # cleanup
 && apt-get clean \
 && find /var/lib/apt/lists/ /tmp/ /var/tmp/ -mindepth 1 -maxdepth 1 -exec rm -rf "{}" +

# install vncserver
RUN wget -qO- https://dl.bintray.com/tigervnc/stable/tigervnc-1.8.0.x86_64.tar.gz | tar xz --strip 1 -C /

# create new user
RUN adduser --gecos "" --home /home/user --disabled-login user
USER user
WORKDIR /home/user

RUN mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml \
 && cp /etc/xdg/xfce4/panel/default.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml

# set up wine
ENV WINEARCH=win32
ENV WINEPREFIX=/home/user/.wine32
RUN wine wineboot --init \
 && wineserver -w


ENV VNCRESOLUTION=1920x1080

EXPOSE 5901

ENV WINE_VNC_ENTRYPOINT=/entrypoint.sh
COPY entrypoint.sh $WINE_VNC_ENTRYPOINT
CMD $WINE_VNC_ENTRYPOINT
