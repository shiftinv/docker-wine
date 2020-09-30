#!/bin/bash -xe

mkdir -p ~/.vnc

VNCARGS=(-alwaysshared -depth 24 -geometry "$VNCRESOLUTION")

# set vnc password
if [ -n "$VNCPASSWD" ]; then
    echo "$VNCPASSWD" | vncpasswd -f > ~/.vnc/passwd
    chmod 600 ~/.vnc/passwd
else
    VNCARGS+=(-SecurityTypes None)
fi

# create init script
echo -e "#!/bin/sh\nxrdb ~/.Xresources\nstartxfce4 &" > ~/.vnc/xstartup
chmod +x ~/.vnc/xstartup

# initialize session
touch ~/.Xauthority
rm -rfv /tmp/.X*-lock /tmp/.X11-unix

# start vncserver
vncserver "${VNCARGS[@]}"
tail -F ~/.vnc/*.log
