# Install zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Install alias tips
cd ${ZSH_CUSTOM1:-$ZSH/custom}/plugins
git submodule add https://github.com/djui/alias-tips
git submodule update --init
