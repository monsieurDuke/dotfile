#!/bin/bash
#----------
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
         \n  -h (help)\n\tDisplaying possible usage of the script"
}
#----------
sync() {
	prc=2
	checker
	backup_sync
}
run() {
	prc=2
	checker	
	install_app
}
#----------
checker() {
	echo -e "[${BLUE}$inc/$prc${ENDCOLOR}]: Checking basic requirements ..."
	[[ ! -d "./.config" ]] && mkdir .config
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
		cp $home/$i ./.config
		done
	bu_dirs=(asciinema gtk-3.0 kitty neofetch qtile ranger sublime-text-3)
	for j in ${bu_dirs[@]}; do
		cp -r $home/.config/$j ./.config
		done
	((inc++)); }
#----------
install_app() {
	echo -e "[${BLUE}$inc/$prc${ENDCOLOR}]: Installing essential apps and dependencies ..."	
	apps="bat ranger git git-lfs openvpn podman compton exa hugo kitty calcurse pulseaudio network-manager x11-xserver-utils bluez mplayer ffmpeg net-tools build-essential"
	sudo apt-get update & wait
	sudo apt-get install $apps -y & wait	
	#
	git clone https://github.com/89luca89/distrobox.git & wait
	bash distrobox/install & wait
	#
	wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null & wait
	echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list & wait
	sudo apt-get update -y & wait
	sudo apt-get install sublime-text -y & wait
	#
	bash .etc/burpsuite_community_linux_v2023_6_2.sh & wait
	#
	tar xjf .etc/firefox-*.tar.bz2 & wait
	sudo mv firefox /opt & wait
	sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox & wait
	sudo wget https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop -P /usr/local/share/applications & wait
	((inc++)); }

## 4. removing bloated apps 
##    --> 
## 5. installing qtile
## 6. importing dots to ~/ dir

#----------
while getopts ":s :r :h" opt; do
	case $opt in
		s)  sync ;;
		r)  run ;;
		h)	usage ;;
	esac
	done
#----------



#sudo find $src -maxdepth 1 -type d -regex '^.*/[\.]\w+' -exec cp -r {} $dst/dots \;
#sudo find $src -maxdepth 1 -type f -regex '^.*/[\.]\w+' -exec cp -r {} $dst/dots \;
#sudo cp -r $src/Script/ $src/OpenVPN/ main/
#sudo rm -r dots/.cache/ 2> /dev/null
#sudo rm -r dots/.local/share/Trash 2> /dev/null
#sudo du -h $dst/dots | awk '/dots\/\.\w+$/' | grep --color -E "dots|\."
