#!/bin/bash
#----------
RED="\e[95m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[36m"
ENDCOLOR="\e[0m"
int=wlp2s0
#----------
wifi() {
	echo -e "---"	
	nmcli device wifi rescan & wait
	nmcli device wifi list	
	echo -e "---"
	echo -en "[${BLUE}?${ENDCOLOR}]"; read -p " Connect/Disconnect [c/d] ? " get_opt	
	case $get_opt in
		c)
			echo -en "[${BLUE}+${ENDCOLOR}]"; read -p " SSID     : " get_ssid
			echo -en "[${BLUE}+${ENDCOLOR}]"; read -sp " PASSWORD : " get_pass
			if [[ "$get_pass" == "no" ]]; then
				conn=$(nmcli device wifi connect "$get_ssid"> /tmp/wifi.dump 2>&1)
			elif [ $(echo $get_pass | wc -c) -lt 8 ]; then
				echo -e "\n[${RED}!${ENDCOLOR}] Password is either too short ($(echo $get_pass | wc -c)) or not provided"
			else
				conn=$(nmcli device wifi connect "$get_ssid" password "$get_pass" > /tmp/wifi.dump 2>&1)
				res_conn=$(cat -e /tmp/wifi.dump | tr -d "[^$' ")
				if [[ "$res_conn" =~ .*"success".* ]]; then
					ip=$(ifconfig $int | grep inet | tr -s '\t' ' ' | head -n 1 | cut -d ' ' -f 3 )
					echo -e "\n[${GREEN}!${ENDCOLOR}] Connection established, ${YELLOW}$int${ENDCOLOR} at ${GREEN}$ip${ENDCOLOR}"
				else
					echo -e "\n[${RED}!${ENDCOLOR}] Provided password is incorrect"				
				fi
			fi
			;;
		d)
			echo -en "[${BLUE}+${ENDCOLOR}]"; read -p " SSID     : " get_ssid
			nmcli connection down id "$get_ssid"					
			;;			
	esac
	echo
}
#----------
monitors() {
	echo -e "NO DISPLAY WIDTH HEIGHT X-AXIS Y-AXIS" > /tmp/xrandr.dump
	echo -e "--- ------- ----- ------ ------ ------" >> /tmp/xrandr.dump
	xrandr --listactivemonitors | tail -n +2 | cut -c 2- | tr -s 'x' ' ' | tr -s '+' ' ' | awk -F ' ' '{print $1,$2,$3,$4,$5,$6}' >> /tmp/xrandr.dump
	echo -e "---"	
	cat /tmp/xrandr.dump | column -s ' ' -t
	echo -e "---"	
	echo -en "[${BLUE}?${ENDCOLOR}]"; read -p " Change attribute [y/n] ? " get_opt
	case $get_opt in
		y)
			echo -en "[${BLUE}+${ENDCOLOR}]"; read -p " DISPLAY : " get_display
			echo -en "[${BLUE}+${ENDCOLOR}]"; read -p " WIDTH   : " get_width
			echo -en "[${BLUE}+${ENDCOLOR}]"; read -p " HEIGHT  : " get_height	
			echo -en "[${BLUE}+${ENDCOLOR}]"; read -p " X-AXIS  : " get_xaxis
			echo -en "[${BLUE}+${ENDCOLOR}]"; read -p " Y-AXIS  : " get_yaxis
			xrandr --output "$get_display" --pos "$get_xaxis"x"$get_yaxis" --rotate normal --mode "$get_width"x"$get_height"
			;;
		*)  ;; 
	esac
	echo
}
#----------
bluetooth() {
	echo -e "MAC-ADDR DEVICE" > /tmp/bluetooth.dump
	echo -e "-------- ------" >> /tmp/bluetooth.dump
	bluetoothctl devices | awk -F ' ' '{print $2,$3,$4,$5}' | tr '[:lower:]' '[:upper:]' >> /tmp/bluetooth.dump
	echo -e "---"	
	cat /tmp/bluetooth.dump | column -s ' ' -t
	echo -e "---"	
	echo -en "[${BLUE}?${ENDCOLOR}]"; read -p " Scan/Connect/Disconnect [s/c/d] ? " get_opt			
	case $get_opt in
		s)
			echo -e "---"	
			timelimit -q -t30 bluetoothctl scan on	
			;;
		c)  
			echo -en "[${BLUE}+${ENDCOLOR}]"; read -p " MAC-ADDR : " get_mac			
			bluetoothctl pair $get_mac & wait 2> /dev/null
			bluetoothctl trust $get_mac & wait 2> /dev/null
			bluetoothctl connect $get_mac & wait 2> /dev/null
			;; 			
		d)
			echo -en "[${BLUE}+${ENDCOLOR}]"; read -p " MAC-ADDR : " get_mac			
			bluetoothctl disconnect $get_mac & wait 2> /dev/null
			;;					
		*)  ;; 
	esac
	echo
}
#----------
while :
do
	clear		
	echo -e "${GREEN}CONNECTION MANAGER ${ENDCOLOR}\n---"
	echo -e "[${YELLOW}1${ENDCOLOR}] ${BLUE}WIFI${ENDCOLOR}"
	echo -e "[${YELLOW}2${ENDCOLOR}] ${BLUE}BLUETOOTH${ENDCOLOR}"		
	echo -e "[${YELLOW}3${ENDCOLOR}] ${BLUE}MONITORS${ENDCOLOR}"					
	echo -e "---"
	while :
	do
		read -p ">> " opt_main
		case $opt_main in
			1) wifi;;
			2) bluetooth;;
			3) monitors;;
			c) break;;
		esac
	done
done
