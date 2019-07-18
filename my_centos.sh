#!/bin/bash

sed -ci 's/^SELINUX=.\+/SELINUX=disabled/' /etc/selinux/config
setenforce 0

yum -y install wget make gcc gcc-c++ vim man ntp xz gzip bzip2 unzip net-tools bind-utils \
traceroute sysstat lsof telnet tcpdump file git openssl-devel bash-completion ca-certificates \
ntpdate acpid

if [ -f /usr/bin/systemctl ]
then
    systemctl enable ntpd && systemctl start ntpd
    systemctl enable ntpdate
    systemctl enable acpid && systemctl start acpid
    systemctl disable firewalld && systemctl stop firewalld
    systemctl disable postfix && systemctl stop postfix
    systemctl disable NetworkManager && systemctl stop NetworkManager
else
    chkconfig ntpd on && service ntpd start
    chkconfig ntpdate on
    chkconfig acpid on && service acpid start
    chkconfig iptables off && service iptables stop
    chkconfig ip6tables off && service ip6tables stop
    chkconfig postfix off && service postfix stop
fi

cat << 'EOF' >> /etc/profile
shopt -s cdspell
umask 0027
alias vi=vim
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
HISTSIZE=65536
HISTTIMEFORMAT="%F %T "
export EDITOR=vim
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

cat << 'EOF' > /etc/cron.daily/yum_makecache
/usr/bin/yum makecache &>/dev/null
EOF
chmod +x /etc/cron.daily/yum_makecache

echo
echo '=== Complete!!! ==='
echo
