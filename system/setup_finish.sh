#!/bin/bash

# ===== User Setup =====
# Create user if doesn't exist
if ! id -u obe &>/dev/null; then
  useradd -m -s /usr/bin/zsh -c "Sumit" obe
  # Set empty password (you'll need to set it later with passwd)
  passwd -d obe
fi
# Add to groups
usermod -aG sudo,docker obe

# ===== Install Packages =====
apt install -y \
  evince \
  firefox \
  alacritty \
  git \
  polybar \
  xdotool \
  rofi \
  i3lock \
  x11-xserver-utils \
  x11-utils \
  brightnessctl \
  unzip \
  flameshot \
  peek \
  zsh

# Install Google Chrome
if ! command -v google-chrome &> /dev/null; then
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
  echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
  apt update
  apt install -y google-chrome-stable
fi

# Install Discord
if ! command -v discord &> /dev/null; then
  wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"
  apt install -y /tmp/discord.deb
  rm /tmp/discord.deb
fi

# Install fonts
apt install -y fonts-ipafont fonts-kochi-gothic fonts-kochi-mincho

# Install JetBrains Mono Nerd Font
mkdir -p /usr/local/share/fonts/JetBrainsMono
wget -q -O /tmp/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
unzip -o /tmp/JetBrainsMono.zip -d /usr/local/share/fonts/JetBrainsMono
rm /tmp/JetBrainsMono.zip
fc-cache -f -v

# ===== 1Password =====
# Add the 1Password apt repository
curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/amd64 stable main" > /etc/apt/sources.list.d/1password.list

# Add the debsig-verify policy
mkdir -p /etc/debsig/policies/AC2D62742012EA22/
curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

apt update
apt install -y 1password 1password-cli

# ===== Docker Setup =====
apt install -y docker.io
systemctl enable docker
systemctl start docker

# ===== Final Setup =====
echo "System configuration complete!"
echo "Please set a password for user 'obe' with: passwd obe"
echo "You may need to reboot for all changes to take effect."
