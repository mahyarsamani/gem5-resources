#!/bin/bash

# Copyright (c) 2025 The Regents of the University of California.
# SPDX-License-Identifier: BSD 3-Clause

# Check if ISA is set
if [ -z "$ISA" ]; then
    echo "Error: ISA is not set"
    exit 1
fi

# Check if ISA is x86
if [ "$ISA" != "x86" ]; then
    echo "Error: ISA is not x86"
    exit 1
fi

# Make sure the headers are installed to extract the kernel that DKMS
# packages will be built against.
sudo apt -y install "linux-headers-$(uname -r)" "linux-modules-extra-$(uname -r)"

echo "Extracting linux kernel $(uname -r) to /home/gem5/vmlinux-x86-ubuntu"
sudo bash -c "/usr/src/linux-headers-$(uname -r)/scripts/extract-vmlinux /boot/vmlinuz-$(uname -r) > /home/gem5/vmlinux-x86-ubuntu"
