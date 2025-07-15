#!/usr/bin/bash

#set ${SET_X:+-x} -eou pipefail
set -ouex pipefail

trap '[[ $BASH_COMMAND != echo* ]] && [[ $BASH_COMMAND != log* ]] && echo "+ $BASH_COMMAND"' DEBUG

log() {
  echo "=== $* ==="
}

log "Installing RPM packages"

#log "Enable Copr repos"
#
#COPR_REPOS=(
#    pgdev/ghostty
#)
#for repo in "${COPR_REPOS[@]}"; do
#    dnf5 -y copr enable "$repo"
#done

log "Enable repositories"
# Bazzite disabled this for some reason so lets re-enable it again
dnf5 config-manager setopt terra.enabled=1 terra-extras.enabled=1

log "Install layered applications"

# Layered Applications
LAYERED_PACKAGES=(
    konsole
    policycoreutils-gui
    setroubleshoot
    setools-gui
    kjournald
    kde-partitionmanager
)
dnf5 install --setopt=install_weak_deps=False -y "${LAYERED_PACKAGES[@]}"

log "Disable Copr repos as we do not need it anymore"

for repo in "${COPR_REPOS[@]}"; do
    dnf5 -y copr disable "$repo"
done
# Use flatpak steam with some addons instead
# rpm-ostree override remove steam
log "Removing junk packages from Bazzite install"

REMOVED_PACKAGES=(
    ptyxis 
    waydroid 
    waydroid-selinux 
    discover-overlay 
    krfb 
    krfb-libs 
    xwaylandvideobridge 
    plasma-discover-notifier 
    vim-minimal 
    kmousetool 
    kwrite 
    vim-enhanced 
    icoutils 
    filelight
)
dnf5 -y remove "${REMOVED_PACKAGES[@]}"