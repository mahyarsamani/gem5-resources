#!/bin/bash

# Copyright (c) 2024 The Regents of the University of California.
# SPDX-License-Identifier: BSD 3-Clause

PACKER_VERSION="1.10.0"

# This part installs the packer binary on the arm64 machine as we are assuming
# that we are building the disk image on an arm64 machine.
if [ ! -f ./packer ]; then
    wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_arm64.zip;
    unzip packer_${PACKER_VERSION}_linux_arm64.zip;
    rm packer_${PACKER_VERSION}_linux_arm64.zip;
fi

# Check if the Ubuntu version variable is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <ubuntu_version>"
    echo "Example: $0 22.04 or $0 24.04"
    exit 1
fi

# Store the Ubuntu version from the command line argument
ubuntu_version="$1"

# Check if the specified Ubuntu version is valid
if [[ "$ubuntu_version" != "22.04" && "$ubuntu_version" != "24.04" ]]; then
    echo "Error: Invalid Ubuntu version '$ubuntu_version'. Must be '22.04' or '24.04'."
    exit 1
fi

# Create a dictionary to store the path to the kernel modules for each Ubuntu version
declare -A kernel_modules_paths
kernel_modules_paths["22.04"]="modules/u2204"
kernel_modules_paths["24.04"]="modules/u2404/"

# Get the path to the kernel modules for the specified Ubuntu version
kernel_modules_path=${kernel_modules_paths[$ubuntu_version]}
pushd $kernel_modules_path
./copy_modules.sh
popd

# Store the image name from the second command line argument or default to "arm-ubuntu"
image_name="${2:-arm-ubuntu}"

# make the flash0.img file
cd ./files
dd if=/dev/zero of=flash0.img bs=1M count=64
dd if=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd of=flash0.img conv=notrunc
cd ..

# Install the needed plugins
./packer init ./packer-scripts/arm-ubuntu.pkr.hcl

# Build the image with the specified Ubuntu version
./packer build -var "ubuntu_version=${ubuntu_version}" -var "image_name=${image_name}" ./packer-scripts/arm-ubuntu.pkr.hcl
