#!/bin/bash


    sudo dnf install zsh -y
	echo "Getting ohmyz.sh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    cd /tmp
    git clone https://github.com/dracula/gnome-terminal
    cd gnome-terminal
    ./install.sh
    eval `dircolors ~/.dir_colors`
    cd ..
    rm -rf /tmp/gnome-terminal
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    curl -fsSL https://raw.githubusercontent.com/curusarn/resh/master/scripts/rawinstall.sh | bash
    sudo dnf install thefuck -y
    sudo chsh -s $(which zsh)
