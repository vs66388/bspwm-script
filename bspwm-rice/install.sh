#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "this script might take some time as it is compiling some fonts and apps used as git to prevent issuses so, try to keep patience " 2>&1
  exit 1
fi



# Update system 
sudo pacman -Syu

# Install Git
if command -v git &>/dev/null; then
  echo "Git v$(git -v | cut -d' ' -f3) is already installed in your system"
else
  sudo pacman -S git -y
fi

# Clone and install Paru
if command -v paru &>/dev/null; then
  echo "Paru $(paru -V | cut -d' ' -f2) is already installed in your system"
else
  if command -v yay &>/dev/null; then
    echo "Yay $(yay -V | cut -d' ' -f2) is installed in your system"
  else
    echo "Neither Paru nor Yay is present in your system."
    echo "Installing Paru..."
    git clone https://aur.archlinux.org/paru-bin.git && cd paru-bin && makepkg -si --noconfirm && cd ..
  fi
fi 

# Making .config and Moving config files and background to Pictures
cd $builddir
mkdir -p /home/$username/.config
mkdir -p /usr/share/sddm/themes
cp -R dotconfig/* ~/.config/
cp wallpaper.jpg  ~/.config/bspwm/
mv user-dirs.dirs ~/.config
chown -R $username:$username /home/$username

# Installing Essential Programs 
paru -S feh bspwm sxhkd alacritty rofi polybar picom-jonaburg-git nemo file-roller lxpolkit dunst pavucontrol neofetch neovim flameshot lxappearance sddm  brave-bin -y
&& paru -S ttf-ms-win11-auto adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts ttf-jetbrains-mono-nerd ttf-jetbrains-mono otf-font-awesome nerd-fonts-sf-mono otf-nerd-fonts-monacob-mono -y  ##fonts

# Installing fonts
cd $builddir 
pacman -S 
chown $username:$username /home/$username/.fonts/*

# Reloading Font
fc-cache -vf

# Enable graphical login and change target from CLI to GUI
systemctl enable sddm

