#!/usr/bin/env python

import subprocess
from datetime import datetime

SECURE_LOG = '/var/log/secure'
IP_CMD = '/usr/sbin/ip'
BLOCK_COUNT = 10


def block_ip(ip):
    cmd = '%s route add blackhole %s' % (IP_CMD, ip,)
    subprocess.call(cmd, shell=True)

def get_blocked_ip():
    cmd = "%s route | awk '/blackhole/ {print $NF}'" % (IP_CMD,)
    res = subprocess.check_output(cmd, shell=True).strip()
    res = res.split('\n')
    res = set(res)
    return res

def get_ip_count():
    ret = {}
    with open(SECURE_LOG) as f:
        for line in f:
            if 'Failed password' in line:
                ip = line.split()[-4]
                ret[ip] = ret.get(ip, 0) + 1
    return ret


blocked_ip = get_blocked_ip()
ip_count = get_ip_count()
for ip, count in ip_count.items():
    if count > BLOCK_COUNT and ip not in blocked_ip:
        print '%s block %s because ssh password failed %d times' % (
                datetime.now().strftime('%F %T.%f'), ip, count,)
        block_ip(ip)
