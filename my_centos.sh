#!/bin/bash

ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

sed -ci 's/^SELINUX=.\+/SELINUX=disabled/' /etc/selinux/config
setenforce 0

yum -y install wget make gcc gcc-c++ vim man ntp xz gzip bzip2 unzip net-tools bind-utils \
traceroute sysstat lsof telnet tcpdump file git openssl-devel bash-completion ca-certificates \
ntpdate acpid psmisc

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
fs.file-max = 3264516

kernel.threads-max = 513258

net.core.netdev_max_backlog = 8192
net.core.somaxconn = 4096

net.core.rmem_default = 4194304
net.core.rmem_max = 25165824
net.core.wmem_default = 4194304
net.core.wmem_max = 25165824

net.ipv4.tcp_mem = 8388608 8388608 8388608
net.ipv4.tcp_rmem = 4096 87380 25165824
net.ipv4.tcp_wmem = 4096 65536 25165824

net.ipv4.ip_local_port_range = 10000 65535

net.ipv4.tcp_max_syn_backlog = 4096
net.ipv4.tcp_max_tw_buckets = 11520000

net.ipv4.tcp_timestamps = 1

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
