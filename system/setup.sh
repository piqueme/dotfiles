#!/bin/bash
set -e

# System Configuration Script for Ubuntu

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

echo "Starting system configuration..."

# ===== System Setup =====

# Enable NetworkManager
apt update
apt install -y network-manager
systemctl enable NetworkManager
systemctl start NetworkManager

# Set timezone
timedatectl set-timezone America/Los_Angeles

# Configure locale
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8 LC_ADDRESS=en_US.UTF-8 LC_IDENTIFICATION=en_US.UTF-8 \
  LC_MEASUREMENT=en_US.UTF-8 LC_MONETARY=en_US.UTF-8 LC_NAME=en_US.UTF-8 \
  LC_NUMERIC=en_US.UTF-8 LC_PAPER=en_US.UTF-8 LC_TELEPHONE=en_US.UTF-8 LC_TIME=en_US.UTF-8

# ===== File System Support =====
apt install -y ntfs-3g

# ===== Display Server & Window Manager =====
apt install -y xorg i3 feh

# Create i3 autostart directory if it doesn't exist
mkdir -p /etc/X11/xinit/xinitrc.d/

# Create a script to run on X session start
cat > /etc/X11/xinit/xinitrc.d/99-user-xmodmap.sh << 'EOF'
#!/bin/bash
# Load user default Xmodmap for keyboard layout adjustments
[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap

# Setup background image on login
if [ -f ~/.wallpaper/background_image.jpeg ]; then
  feh --bg-scale ~/.wallpaper/background_image.jpeg
fi
EOF

chmod +x /etc/X11/xinit/xinitrc.d/99-user-xmodmap.sh

# Configure default X session to use i3
mkdir -p /usr/share/xsessions
cat > /usr/share/xsessions/i3.desktop << EOF
[Desktop Entry]
Name=i3
Comment=improved dynamic tiling window manager
Exec=i3
Type=Application
X-LightDM-DesktopName=i3
DesktopNames=i3
EOF

# ===== Audio Setup =====
apt install -y pipewire pipewire-pulse pipewire-alsa wireplumber rtkit

# Enable PipeWire services for the user
mkdir -p /etc/pipewire
cp -r /usr/share/pipewire/* /etc/pipewire/

systemctl --user enable pipewire.socket
systemctl --user enable pipewire-pulse.socket
systemctl --user enable wireplumber.service

# ===== User Setup =====
# Create user if doesn't exist
if ! id -u obe &>/dev/null; then
  useradd -m -s /usr/bin/zsh -c "Sumit" obe
  # Set empty password (you'll need to set it later with passwd)
  passwd -d obe
fi
# Add to groups
usermod -aG sudo,docker obe

# Add sources for Wezterm terminal emulator
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg

# ===== Install Packages =====
apt install -y \
  evince \
  firefox \
  wezterm \
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
  zsh \
  xclip

# ====== Symlink System App Configs ======
if [ -d ~/Projects/dotfiles/i3 ]; then 
  ln -s ~/Projects/dotfiles/i3 ~/.config/i3
fi
if [ -d ~/Projects/dotfiles/polybar ]; then 
  ln -s ~/Projects/dotfiles/polybar ~/.config/polybar
fi
if [ -d ~/Projects/dotfiles/rofi ]; then 
  ln -s ~/Projects/dotfiles/rofi ~/.config/rofi
fi

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
apt install -y fonts-ipafont

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
