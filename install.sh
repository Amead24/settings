#!/bin/bash
rm -rf ~/.vim*
mkdir ~/.vim

# # complete setup - awesome vim
# git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
# # install everything
# sh ~/.vim_runtime/install_awesome_vimrc.sh

# colorscheme - distinguished
cp ./colors/ ~/.vim/colors/

# update my preferences
cp ./vim.conf ~/.vimrc
source ~/.vimrc

# copy over tmux configuration
cp ./tmux.conf ~/.tmux.conf
source ~/.tmux.conf

cd ~
