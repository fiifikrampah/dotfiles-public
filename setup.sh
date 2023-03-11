#!/bin/zsh

# Install xcode
sudo xcode-select --install

# Install homebrew and brew packages
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew doctor
brew bundle install --file=./Brewfile

# Copy necessary fonts and other files
mkdir ~/.setup
cp NordDeep.itermcolors Brewfile ~/.setup
cp fonts/* ~/Library/Fonts

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Install alias tips
cd ${ZSH_CUSTOM1:-$ZSH/custom}/plugins
git submodule add -f https://github.com/djui/alias-tips
git submodule update --init

# Copy over vscode settings
cp .vscode/settings.json ~/Library/"Application Support"/Code/User/settings.json

# Copy over vim configuration
cp .vimrc ~/.vimrc

# Copy over zsh configuration
cp .zshrc ~/.zshrc
