ARG BASE_IMAGE=shiftinv/wine:latest
FROM $BASE_IMAGE

USER root
RUN \
 # install xfce
    $APT_CMD update \
 && $APT_CMD install -y xfce4 xfce4-terminal xterm \
 && $APT_CMD purge -y --autoremove pm-utils xscreensaver* \
 \
 # cleanup
 && apt-get clean \
 && find /var/lib/apt/lists/ /tmp/ /var/tmp/ -mindepth 1 -maxdepth 1 -exec rm -rf "{}" +

# install vncserver
RUN wget -qO- https://dl.bintray.com/tigervnc/stable/tigervnc-1.8.0.x86_64.tar.gz | tar xz --strip 1 -C /
USER user

# initialize panel
RUN mkdir -p ~/.config/xfce4/xfconf/xfce-perchannel-xml \
 && cp /etc/xdg/xfce4/panel/default.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml


ENV VNCRESOLUTION=1920x1080
ENV DISPLAY=:1
EXPOSE 5901

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
