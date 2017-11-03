#!/bin/bash

sed -ci 's/^SELINUX=.\+/SELINUX=disabled/' /etc/selinux/config
setenforce 0

sed -i '/tsflags=nodocs/d' /etc/yum.conf

yum -y install wget make gcc gcc-c++ vim man ntp xz gzip bzip2 net-tools bind-utils \
traceroute sysstat lsof telnet tcpdump file git

if [ -f /usr/bin/systemctl ]
then
    systemctl enable ntpd
    systemctl disable firewalld
    systemctl disable postfix
    systemctl start ntpd
    systemctl stop firewalld
    systemctl stop postfix
else
    chkconfig ntpd on
    chkconfig iptables off
    chkconfig ip6tables off
    chkconfig postfix off
    service ntpd start
    service iptables stop
    service ip6tables stop
    service postfix stop
fi

cat << 'EOF' >> /etc/profile
shopt -s cdspell
umask 0027
alias vi=vim
export EDITOR=vim
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
EOF

cat << 'EOF' >> /etc/vimrc
set ic ai et ts=4 sts=4 sw=4 pastetoggle=<F2>
EOF

cat << 'EOF' >> /etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
sysctl -p > /dev/null

cat << 'EOF' >> /etc/security/limits.conf
*       soft    nproc   65536
*       hard    nproc   65536
*       soft    nofile  655360
*       hard    nofile  655360
EOF
