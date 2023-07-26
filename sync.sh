#!/bin/bash
#----------
user="icat"
home="/home/icat"
inc=1
#----------
RED="\e[95m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[36m"
ENDCOLOR="\e[0m"
#----------
usage() {
	echo -e "sync (1.00)\nAuto manager for your DE into a full bloom Qtile WM\n"
	echo -e "USAGE:\n  bash sync.sh [OPTIONS]\n"	
	echo -e "OPTIONS:\
         \n  -s (sync)\n\tSyncing local dotfiles to the repository\
         \n  -r (run)\n\tInstalling all dependencies, as well as debloating the host\
         \n  -h (help)\n\tDisplaying possible usage of the script"; }
#----------
sync() {
	prc=2
	checker
	backup_sync; }
run() {
	prc=9
	checker	
	install_app
	install_qtile
	import_config; }
#----------
checker() {
	echo -e "[${BLUE}$inc/$prc${ENDCOLOR}]: Checking basic requirements ..."
	[[ ! -d "./.config" ]] && mkdir .config
	[[ ! -d "./.home" ]] && mkdir .home	
	[[ ! -d "./.etc" ]] && mkdir .etc
	if [[ $(id -u) -ne 0 ]]; then 
		echo -e "[${RED}ext${ENDCOLOR}]: Please run the script in a root privilege"
		exit 0
		fi
	((inc++)); }
#----------
backup_sync() {
	echo -e "[${BLUE}$inc/$prc${ENDCOLOR}]: Copying dotfiles from ${GREEN}$home${ENDCOLOR} to ${GREEN}dotfile/.config${ENDCOLOR} ..."
	bu_files=(.bash_history .bashrc .gitconfig .profile .selected_editor .info .dialogrc)
	for i in ${bu_files[@]}; do
		cp $home/$i ./.home
		done
		sudo cp /usr/share/xsessions/qtile.desktop ./.home
	bu_dirs=(asciinema gtk-3.0 kitty neofetch qtile ranger sublime-text-3)
	for j in ${bu_dirs[@]}; do
		cp -r $home/.config/$j ./.config
		done
	((inc++)); }
#----------
install_app() {
	echo -e "[${BLUE}$inc/$prc${ENDCOLOR}]: Installing essential programs & utilities ..."	
	apps="neofetch spd python3-pip python3-venv bat ranger git git-lfs openvpn podman compton exa hugo kitty calcurse pulseaudio network-manager x11-xserver-utils bluez mplayer ffmpeg net-tools build-essential"
	sudo apt-get update & wait
	sudo apt-get install $apps -y & wait
	((inc++))
	#
	echo -e "[${BLUE}$inc/$prc${ENDCOLOR}]: Installing DistroBox ..."		
	git clone https://github.com/89luca89/distrobox.git
	bash distrobox/install
	((inc++))
	#
	echo -e "[${BLUE}$inc/$prc${ENDCOLOR}]: Installing Sublime Text 4 ..."			
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
	sudo apt-get update -y & wait
	sudo apt-get install sublime-text -y & wait
	((inc++))
	#
	echo -e "[${BLUE}$inc/$prc${ENDCOLOR}]: Installing BurpSuite Community Edition ..."
	bash .etc/burpsuite_community_linux_v2023_6_2.sh -q -varfile response.varfile
	((inc++))	
	#
	echo -e "[${BLUE}$inc/$prc${ENDCOLOR}]: Installing Firefox ..."
	tar xjf .etc/firefox-*.tar.bz2
	sudo mv firefox /opt
	sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox
	sudo wget https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop -P /usr/local/share/applications
	((inc++)); }
#----------
install_qtile() {
	echo -e "[${BLUE}$inc/$prc${ENDCOLOR}]: Installing Qtile and its dependencies from source ..."
	[[ ! -d "$home/.local/bin" ]] && mkdir $home/.local/bin	
	python3 -m venv .
	source bin/activate
	git clone https://github.com/qtile/qtile.git
	pip install psutil
	pip install qtile/./
	cp bin/qtile $home/.local/bin/
	export PATH="$HOME/.local/bin:$PATH"
	((inc++)); }
#----------
import_config() {
	echo -e "[${BLUE}$inc/$prc${ENDCOLOR}]: Copying dotfiles from ${GREEN}dotfile/.config${ENDCOLOR} to ${GREEN}$home${ENDCOLOR} ..."
	cp -r .config/. $home/.config/
	cp -r .home/. $home/
	sudo mv $home/nanorc /etc
	sudo mv $home/qtile.desktop /usr/share/xsessions
	sudo chmod -x /usr/share/xsessions/qtile.desktop
	sudo chmod +r /usr/share/xsessions/qtile.desktop
	mv $home/jetbrains $home/.local/share/fonts/
	sudo chown -R $user:$user $home/./
	source $home/.bashrc
	((inc++))

	echo -e "[${BLUE}$inc/$prc${ENDCOLOR}]: Installation finished ${GREEN}successfully${ENDCOLOR} ..."
	echo -e "[${GREEN}---${ENDCOLOR}]: Please log out from current session to use the Qtile DE ..."	
	((inc++)); }
#----------
while getopts ":s :r :h" opt; do
	case $opt in
		s)  sync ;;
		r)  run ;;
		h)	usage ;;
	esac
	done

#sudo find $src -maxdepth 1 -type d -regex '^.*/[\.]\w+' -exec cp -r {} $dst/dots \;
#sudo find $src -maxdepth 1 -type f -regex '^.*/[\.]\w+' -exec cp -r {} $dst/dots \;
#sudo cp -r $src/Script/ $src/OpenVPN/ main/
#sudo rm -r dots/.cache/ 2> /dev/null
#sudo rm -r dots/.local/share/Trash 2> /dev/null
#sudo du -h $dst/dots | awk '/dots\/\.\w+$/' | grep --color -E "dots|\."
