
# Commands for testing configs in podman containers

## Fedora

```bash
podman run --rm -it fedora:latest bash
```

```bash
dnf install -y su git
useradd -m -s /bin/bash testuser
echo "testuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/testuser
sed -i '1i account sufficient pam_permit.so' /etc/pam.d/sudo
echo -e "test1234\ntest1234\n" | passwd testuser
su - testuser
```

```bash
sh -c "$(curl -fsLS https://get.chezmoi.io/lb)" -- init https://github.com/HunterretnuH/Vault.git
.local/bin/chezmoi apply --exclude=encrypted
```

## Ubuntu

```bash
podman run --rm -it ubuntu:latest bash
```

```bash
apt update
apt install -y sudo curl
useradd -m -s /bin/bash testuser
echo "testuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/testuser
echo -e "test1234\ntest1234\n" | passwd testuser
su - testuser
```

```bash
sh -c "$(curl -fsLS https://get.chezmoi.io/lb)" -- init https://github.com/HunterretnuH/Vault.git
.local/bin/chezmoi apply --exclude=encrypted
```
