# Automount Helper for Samba Shares

This folder contains a simple script and systemd service/timer unit to help automatically ensure that a CIFS mount (e.g., from a Samba server like `jedi-archive`) remains mounted inside LXC containers or VMs.

This is useful when:
- You're mounting network shares inside containers
- Shares occasionally go offline or disconnect
- You want an automatic way to remount without rebooting or user intervention

---

## ✅ What's Included

- `mount-check.sh`: A script to verify that a given mount point is active. If not, it attempts to remount it.
- `mount-check.service`: A systemd service unit to run the script.
- `mount-check.timer`: A systemd timer unit to run the service every 10 minutes.
- `install-automount.sh`: A setup script to install and enable everything automatically.
- `fstab-template.txt`: A reference fstab line for Samba mounts.

---

## 🛠️ Setup Instructions

### 1. Clone This Repository

#### 🐧 First, install Git:

- **Debian/Ubuntu**:
  ```bash
  sudo apt update && sudo apt install git
  ```

- **Arch Linux**:
  ```bash
  sudo pacman -S git
  ```

#### 📥 Then clone the repo:

```bash
git clone git@github.com:lgraak/automount.git
cd automount
```

---

### 2. Run the Installation Script

```bash
chmod +x install-automount.sh
./install-automount.sh
```

This script will:
- Copy `mount-check.sh` to `/usr/local/bin`
- Install and enable the systemd service and timer
- Add the fstab entry for the Samba share if not already present
- Reload systemd and start the timer

---

## 📂 Folder Structure

```
automount/
├── README.md
├── fstab-template.txt
├── install-automount.sh
├── mount-check.service
├── mount-check.sh
├── mount-check.timer
```

---

## 📄 fstab Entry Example

Add this to your `/etc/fstab` (the script will try to do it for you):

```
/etc/fstab:
//jedi-archive.ad.cgillett.com/Media /mnt/Media cifs credentials=/etc/smbcreds,uid=0,iocharset=utf8,vers=3.0,noperm,nofail,x-systemd.automount 0 0
```

---

## 💬 Notes

- Adjust `MOUNT_POINT` in `mount-check.sh` if you want a different mount target.
- Logs will be written to `/var/log/mount-check.log`.
- The timer checks every 10 minutes and attempts a remount if needed.
- You can check the timer with:
  ```bash
  systemctl list-timers --all | grep mount-check
  journalctl -u mount-check.service
  ```

