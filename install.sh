#!/bin/bash

Usage() {
	( echo "
	-b | --build-binary : to create vim81 binary with python3
	-p | --build-python : to create python dependencies for vim-python
	-r | --build-rust   : to create rust depenencies for vim-rust
	-c | --build-cpp    : to create cpp depenencies for ???
	"
	) 1>&2
	exit 1
}


build_core(){
	REPO_DIR=$PWD
	
	# Clone and install Vundle
	echo 'Downloading and Installing Vundle...'
	cd ~ && rm -rf ~/.vim/bundle/Vundle.vim
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
        sudo vim +PluginInstall +qall

	# Copy over vim configuration
	echo 'Copying personal vim settings...'
	cp $REPO_DIR/colors/* ~/.vim/colors/*
	cp $REPO_DIR/vim.conf ~/.vimrc
	sudo chown $(id -u):$(id -g) ~/.viminfo

	# copy over tmux configuration
	echo 'Copying personal tmux settings...'
	cp $REPO_DIR/tmux.conf ~/.tmux.conf

	cp $REPO_DIR/bash_aliases ~/.bash_aliases
	if grep -p '-f ~/.bash_aliases' ~/.bashrc; then
		echo -e 'if [ -f ~/.bash_aliases ]; then\n\t. ~/.bash_aliases\nfi' >> ~/.bashrc
	fi

	# set default editor to vim
	echo "export EDITOR='vim'" >> ~/.bashrc
	echo "export VISUAL='vim'" >> ~/.bashrc

	source ~/.bashrc && cd $REPO_DIR
}


build_binary(){
	REPO_DIR=$PWD
	
	# add library configure support here
	echo 'Installing dependencies...'
	sudo apt-get install -y \
		libncurses5-dev libgnome2-dev libgnomeui-dev \
		libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
		libcairo2-dev libx11-dev libxpm-dev libxt-dev python3-dev
		
	sudo apt-get update -y

	echo 'Reinstalling Vim from Github...'
	sudo rm -rf ~/.vim* ~/vim*
	cd ~ &&	git clone https://github.com/vim/vim ~/.vim
	cd ~/.vim && ./configure \
		--with-features=huge \
		--enable-multibyte \
		--enable-python3interp \
		--with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
		--enable-gui=auto \
		--enable-cscope \
		--with-compiledby="amead24" \
		--prefix=$HOME/bin/vim

	make
	sudo make install
	
	cd $REPO_DIR
}


build_python(){
	if ! dpkg -l | grep -q 'python'; then
		sudo apt-get install python3 -y
	fi
	
	if ! dpkg -l | grep -q pip3; then
		sudo apt-get install python3-pip -y
	fi
	
	python3 -m pip install black flake8 isort
}


build_rust(){
	rustup component addrustfmt-preview
}


build_cpp(){
	sudo apt-get install astyle
}


while [ "$1" != "" ]; do
	case $1 in
		-b | --build-binary)
			shift
			echo 'Building vim binary with 8.1 and python3 support'
			build_binary
			;;
		-p | --build-python)
			shift
			echo 'Building python dependencies for vim'
			build_python
			;;
		-r | --build-rust)
			shift
			echo 'Building rustlang dependencies for vim'
			build_rust
			;;
		-c | --build-cpp)
			shift
			echo 'Building cpp dependencies for vim'
			;;
		*)
			Usage
			;;
	esac
	shift
done

build_core
