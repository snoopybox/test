#!/bin/bash

sed -ci 's/^SELINUX=.\+/SELINUX=disabled/' /etc/selinux/config
setenforce 0

if [ -f /usr/bin/systemctl ]
then
    systemctl disable firewalld
    systemctl disable postfix
    systemctl stop firewalld
    systemctl stop postfix
else
    chkconfig iptables off
    chkconfig ip6tables off
    chkconfig postfix off
    service iptables stop
    service ip6tables stop
    service postfix stop
fi

yum -y install wget make gcc gcc-c++ vim man

cat << 'EOF' >> /etc/profile
alias vi=vim
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
EOF

cat << 'EOF' >> /etc/vimrc
set ic ai et ts=4 sts=4
EOF

. /etc/profile
