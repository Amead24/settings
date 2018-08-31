#!/bin/bash
Usage() {
	( echo "
	-b | --build-binary : to create vim81 binary with python3
	-p | --build-python : to create python dependencies for vim-python
	-r | --build-rust   : to create rust depenencies for vim-rust
	
	"
	) 1>&2
	exit 1
}


build_binary(){
	rm -rf ~/.vim* ~/vim*

	# add library configure support here
	echo 'Installing and removing dependencies...'
	sudo apt-get install -y python-dev python3-dev

	sudo apt-get install -y \
		libncurses5-dev libgnome2-dev libgnomeui-dev \
		libgtk3.0-dev \ # libgtk2.0-dev libatk1.0-dev \
		libbonoboui2-dev \
		libcairo2-dev libx11-dev libxpm-dev libxt-dev

	sudo apt remove -y vim vim-runtime gvim
	sudo apt remove -y vim-tiny vim-common vim-gui-common vim-nox
	sudo upgrade

	#Optional: so vim can be uninstalled again via `dpkg -r vim`
	# sudo apt-get install -y checkinstall 

	sudo rm -rf /usr/local/share/vim /usr/bin/vim

	echo 'Cloning vim from github...'
	cd ~
	git clone https://github.com/vim/vim
	cd vim

	./configure \
		--with-features=huge \
		--enable-multibyte \
		--enable-python3interp \
		--with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
		--enable-gui=auto \
		--enable-cscope \
		--with-compiledby="amead24" \
		--prefix=/usr/local

	make VIMRUNTIMEDIR=/usr/local/share/vim/vim81
	sudo make install
}


build_core(){
	OS_VERSION=$(lsb_release -a | grep -c '18.04.1')
	if [[ OS_VERSION != "1" ]]; then
		echo 'The binary currently only supports Ubuntu 18+'
		exit 111;
	fi

	VIM_VERSION=$(vim --version | head -1 | cut -d ' ' -f 5)
	VIM_HAS_PYTHON3=$(vim --version | grep -c '+python3')
	if [[ $VIM_VERSION != 8.1 || $VIM_HAS_PYTHON3 != "1" ]]; then
		cp ~/settings/vim.bin /usr/local/bin/vim
	fi

	# Clone and install Vundle
	cd ~ && rm -rf ~/.vim/bundle/Vundle.vim
	echo 'Downloading and Installing Vundle...'
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall

	# Copy over vim configuration 
	cd ~/settings
	echo 'Copying personal vim settings...'
	cp -R ./colors/. ~/.vim/colors/
	cp ./vim-conf.vim ~/.vimrc

	# copy over tmux configuration
	echo 'Copying personal tmux settings...'
	cp ./tmux.conf ~/.tmux.conf

	cd ~
}


build_python(){
	python -m pip install flake8
	python -m pip install isort
}


build_rust(){
	rustup component addrustfmt-preview
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
		*)
			Usage
			;;
	esac
	shift
done

sudo build_core
