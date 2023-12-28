#!/bin/bash
case $1 in
  "start")
    export LIBVIRT_DEFAULT_URI="qemu:///system"
    virsh start "$2" &&
    virt-viewer -f -w -a "$2"
    ## virt-manager --connect qemu:///system --show-domain-console windows-10
    ;;
  "stop")
    virsh shutdown "$2" &&
    killall virt-manager			
    ;;
esac	
