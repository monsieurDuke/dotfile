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
TIMEFORMAT=%0lR
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
	pre_checker
	backup_sync; }
run() {
	prc=9
	post_checker	
	install_app
	install_qtile
	import_config; }
#----------
pre_checker() {
	echo -en "[${BLUE}$inc/$prc${ENDCOLOR}]: Checking basic ${GREEN}requirements${ENDCOLOR} ... ${BLUE}"
	time {
		[[ ! -d "./.config" ]] && mkdir .config
		[[ ! -d "./.home" ]] && mkdir .home	
		[[ ! -d "./.etc" ]] && mkdir .etc
		if [[ $(id -u) -ne 0 ]]; then 
			echo -e "\n${ENDCOLOR}[${RED}ext${ENDCOLOR}]: Please run the script in a root privilege ${RED}"
			exit 0
			fi
		((inc++)); } ; echo -en "${ENDCOLOR}" ; }
post_checker() {
	echo -en "[${BLUE}$inc/$prc${ENDCOLOR}]: Checking basic ${GREEN}requirements${ENDCOLOR} ... ${BLUE}"
	time {
		if [[ ! -d "./.config" || ! -d "./.home" || ! -d "./.etc" ]]; then
			echo -en "\n${ENDCOLOR}[${RED}ext${ENDCOLOR}]: Please provide the appropriate resources that are needed! ${RED}"
			exit 0
			fi			
		if [[ $(id -u) -ne 0 ]]; then 
			echo -en "\n${ENDCOLOR}[${RED}ext${ENDCOLOR}]: Please run the script in a root privilege ${RED}"
			exit 0
			fi
		((inc++)); } ; echo -en "${ENDCOLOR}" ; }		
#----------
backup_sync() {
	echo -en "[${BLUE}$inc/$prc${ENDCOLOR}]: Copying dotfiles from ${GREEN}$home${ENDCOLOR} to ${GREEN}dotfile/.config${ENDCOLOR} ... ${BLUE}"
	time {
		bu_files=(.bash_history .bashrc .gitconfig .profile .selected_editor .info .dialogrc)
		for i in ${bu_files[@]}; do
			cp $home/$i ./.home
			done
			sudo cp /usr/share/xsessions/qtile.desktop ./.home
		bu_dirs=(asciinema gtk-3.0 kitty neofetch qtile ranger sublime-text-3)
		for j in ${bu_dirs[@]}; do
			cp -r $home/.config/$j ./.config
			done
		((inc++)); } ; echo -en "${ENDCOLOR}" ; }
#----------
install_app() {
	echo -e "--------------------\n$(date)\n--------------------" >> error.log
	echo -en "[${BLUE}$inc/$prc${ENDCOLOR}]: Installing essential ${GREEN}utilities${ENDCOLOR} ... ${BLUE}"
	time {
		apps="neofetch espeak mpv python3-pip python3-venv bat ranger git git-lfs openvpn podman compton exa hugo kitty calcurse pulseaudio network-manager x11-xserver-utils bluez mplayer ffmpeg net-tools build-essential"
		sudo apt-get update 2>> error.log > /dev/null
		sudo apt-get install $apps -y 2>> error.log > /dev/null
		((inc++)); } ; echo -en "${ENDCOLOR}"
	
	echo -en "[${BLUE}$inc/$prc${ENDCOLOR}]: Installing ${GREEN}DistroBox${ENDCOLOR} ... ${BLUE}"
	time {	
		git clone https://github.com/89luca89/distrobox.git 2>> error.log > /dev/null
		bash distrobox/install 2>> error.log > /dev/null
		((inc++)); } ; echo -en "${ENDCOLOR}"
	
	echo -en "[${BLUE}$inc/$prc${ENDCOLOR}]: Installing ${GREEN}Sublime Text 4${ENDCOLOR} ... ${BLUE}"
	time {	
		wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
		echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list 2>> error.log > /dev/null
		sudo apt-get update -y 2>> error.log > /dev/null
		sudo apt-get install sublime-text -y 2>> error.log > /dev/null
		((inc++)); } ; echo -en "${ENDCOLOR}"
	
	echo -en "[${BLUE}$inc/$prc${ENDCOLOR}]: Installing ${GREEN}BurpSuite Community Edition${ENDCOLOR} ... ${BLUE}"
	time {		
		bash .etc/burpsuite_community_linux_v2023_6_2.sh -q -varfile response.varfile 2>> error.log > /dev/null
		((inc++)); } ; echo -en "${ENDCOLOR}"
	
	echo -en "[${BLUE}$inc/$prc${ENDCOLOR}]: Installing ${GREEN}Firefox${ENDCOLOR} ... ${BLUE}"
	time {			
		tar xjf .etc/firefox-*.tar.bz2
		sudo mv firefox /opt
		sudo ln -s /opt/firefox/firefox /usr/local/bin/firefox
		sudo wget https://raw.githubusercontent.com/mozilla/sumo-kb/main/install-firefox-linux/firefox.desktop -P /usr/local/share/applications 2>> error.log > /dev/null
		((inc++)); } ; echo -en "${ENDCOLOR}" ; }
#----------
install_qtile() {
	echo -en "[${BLUE}$inc/$prc${ENDCOLOR}]: Installing ${GREEN}Qtile${ENDCOLOR} and its dependencies ... ${BLUE}"
	time {
		[[ ! -d "$home/.local/bin" ]] && mkdir $home/.local/bin	
		python3 -m venv .
		source bin/activate
		git clone https://github.com/qtile/qtile.git 2>> error.log > /dev/null
		pip install psutil 2>> error.log > /dev/null
		pip install qtile/./ 2>> error.log > /dev/null
		cp bin/qtile $home/.local/bin/
		export PATH="$HOME/.local/bin:$PATH"
		((inc++)); } ; echo -en "${ENDCOLOR}" ; }
#----------
import_config() {
	echo -en "[${BLUE}$inc/$prc${ENDCOLOR}]: Copying dotfiles from ${GREEN}dotfile/.config${ENDCOLOR} to ${GREEN}$home${ENDCOLOR} ... ${BLUE}"
	time {	
		cp -r .config/. $home/.config/
		cp -r .home/. $home/
		sudo mv $home/nanorc /etc
		sudo mv $home/qtile.desktop /usr/share/xsessions
		sudo chmod -x /usr/share/xsessions/qtile.desktop
		sudo chmod +r /usr/share/xsessions/qtile.desktop
		mv $home/jetbrains $home/.local/share/fonts/
		sudo chown -R $user:$user $home/./
		source $home/.bashrc
		((inc++)); } ; echo -en "${ENDCOLOR}"

	echo -e "[${BLUE}$inc/$prc${ENDCOLOR}]: Installation finished ${GREEN}successfully${ENDCOLOR}"
	echo -e "[${GREEN}---${ENDCOLOR}]: Please log out from current session to use the ${GREEN}Qtile WM${ENDCOLOR}"	; }
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
#sudo rm -r dots/.cache/ 2>> /dev/null
#sudo rm -r dots/.local/share/Trash 2>> /dev/null
#sudo du -h $dst/dots | awk '/dots\/\.\w+$/' | grep --color -E "dots|\."
