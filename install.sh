#!/bin/bash

rm -rf ~/.vim*

sudo apt-get remove --purge vim vim-runtime vim-gnome vim-tiny vim-gui-common -y
 
sudo apt-get install liblua5.1-dev luajit libluajit-5.1 python-dev ruby-dev libperl-dev libncurses5-dev libatk1.0-dev libx11-dev libxpm-dev libxt-dev -y

#Optional: so vim can be uninstalled again via `dpkg -r vim`
sudo apt-get install checkinstall -y

sudo rm -rf /usr/local/share/vim /usr/bin/vim

cd ~
git clone https://github.com/vim/vim
cd vim
git pull && git fetch

#In case Vim was already installed
cd src
make distclean
cd ..

./configure \
--enable-multibyte \
--with-ruby-command=/usr/local/bin/ruby \
--enable-pythoninterp=dynamic \
--with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
--enable-python3interp \
--with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
--enable-cscope \
--enable-gui=auto \
--with-features=huge \
--with-x \
--enable-fontset \
--enable-largefile \
--disable-netbeans \
--with-compiledby="amead24" \
--enable-fail-if-missing

make && sudo make install

cd ~/settings
mkdir ~/.vim

# colorschemes
cp -R ./colors/. ~/.vim/colors/

# Clone and install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
echo 'source ./vim-conf.vim' > ~/.vimrc
vim +PluginInstall +qall

# copy over tmux configuration
cp ./tmux.conf ~/.tmux.conf

cd ~
