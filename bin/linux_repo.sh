#!/usr/bin/env bash

set -e

root="gh-pages"
installers="build/installers"

echo -e "\033[1mGPG import procedure:\033[01;0m"
gpg2 --import headset_priv.asc
echo 'digest-algo sha256' > "$HOME"/.gnupg/gpg.conf
echo '%_gpg_name Headset' > "$HOME"/.rpmmacros
echo -e 'Done'

echo -e "\n\033[1mCreating DEBIAN repository:\033[01;0m"
reprepro -b "$root/debian" includedeb stable "$installers/headset_$VERSION"_amd64.deb
echo -e 'Done'

echo -e "\n\033[1mCreating READHAT repository files:\033[01;0m"
cp "$installers/headset-$VERSION-1.x86_64.rpm" $root/redhat
rpm --addsign "$root/redhat/headset-$VERSION-1.x86_64.rpm"
createrepo "$root/redhat"
gpg --detach-sign --armor "$root/redhat/repodata/repomd.xml"
echo -e 'Done'
