#!/bin/bash
#----------
home="/home/icat"
prc=8
inc=1
#----------
RED="\e[95m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[36m"
ENDCOLOR="\e[0m"
#----------

## 1. check if the main dirs are presents
echo -e "[${BLUE}$inc/$prc${ENDCOLOR}]: Checking basic requirements ..."
[[ ! -d "./.config" ]] && mkdir .config
[[ ! -d "./.etc" ]] && mkdir .etc
if [[ $(id -u) -ne 0 ]]; then 
	echo -e "[${RED}ext${ENDCOLOR}]: Please run the script in a root privilege"
	exit 0
	fi
((inc++))

## 2. backup file and directories from home workspace 
echo -e "[${BLUE}$inc/$prc${ENDCOLOR}]: Copying dotfiles from ${GREEN}$home${ENDCOLOR} to ${GREEN}dotfile/.config${ENDCOLOR} ..."
bu_files=(.bash_history .bashrc .gitconfig .profile .selected_editor .info .dialogrc)
for i in ${bu_files[@]}; do
	cp $home/$i ./.config
	done
bu_dirs=(asciinema gtk-3.0 kitty neofetch qtile ranger sublime-text-3)
for j in ${bu_dirs[@]}; do
	cp -r $home/.config/$j ./.config
	done
((inc++))

## 3. installing dependencies and essential apps 
apps=(bat ranger )

## 4. removing bloated apps 
##    --> 
## 5. installing qtile & tools within
## 6. importing dots to ~/ dir


#sudo find $src -maxdepth 1 -type d -regex '^.*/[\.]\w+' -exec cp -r {} $dst/dots \;
#sudo find $src -maxdepth 1 -type f -regex '^.*/[\.]\w+' -exec cp -r {} $dst/dots \;
#sudo cp -r $src/Script/ $src/OpenVPN/ main/
#sudo rm -r dots/.cache/ 2> /dev/null
#sudo rm -r dots/.local/share/Trash 2> /dev/null
#sudo du -h $dst/dots | awk '/dots\/\.\w+$/' | grep --color -E "dots|\."
