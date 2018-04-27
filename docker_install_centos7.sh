#!/bin/bash
curl https://download.docker.com/linux/centos/docker-ce.repo > /etc/yum.repos.d/docker-ce.repo
yum install -y --enablerepo=extras yum-utils device-mapper-persistent-data lvm2 docker-ce yum-plugin-ovl
systemctl enable docker
systemctl start docker
