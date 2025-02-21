#!/bin/bash

if [[ -z "$URL" ]];then
    URL="https://yum.oracle.com/ISOS/OracleLinux/OL9/u5/x86_64/OracleLinux-R9-U5-x86_64-boot-uek.iso"
fi

if [[ ! -f ./$(basename $URL) ]]; then
    if command -v aria2c 2>&1 >/dev/null; then
        aria2c $URL -x 5 -d ./    
    elif command -v wget 2>&1 >/dev/null; then
        wget $URL
    elif command -v curl 2>&1 >/dev/null; then
        curl -JLOSs $URL 
    else
        echo "Missing something to download with, aria2c, wget, curl??"
        exit 1
    fi
fi

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
  --location ${PWD}/$(basename $URL),initrd=images/pxeboot/initrd.img,kernel=images/pxeboot/vmlinuz \
  --cdrom ${PWD}/$(basename $URL) \
  --initrd-inject=ks.cfg \
  --extra-args "inst.ks=file:/ks.cfg inst.repo=cdrom" \
  --transient \
  --destroy-on-exit 