#!/bin/sh

# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/set-time.html

echo "replace ntpd with chrony"
yum erase -y ntp*
yum install -y chrony
chkconfig chronyd on
service chronyd start

echo "Configure ntp server"
grep -q "^server 169.254.169.123" /etc/chrony.conf || echo "server 169.254.169.123 prefer iburst" >> /etc/chrony.conf
