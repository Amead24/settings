#!/bin/bash
cd ~
mkdir .vim

# colorscheme - distinguished 
git clone https://github.com/Lokaltog/vim-distinguished.git .vim/colors/
cp .vim/colors/distinguished/colors/distinguished.vim .vim/colors/distinguished.vim

# plugin - surround
git clone https://github.com/tpope/vim-surround.git .vim/bundle/surround

source ~/
