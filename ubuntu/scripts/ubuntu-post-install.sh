#!/bin/sh
OPT=/opt/vp
FIRSTBOOT="/.firstboot"

# Set hostname.
if [ "$(hostname)" = "$HOSTNAME_TMPL" ]; then
        $OPT/bin/set-network.sh
fi

# Remove SSH keys generated by install
find /etc/ssh -type f -name 'ssh_host_*' -print0 | xargs -0 rm
for _t in rsa dsa ecdsa ; do
        ssh-keygen -f /etc/ssh/ssh_host_${_t}_key -t ${_t} -N ''
done