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