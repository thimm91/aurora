#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# dnf5 install -y tmux 

# Netbird client for VPN
tee /etc/yum.repos.d/netbird.repo <<EOF
[netbird]
name=netbird
baseurl=https://pkgs.netbird.io/yum/
enabled=1
gpgcheck=0
gpgkey=https://pkgs.netbird.io/yum/repodata/repomd.xml.key
repo_gpgcheck=1
EOF

# install extra packages from fedora repos
rpm-ostree install -y \
    netbird \
    netbird-ui

rpm --import https://download.owncloud.com/desktop/ownCloud/stable/latest/linux/Fedora_41/repodata/repomd.xml.key
dnf config-manager addrepo --from-repofile=https://download.owncloud.com/desktop/ownCloud/stable/latest/linux/Fedora_41/owncloud-client.repo
dnf install -y owncloud-client 

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

# systemctl enable podman.socket

# Clean up
dnf5 autoremove -y
dnf5 clean -y all
