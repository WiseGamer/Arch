# Arch Dotfiles - Install Commands

## 📦 Install Packages

### 1. Install yay (AUR Helper)
```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

### 2. Install via yay (AUR)
```bash
yay -S brave-browser bibata-cursor-theme hyprsunset
```

### 3. Install via pacman (Official Repos)
```bash
sudo pacman -S hyprpaper waybar fuzzel
```

---

## 🚀 All-in-One Command
```bash
# Install yay first, then:
yay -S brave-browser bibata-cursor-theme hyprsunset
sudo pacman -S hyprpaper waybar fuzzel
```

---

## 📁 Apply Dotfiles
```bash
git clone https://github.com/WiseGamer/Arch.git ~/dotfiles
cd ~/dotfiles
./install.sh
```



## Kitty Costumization
sudo pacman -S fish ttf-jetbrains-mono-nerd

curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

fisher install IlanCosman/tide@v6

tide configure

## To change kitty into the new thing Use "chsh -s /usr/bin/fish"

