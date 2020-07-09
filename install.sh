#!/bin/bash
Usage() {
	( echo "
	-s | --simple       : only copy over rc files
	-b | --build-binary : to create vim81 binary with python3
	-p | --build-python : to create python dependencies for vim-python
	-r | --build-rust   : to create rust depenencies for vim-rust
	-c | --build-cpp    : to create cpp depenencies for ???
	"
	) 1>&2
	exit 1
}


build_core(){
        CWD=$PWD
        echo "Downloading and Installing Bash-it"
        git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
        bash ~/.bash_it/install.sh --silent

        # Clone and install Vundle
        echo 'Downloading and Installing Vundle...'
        cd ~ && rm -rf ~/.vim/bundle/Vundle.vim
        git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

        echo 'Copying personal vim settings...'
        cp $CWD/settings/vimrc ~/.vimrc
        vim +PluginInstall +qall

        # yay color
        cp -R $CWD/settings/colors/ ~/.vim/colors/
        sudo chown $(id -u):$(id -g) ~/.viminfo

        source "$HOME/.vim/bundle/gruvbox/gruvbox_256palette.sh"

        # copy over tmux configuration & keep color schemes
        echo 'Copying personal tmux settings...'
        cp $CWD/settings/tmux.conf ~/.tmux.conf
        echo "export TERM=screen-256color" >> ~/.bashrc

        # copy over aliases
        cp $CWD/settings/bash_aliases ~/.bash_aliases
        echo "source ~/.bash_aliases" >> ~/.bashrc

        # set default editor to vim
        echo "export EDITOR='vim'" >> ~/.bashrc
        echo "export VISUAL='vim'" >> ~/.bashrc

        source ~/.bashrc
}


build_binary(){
	# add library configure support here
	echo 'Installing dependencies...'
	sudo apt-get -y remove vim
	sudo apt build-dep -y vim
	
	# Python3.6 Support
	sudo add-apt-repository -y ppa:deadsnakes/ppa
	sudo apt update
	sudo apt-get install -y python3.6-dev libpython3.6

	echo 'Reinstalling Vim from Github...'
	sudo rm -rf ~/.vim* ~/vim*
	cd ~ && git clone https://github.com/vim/vim ~/.vim
	cd ~/.vim && ./configure \
		--with-features=huge \
		--enable-multibyte \
		--enable-python3interp vi_cv_path_python3=/usr/bin/python3.6 \
		--with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu \
		--enable-gui=auto \
		--enable-cscope \
		--with-compiledby="amead24" \
		--enable-fail-if-missing \
		--prefix=/usr/local

	make VIMRUNTIMEDIR=/usr/local/share/vim/vim81
	sudo make install
	
	echo "export PATH='/usr/local/bin:$PATH'" >> ~/.bashrc
}


build_python(){
	pip install --upgrade pip
	python -m pip install black flake8 isort
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
                        echo 'Building vim binary with 8.1 and python3 support'
                        build_binary
                        shift
                        ;;
                -p | --build-python)
                        echo 'Building python dependencies for vim'
                        build_python
                        shift
                        ;;
                -r | --build-rust)
                        echo 'Building rustlang dependencies for vim'
                        build_rust
                        shift
                        ;;
                -c | --build-cpp)
                        echo 'Building cpp dependencies for vim'
                        shift
                        ;;
                *)
                        Usage
                        ;;
        esac
done
build_core
