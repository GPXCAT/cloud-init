#!/bin/bash

# 安裝常用套件
sudo dnf install -y epel-release
sudo dnf install -y git htop

# 建立使用者帳號
sudo useradd www-user

# 安裝 Docker
sudo dnf install -y fuse-overlayfs iptables slirp4netns
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 不要從 root 模式啟動 Docker
sudo systemctl disable docker.service
sudo systemctl disable docker.socket

# 允許 www-user 在登出後繼續執行
sudo loginctl enable-linger www-user

# Docker Rootless 好像必需使用者本人登入才能使用，所以寫到bashrc
# https://docs.docker.com/engine/security/rootless/
export DOKCER_ROOTLESS_CDOE='aWYgWyAhIC1lICRIT01FLy5jb25maWcvc3lzdGVtZC91c2VyL2RvY2tlci5zZXJ2aWNlIF0KdGhlbgogICAgZWNobyAiU2V0dGluZyBEb2NrZXIgcm9vdGxlc3MuLi4iCiAgICAvdXNyL2Jpbi9kb2NrZXJkLXJvb3RsZXNzLXNldHVwdG9vbC5zaCBpbnN0YWxsCmZpCg=='
sudo -E DOKCER_ROOTLESS_CDOE=${DOKCER_ROOTLESS_CDOE} sh -c 'echo ${DOKCER_ROOTLESS_CDOE} | base64 --decode >> /home/www-user/.bashrc'

# Changing the network stack (這樣才能讓Docker內取得外界連線的IP資訊)
# https://rootlesscontaine.rs/getting-started/docker/#changing-the-network-stack
sudo mkdir -p /home/www-user/.config/systemd/user/docker.service.d/
export DOKCER_SLIRP4NETNS_CDOE='W1NlcnZpY2VdCkVudmlyb25tZW50PSJET0NLRVJEX1JPT1RMRVNTX1JPT1RMRVNTS0lUX1BPUlRfRFJJVkVSPXNsaXJwNG5ldG5zIgo='
sudo -E DOKCER_SLIRP4NETNS_CDOE=${DOKCER_SLIRP4NETNS_CDOE} sh -c 'echo ${DOKCER_SLIRP4NETNS_CDOE} | base64 --decode >> /home/www-user/.config/systemd/user/docker.service.d/override.conf'

# Docker Rootless 的相關設定
USER_ID=$(id -u www-user)
sudo -E USER_ID=${USER_ID}  sh -eux <<EOF
    # Load ip_tables module
    modprobe ip_tables

    # Grant Rootless Docker Permission (for rootless mode):
    setcap cap_net_bind_service=+ep /usr/bin/rootlesskit

    # Adjust sysctl Configuration:
    echo "net.ipv4.ip_unprivileged_port_start = 80" >> /etc/sysctl.conf
    echo "net.ipv4.ping_group_range = 0   2147483647" >> /etc/sysctl.conf
    sysctl -p /etc/sysctl.conf

    # set variables
    echo "export DOCKER_HOST=unix:///run/user/${USER_ID}/docker.sock" >> /home/www-user/.bashrc
EOF

# set dir permissions
sudo mkdir -p /home/web
sudo chown -R www-user:www-user /home/web

# put key pair for `www-user`
sudo mkdir -p /home/www-user/.ssh/
sudo bash -c "echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBXSRs3ftt0rbcSZiRIxanng0ArxQJtMQ10l8J+1UhNi www-user@localhost' >> /home/www-user/.ssh/authorized_keys"
sudo chmod 600 /home/www-user/.ssh/authorized_keys

export BASH_STYLE_CDOE='UFMxPSdcW1wwMzNbMDE7MzJtXF1cdUBcaFxbXDAzM1swMTszNG1cXSBcd1xbXDAzM1szMW1cXSQoZ2l0X2JyYW5jaClcW1wwMzNbMDE7MzRtXF0gXCRcW1wwMzNbMDBtXF0gJwpmdW5jdGlvbiBnaXRfYnJhbmNoIHsKICAgIHJlZj0kKGdpdCBzeW1ib2xpYy1yZWYgSEVBRCAyPiAvZGV2L251bGwpIHx8IHJldHVybjsKICAgIGVjaG8gIigiJHtyZWYjcmVmcy9oZWFkcy99IikiOwp9'
sudo -E BASH_STYLE_CDOE=${BASH_STYLE_CDOE} sh -c 'echo ${BASH_STYLE_CDOE} | base64 --decode >> /root/.bashrc'
sudo -E BASH_STYLE_CDOE=${BASH_STYLE_CDOE} sh -c 'echo ${BASH_STYLE_CDOE} | base64 --decode >> /home/www-user/.bashrc'
sudo -E BASH_STYLE_CDOE=${BASH_STYLE_CDOE} sh -c 'echo ${BASH_STYLE_CDOE} | base64 --decode >> /home/rocky/.bashrc'

sudo chown -R www-user:www-user /home/www-user/
