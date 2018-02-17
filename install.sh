#!/bin/bash
set -e

cd ~
rm -rf .vim*
mkdir .vim

# colorscheme - distinguished 
git clone https://github.com/Lokaltog/vim-distinguished.git .vim/colors/
cp .vim/colors/colors/distinguished.vim .vim/colors/distinguished.vim
rm -rf .vim/colors/colors

# complete setup - awesome vim
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime

# update my preferences
cp ~/setup/config/settings.vim .vim_runtime/my_configs.vim

# install everything
sh ~/.vim_runtime/install_awesome_vimrc.sh
