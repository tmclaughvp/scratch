#!/bin/sh
FIRSTBOOT="/.firstboot"
HOSTNAME_TMPL="ubuntu-template"
OPT=/opt/vp

if [ ! -f "$FIRSTBOOT" -o "$UID" != "0" ]; then
        exit 0
fi

$OPT/bin/ubuntu-post-install.sh
