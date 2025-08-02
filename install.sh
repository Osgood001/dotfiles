#!/bin/bash

set -e

# === 配置区域 ===
DOTFILES_REPO=${1:-"https://github.com/Osgood001/dotfiles.git"}
INSTALL_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%s)"

echo "🌿 Installing dotfiles from $DOTFILES_REPO"

# 1. 克隆或拉取最新 dotfiles
if [ -d "$INSTALL_DIR" ]; then
    echo "📦 Dotfiles repo already exists, pulling latest..."
    git -C "$INSTALL_DIR" pull
else
    git clone "$DOTFILES_REPO" "$INSTALL_DIR"
fi

# 2. 备份原有文件
mkdir -p "$BACKUP_DIR"

for file in .bashrc .vimrc; do
    if [ -f "$HOME/$file" ]; then
        echo "🧷 Backing up $file to $BACKUP_DIR"
        mv "$HOME/$file" "$BACKUP_DIR/"
    fi

    echo "🔗 Linking $file"
    ln -sfn "$INSTALL_DIR/$file" "$HOME/$file"
done

# 3. 可选：安装 Vim 插件（如果你使用 vim-plug）
if grep -q 'Plug' "$HOME/.vimrc"; then
    echo "🎯 Installing vim plugins via vim-plug..."
    vim +PlugInstall +qall || true
fi

echo "✅ Dotfiles installed successfully!"
