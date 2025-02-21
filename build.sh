#!/bin/bash
function download () {
    if [[ ! -f ./$(basename $1) ]]; then
        if command -v aria2c 2>&1 >/dev/null; then
            aria2c $1 -x 5 -d ./    
        elif command -v wget 2>&1 >/dev/null; then
            wget $1
        elif command -v curl 2>&1 >/dev/null; then
            curl -JLOSs $1
        else
            echo "Missing something to download with, aria2c, wget, curl??"
            exit 1
        fi
    fi    
}

if [[ -z "$ISO" ]];then
    URL="https://yum.oracle.com/ISOS/OracleLinux/OL9/u5/x86_64/OracleLinux-R9-U5-x86_64-boot-uek.iso"
fi

if [[ -z "$KS" ]];then
    KS="https://raw.githubusercontent.com/chashtag/ol9-build/refs/heads/main/ks.cfg"
fi


for dl in $ISO $KS;do
    download $dl
done


if ! command -v virt-install 2>&1 >/dev/null; then
        echo "Missing virt-install"
        exit 1
fi


virt-install \
  --connect qemu:///session \
  --name ol-build \
  --ram 4096 \
  --vcpus 2 \
  --boot uefi \
  --os-variant ol9-unknown \
  --disk size=200,format=qcow2 \
  --location ${PWD}/$(basename $ISO),initrd=images/pxeboot/initrd.img,kernel=images/pxeboot/vmlinuz \
  --cdrom ${PWD}/$(basename $ISO) \
  --initrd-inject=${PWD}/$(basename $KS) \
  --extra-args "inst.ks=file:/$(basename $KS) inst.repo=cdrom" \
  --transient \
  --destroy-on-exit 