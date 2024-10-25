for Debian、Ubuntu
```bash
curl -sSL https://raw.githubusercontent.com/GPXCAT/cloud-init/refs/heads/main/user-data_debian.sh | sudo -E bash
```
```bash
sudo apt update && sudo apt install qemu-guest-agent htop
```
for RockyLinux
```bash
curl -sSL https://raw.githubusercontent.com/GPXCAT/cloud-init/refs/heads/main/user-data_rocky.sh | sudo -E bash
```
```bash
# 讓容器內可以ping外面
echo "net.ipv4.ping_group_range = 0   2147483647" >> /etc/sysctl.conf
```