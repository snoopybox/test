#!/bin/bash

PYTHON_VER=3.7.3
PREFIX=/app/python3

mkdir -p $PREFIX
yum -y install wget make gcc xz openssl-devel bzip2-devel ncurses-devel \
gdbm-devel xz-devel sqlite-devel readline-devel tk-devel libffi-devel

wget https://www.python.org/ftp/python/${PYTHON_VER}/Python-${PYTHON_VER}.tar.xz
tar xvf Python-${PYTHON_VER}.tar.xz
cd Python-${PYTHON_VER}
./configure --prefix=${PREFIX} --enable-shared --with-ensurepip=install
CPU_CORE=$(lscpu | awk '/^CPU\(s\):/ {print $NF}')
make -j${CPU_CORE}
make install
cd -
echo "${PREFIX}/lib" > /etc/ld.so.conf.d/python3.conf
ldconfig
echo "export PATH=${PREFIX}/bin:\$PATH" >> /etc/profile
source /etc/profile

python3 -V
