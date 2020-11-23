#!/bin/bash

truncate -s 1G disk.img
parted -s -a optimal -- disk.img \
  unit MB \
  mklabel msdos \
  mkpart primary ext4 1MB 100MB \
  mkpart primary fat32 100MB 100% \
  print

parted -s -a optimal -- disk.img \
  unit MiB \
  mklabel gpt \
  mkpart primary ext4 1 100 \
  mkpart primary fat32 100 -2048s \
  print

echo -e "%s\n" | cryptsetup -q luksFormat /dev/sdc1

mkfs.ext4 -E lazy_itable_init=1,lazy_journal_init=1 -F /dev/mapper/usbluks -L usbluks 2>&1

