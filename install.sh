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


build_binary(){
	sudo rm -rf ~/.vim* ~/vim*
	sudo rm -rf /usr/local/share/vim /usr/bin/vim
	
	# add library configure support here
	echo 'Installing and removing dependencies...'
	sudo apt-get install -y \
		libncurses5-dev libgnome2-dev libgnomeui-dev \
		libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
		libcairo2-dev libx11-dev libxpm-dev libxt-dev python3-dev

	sudo apt remove -y \
		vim vim-runtime gvim vim-tiny vim-common vim-gui-common vim-nox
	
	sudo update -y

	echo 'Cloning vim from github...'
	cd ~ &&	git clone https://github.com/vim/vim ~/.vim
	cd ~/.vim && ./configure \
		--with-features=huge \
		--enable-multibyte \
		--enable-python3interp \
		--with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \
		--enable-gui=auto \
		--enable-cscope \
		--with-compiledby="amead24" \
		--prefix=/usr/local

	make VIMRUNTIMEDIR=/usr/local/share/vim/vim81
	cd ~/vim && sudo make install
}


build_core(){
        # this still doesn't prove vim was compiled with python3 support
	# probably should do this inevitably
	VIM_VERSION=$(vim --version | head -1 | cut -d ' ' -f 5)
	VIM_HAS_PYTHON3=$(vim --version | grep -c '+python3')
	if [[ $VIM_VERSION != 8.1 || $VIM_HAS_PYTHON3 != "1" ]]; then
		mkdir -p ~/bin
		cp ~/settings/vim.bin ~/bin/vim
		if ! echo $PATH | grep -q $HOME/bin; then
			echo -e "export PATH='$HOME/bin:$PATH'\n" >> ~/.bashrc
		fi
	fi

	# Clone and install Vundle
	cd ~ && rm -rf ~/.vim/bundle/Vundle.vim
	echo 'Downloading and Installing Vundle...'
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
        sudo vim +PluginInstall +qall

	# Copy over vim configuration
	cd ~/settings && echo 'Copying personal vim settings...'
	cp -R ./colors/. ~/.vim/colors/
	cp ./vim.conf ~/.vimrc
	sudo chown $(id -u):$(id -g) ~/.viminfo

	# copy over tmux configuration
	echo 'Copying personal tmux settings...'
	cp ./tmux.conf ~/.tmux.conf

	cp ./bash_aliases ~/.bash_aliases
	if grep -p '-f ~/.bash_aliases' ~/.bashrc; then
		echo -e 'if [ -f ~/.bash_aliases ]; then\n\t. ~/.bash_aliases\nfi' >> ~/.bashrc
	fi

	# set default editor to vim
	echo "export EDITOR='vim'" >> ~/.bashrc
	echo "export VISUAL='vim'" >> ~/.bashrc

	source ~/.bashrc
	cd ~
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
