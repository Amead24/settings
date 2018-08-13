#!/bin/bash
rm -rf ~/.vim*
mkdir ~/.vim

# colorscheme - distinguished
cp -R ./colors/. ~/.vim/colors/

# Clone and install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
echo 'source ./vim-conf.vim' > ~/.vimrc
vim +PluginInstall +qall

# copy over tmux configuration
cp ./tmux.conf ~/.tmux.conf

cd ~
