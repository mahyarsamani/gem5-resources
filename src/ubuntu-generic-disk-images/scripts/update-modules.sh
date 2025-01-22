#!/bin/bash

# Copyright (c) 2025 The Regents of the University of California.
# SPDX-License-Identifier: BSD 3-Clause

echo "Updating modules... This step is only necessary for arm64."

# Ensure the ISA environment variable is set
if [ -z "$ISA" ]; then
    echo "Error: ISA environment variable is not set."
    exit 1
fi

# Ensure the ISA environment variable is set to arm64
if [ "$ISA" != "arm64" ]; then
    echo "Error: This script should only be used for arm64 isa."
    exit 1
fi

# Ensure the KERNEL_VERSION environment variable is set
if [ -z "$KERNEL_VERSION" ]; then
  echo "Error: KERNEL_VERSION environment variable is not set."
  exit 1
fi

# moving modules to the correct location
mv /home/gem5/$KERNEL_VERSION /lib/modules/$KERNEL_VERSION
depmod --quick -a $KERNEL_VERSION
update-initramfs -u -k $KERNEL_VERSION

echo "Done updating modules."
