#!/bin/bash
device_conf() {
	xfce4-terminal -e '/bin/bash -e /home/icat/.config/qtile/scripts/sub-deviceconf.sh' 2>/dev/null
}
#==========================
mplayer_cam() { ## -c
	case $1 in
		"start")	
			mplayer tv:// -tv driver=v4l2:width=800:height=600:device=/dev/video0:fps=60:outfmt=yuy2 -title "mplayer /dev/video0 - UglyAssFace"
			;;
		"stop")	
			killall mplayer
			;;			
	esac	
}
#==========================
ffmpeg_record() { ## -f \\ start & stop
	res=$(xrandr | grep '*' | awk '{ print $1 }' | head -n 1)
	case $1 in
		"start")
			ffmpeg -video_size $res -framerate 60 -f x11grab -i :0.0+0,0 -f alsa -ac 2 -i pulse -acodec aac -strict experimental -c:v libx264rgb -crf 0 -preset ultrafast /home/icat/Videos/$(date +"%H_%M_%S--%d_%m_%y").flv &
			espeak "recording started"
			;;
		"stop")
			espeak "recording stopped" & wait
			sleep 2s
			killall ffmpeg	
			;;
	esac
}
#==========================
virt_win10() {
	case $1 in
		"start")
			export LIBVIRT_DEFAULT_URI="qemu:///system"
			virsh start windows-10 &&
			virt-viewer -f -w -a windows-10
			## virt-manager --connect qemu:///system --show-domain-console windows-10
			;;
		"stop")
			virsh shutdown windows-10 &&
			killall virt-manager			
			;;
	esac	
}
#==========================
while getopts ":f:c:w: :d" opt; do
	case $opt in
		f) f="${OPTARG}" ;;
		c) c="${OPTARG}" ;;
		w) w="${OPTARG}" ;;
		d) device_conf ;;
	esac
done
#==========================
if [[ "$f" ]]; then ffmpeg_record "$f"; fi
if [[ "$c" ]]; then mplayer_cam "$c"; fi
if [[ "$w" ]]; then virt_win10 "$w"; fi