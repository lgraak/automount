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
- Template `fstab` entry to use in your containers.

---

## 📂 Folder Structure

```
automount/
├── README.md
├── mount-check.sh
├── mount-check.service
├── mount-check.timer
├── fstab-template.txt
```

---

## 🛠 Setup Instructions

1. **Place the script**
   Copy `mount-check.sh` to `/usr/local/bin/`:

   ```bash
   sudo cp mount-check.sh /usr/local/bin/
   sudo chmod +x /usr/local/bin/mount-check.sh
   ```

2. **Copy the systemd service and timer files**

   ```bash
   sudo cp mount-check.service /etc/systemd/system/
   sudo cp mount-check.timer /etc/systemd/system/
   ```

3. **Enable and start the timer**

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable --now mount-check.timer
   ```

4. **Use this `/etc/fstab` entry** in the container:

   ```
   //jedi-archive.ad.cgillett.com/Media /mnt/Media cifs credentials=/etc/smbcreds,uid=0,iocharset=utf8,vers=3.0,noperm,nofail,x-systemd.automount 0 0
   ```

---

## 💬 Notes

- Adjust `MOUNT_POINT` in `mount-check.sh` if needed.
- Logs are written to `/var/log/mount-check.log` by default.
- `x-systemd.automount` helps avoid boot issues if the share isn't up.

