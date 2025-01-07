# 🍓 Raspberry Pi-based TorrentBox and NAS
A personal project implementing a TorrentBox for file downloading and a Network Attached Storage (NAS) using a Raspberry Pi. The system runs on a Raspberry Pi 4B with an external SSD for primary storage and an external HDD for backups, all connected through a powered USB hub for reliability (big SSDs/HDDs can't be powered by the RPi).

## System overview
The system combines several components to create a secure download and storage solution:
- The download system is built around the [Transmission daemon](https://transmissionbt.com/), which handles torrent management through its web interface. This allows convenient remote management of downloads from any device on your network.
- All download traffic is routed through a VPN connection, with a kill switch mechanism that automatically shuts down Transmission if the VPN fails. This ensures downloads only occur through the encrypted VPN tunnel.
- For security, the system employs real-time virus scanning using [ClamAV](https://www.clamav.net/). Every downloaded file is automatically scanned, with suspicious files moved to quarantine immediately. The VPN connection is continuously monitored, with automatic shutdown of sensitive services if the connection drops.
- Storage is handled through both [Samba](https://www.samba.org/) and NFS protocols, allowing flexible access from different devices and operating systems. The system performs daily incremental backups to an external drive, maintaining a log of all backup operations and their status.

## Implementation details
### Core scripts
1. [VPN check script](https://github.com/96francesco/rpi-torrentbox-nas/blob/main/scripts/vpn-check.sh) - monitors the VPN connection and implements the kill switch
2. [Downloads scanner](https://github.com/96francesco/rpi-torrentbox-nas/blob/main/scripts/scan-downloads.sh) - real-time virus scanning of downloaded files
3. [Backup script](https://github.com/96francesco/rpi-torrentbox-nas/blob/main/scripts/nas-backup.sh) - Daily incremental backups of NAS contents

### System services
The functionalities were automated through **systemd** services.
