#!/bin/bash
set -e

cd ~
mkdir .vim

# colorscheme - distinguished 
git clone https://github.com/Lokaltog/vim-distinguished.git .vim/colors/
cp .vim/colors/distinguished/colors/distinguished.vim .vim/colors/distinguished.vim

# plugin - surround
# git clone https://github.com/tpope/vim-surround.git .vim/bundle/surround

# complete setup - awesome vim
git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime

# update my preferences
rm .vim_runtime/my_configs.vim
cp config/settings.vim .vim_runtime/my_configs.vim

# install everything
sh ~/.vim_runtime/install_awesome_vimrc.sh
