# Remove the old PPA if it exists
sudo add-apt-repository -y -r ppa:chris-lea/node.js
sudo rm -f /etc/apt/sources.list.d/chris-lea-node_js-*.list
sudo rm -f /etc/apt/sources.list.d/chris-lea-node_js-*.list.save
# Add the NodeSource package signing key
curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add -
# Add the desired NodeSource repository
VERSION=node_8.x
DISTRO="$(lsb_release -s -c)"
echo "deb https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee
/etc/apt/sources.list.d/nodesource.list
echo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee -a
/etc/apt/sources.list.d/nodesource.list
# Update package lists and install Node.js and npm
sudo apt update
sudo apt install nodejs -y
sudo apt install npm -y