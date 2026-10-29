#!/bin/bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║          Hyprland + Waybar Dotfiles Installer               ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo -e "${GREEN}Source: ${DOTFILES_DIR}${NC}"
echo -e "${GREEN}Target: ${CONFIG_DIR}${NC}"
echo ""

# Create .config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Function to install a config directory/file
install_config() {
    local src="$1"
    local dest="$2"
    local name="$3"

    if [[ ! -e "$src" ]]; then
        echo -e "${YELLOW}⚠ Source not found: $src (skipping $name)${NC}"
        return 0
    fi

    if [[ -e "$dest" || -L "$dest" ]]; then
        if [[ -L "$dest" ]]; then
            echo -e "${YELLOW}🔗 Removing existing symlink: $dest${NC}"
            rm "$dest"
        else
            local backup_name="$dest.backup.$(date +%Y%m%d_%H%M%S)"
            echo -e "${YELLOW}📦 Backing up existing $name: $dest → $backup_name${NC}"
            mv "$dest" "$backup_name"
        fi
    fi

    echo -e "${GREEN}🔗 Linking $name...${NC}"
    ln -sf "$src" "$dest"
}

echo -e "${BLUE}📁 Installing Hyprland configs...${NC}"
install_config "$DOTFILES_DIR/hypr" "$CONFIG_DIR/hypr" "Hyprland"

echo -e "${BLUE}📁 Installing Waybar configs...${NC}"
install_config "$DOTFILES_DIR/waybar" "$CONFIG_DIR/waybar" "Waybar"

echo ""
echo -e "${BLUE}🔄 Reloading services...${NC}"

# Reload Hyprland if running
if command -v hyprctl &> /dev/null; then
    if hyprctl instances 2>/dev/null | grep -q "Instance"; then
        echo -e "${GREEN}🔄 Reloading Hyprland...${NC}"
        hyprctl reload
    else
        echo -e "${YELLOW}⚠ Hyprland not running (skipping reload)${NC}"
    fi
else
    echo -e "${YELLOW}⚠ hyprctl not found (skipping Hyprland reload)${NC}"
fi

# Restart Waybar if running
if pgrep -x waybar > /dev/null; then
    echo -e "${GREEN}🔄 Restarting Waybar...${NC}"
    pkill waybar
    sleep 0.5
    if command -v waybar &> /dev/null; then
        waybar & disown
        echo -e "${GREEN}✅ Waybar restarted${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Waybar not running (skipping restart)${NC}"
fi

echo ""
echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                    ✅ Installation Complete!                 ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo -e "${GREEN}Your Hyprland + Waybar configs are now installed!${NC}"
echo ""
echo -e "${BLUE}📝 Next steps:${NC}"
echo -e "  • Edit configs in: ${DOTFILES_DIR}/hypr/ and ${DOTFILES_DIR}/waybar/"
echo -e "  • Re-run this script to apply changes: ${DOTFILES_DIR}/install.sh"
echo -e "  • Commit changes: cd ${DOTFILES_DIR} && git add . && git commit -m 'update' && git push"
echo ""