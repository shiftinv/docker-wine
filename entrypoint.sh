#!/bin/bash -xe

if [ -z "$VNCPASSWD" ] || [ "$VNCPASSWD" == "<unset>" ]; then
    echo "Error: \$VNCPASSWD not set"
    exit 1
fi
mkdir -p ~/.vnc

# set vnc password
echo "$VNCPASSWD" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# create init script
echo -e "#!/bin/sh\nxrdb ~/.Xresources\nstartxfce4 &" > ~/.vnc/xstartup
chmod +x ~/.vnc/xstartup

# initialize session
touch ~/.Xauthority
rm -rfv /tmp/.X*-lock /tmp/.X11-unix

# start vncserver
vncserver -alwaysshared -depth 24 -geometry "$VNCRESOLUTION"
tail -F ~/.vnc/*.log
