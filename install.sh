#!/bin/bash
rm -rf ~/.vim*
mkdir ~/.vim

# # complete setup - awesome vim
# git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
# # install everything
# sh ~/.vim_runtime/install_awesome_vimrc.sh

# colorscheme - distinguished
cp -R ./colors/. ~/.vim/colors/

# update my preferences
echo 'source ./vim-conf.vim' > ~/.vimrc

# copy over tmux configuration
cp ./tmux.conf ~/.tmux.conf

cd ~
