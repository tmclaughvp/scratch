#!/bin/sh

F="/tmp/setup-eth0.out"
DNS=""
DNS_SEARCH=""

# Get info from user
# ascii-lines looks terible on the console but non-ascii looks terrible
# in SSH sometimes.
if [ -n $SSH_TTY ]; then
        ascii_lines=""
else
        ascii_lines="--ascii-lines"
fi

dialog $ascii_lines --backtitle "Network Setup" \
        --title "Network Configuration" \
        --form "\nPlease enter the network configuration for eth0:" 14 64 6 \
        "fqdn:" 1 1 "" 1 16 48 0 \
        "IP Address:" 2 1 "" 2 16 48 0 \
        "Network Mask:" 3 1 "" 3 16 48 0 \
        "Gateway:" 4 1 "" 4 16 48 0 \
        "DNS Server:" 5 1 "$DNS" 5 16 48 0 \
        "DNS Search:" 6 1 "$DNS_SEARCH" 6 16 48 0 \
        2> $F

# Read contents of file.
fqdn=$(awk "NR==1"i $F)
hostname=$(echo $fqdn | cut -d '.' -f 1)
ip=$(awk "NR==2" $F)
netmask=$(awk "NR==3" $F)
gateway=$(awk "NR==4" $F)
dns=$(awk "NR==5" $F)
dns_search=$(awk "NR==6" $F)

# Set hostname
hostname $hostname
echo $hostname > /etc/hostname
sed -i "s,.*$HOSTNAME_TMPL.*,$ip\t$fqdn $hostname," /etc/hosts

# Configure networking
sed -i '/^iface eth0/d' /etc/network/interfaces
cat << EOF >> /etc/network/interfaces
iface eth0 inet static
        address $ip
        netmask $netmask
        gateway $gateway
        dns-nameservers $dns
        dns-search $dns_search
EOF

# Restart networking
/etc/init.d/networking restart

rm $F

