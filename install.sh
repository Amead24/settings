#!/bin/bash
cd ~
rm -rf .vim*
mkdir .vim

# colorscheme - distinguished 
git clone https://github.com/Lokaltog/vim-distinguished.git distinguished
cp --parents distinguished/colors/distinguished.vim .vim/colors/distinguished.vim
rm -rf distinguished

# complete setup - awesome vim
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime

# update my preferences
cp settings/my_configs.vim .vim_runtime/my_configs.vim

# install everything
sh ~/.vim_runtime/install_awesome_vimrc.sh

# copy over tmux configuration
cp settings/.tmux.conf ~/.tmux.conf
