# Build ArchLinux image for AllWinner D1

IMAGE 		 ?= archlinux_d1_full.img
CROSS_COMPILE ?= riscv64-linux-gnu-
OUTPUT_DIR ?= output
ARTIFACTS_OUTPUT_DIR = $(abspath $(OUTPUT_DIR))
ARCH       ?= riscv
CI_BUILD   ?=
SUDO       ?= $(if $(CI_BUILD),,sudo)
SHELL      ?= /usr/bin/bash

SOURCE_BOOT0 ?= https://github.com/smaeul/sun20i_d1_spl
SOURCE_OPENSBI ?= https://github.com/smaeul/opensbi
SOURCE_UBOOT ?= https://github.com/smaeul/u-boot
SOURCE_LINUX ?= https://github.com/smaeul/linux

# from 14.06.2022
COMMIT_BOOT0 ?= 882671fcf53137aaafc3a94fa32e682cb7b921f1
# equals d1-wip (28.05.2022)
COMMIT_UBOOT ?= afc07cec423f17ebb4448a19435292ddacf19c9b
# equals riscv/d1-wip head
COMMIT_LINUX ?= fe178cf0153d98b71cb01a46c8cc050826a17e77
KERNEL_TAG ?= riscv/d1-wip
# kernel release must match commit!
KERNEL_RELEASE ?= 5.19.0-rc1-AllWinnerD1-Smaeul
KERNEL_LOCALVERSION ?= -AllWinnerD1-Smaeul

ARCHIVE_ROOTFS ?= archriscv-20220727.tar.zst
ARCHIVE_ROOTFS_SOURCE ?= https://archriscv.felixc.at/images/
ARCHIVE_ROOTFS_STORAGE = $(ARTIFACTS_OUTPUT_DIR)/$(ARCHIVE_ROOTFS)

REQUIRED_EXECUTABLES = \
	awk bc \
	cpio swig riscv64-linux-gnu-gcc \
	dd mkfs.ext2 mkfs.ext2 parted losetup \
	mktemp tar gzip zstd \
	genfstab sh bash sudo

export

.PHONY: clean default boot0 u-boot linux image install
.PHONY: check-% prepare-directory

.DEFAULT: default

default: boot0 u-boot linux download-rootfs

check-executables:
	@$(foreach exec,$(REQUIRED_EXECUTABLES),\
     $(if $(shell which $(exec)),echo "- found $(exec)";,$(error "No $(exec) in PATH")))

prepare-directory: check-executables
	mkdir -p $(ARTIFACTS_OUTPUT_DIR)

help:
	@echo "Usage:"
	@echo " build everything except image: make artifacts"
	@echo " build a raw image:             make IMAGE=/path/to/img image"
	@echo " install everything:            make DEVICE=/path/to/block/device install"
	@echo " clean up:                      make clean"
	@echo ""
	@echo "Other useful build targets:"
	@echo " boot0"
	@echo " u-boot"
	@echo " linux"
	@echo ""
	@echo "Configurable variables:"
	@echo " IMAGE         The system image to create. Defaults to $(IMAGE)."
	@echo " DEVICE        The target block device to install the system."

boot0 u-boot linux: prepare-directory
	+$(MAKE) -C $@ build
	@echo "- $@ built"

linux-release-tarball: linux
	+$(MAKE) -C linux release-tarball

linux-release-pkg: linux
	+$(MAKE) -C linux release-pkg

download-rootfs:
	+$(MAKE) -C rootfs download
	@echo "- $(ARCHIVE_ROOTFS) downloaded."

$(ARTIFACTS_OUTPUT_DIR)/boot0_sdcard_sun20iw1p1.bin: boot0
$(ARTIFACTS_OUTPUT_DIR)/boot.scr: u-boot
$(ARTIFACTS_OUTPUT_DIR)/u-boot.toc1: u-boot
$(ARTIFACTS_OUTPUT_DIR)/Image: linux
$(ARTIFACTS_OUTPUT_DIR)/Image.gz: linux
$(ARTIFACTS_OUTPUT_DIR)/8723ds.ko: linux
$(ARTIFACTS_OUTPUT_DIR)/kernel_package.tar.gz: linux-release-tarball
rootfs/$(ARCHIVE_ROOTFS): download-rootfs

ARTIFACTS = \
  $(ARTIFACTS_OUTPUT_DIR)/boot0_sdcard_sun20iw1p1.bin \
  $(ARTIFACTS_OUTPUT_DIR)/boot.scr \
  $(ARTIFACTS_OUTPUT_DIR)/u-boot.toc1 \
  $(ARTIFACTS_OUTPUT_DIR)/Image \
  $(ARTIFACTS_OUTPUT_DIR)/Image.gz \
  $(ARTIFACTS_OUTPUT_DIR)/8723ds.ko \
	$(ARTIFACTS_OUTPUT_DIR)/kernel_package.tar.gz \
  rootfs/$(ARCHIVE_ROOTFS)

artifacts: $(ARTIFACTS)

install: $(ARTIFACTS)
	@echo "start installing to device: $(DEVICE)"
	$(if $(DEVICE),$(DEVICE),$(error "Invalid parameter DEVICE: $(DEVICE)"))
	$(error "not implemented yet")

PERCENT := %
$(IMAGE): $(ARTIFACTS)
	@echo "start building $@"
	@echo "Prepare image at $(IMAGE)"
	# Calculate a suitable size, 150% of the minumum (Unit MB) plus 340MB
	# Create a suitable empty file
	ROOTFS_SIZE=$$(tar -t -v --zstd -f rootfs/$(ARCHIVE_ROOTFS) | awk '{s+=$$3} END{print int(s/1024/1024 * 1.5)}');\
	KERNEL_SIZE=$$(tar -t -v --gzip -f "$(ARTIFACTS_OUTPUT_DIR)/kernel_package.tar.gz" | awk '{s+=$$3} END{print int(s/1024/1024 * 1.5)}');\
	PART_SIZE=$$(echo "$${ROOTFS_SIZE} + $${KERNEL_SIZE} + 340" | bc); \
	dd if=/dev/zero of="$(IMAGE)" bs=1M count=$${PART_SIZE}
	# Write partition table on it
	parted -s -a optimal -- "$(IMAGE)" mklabel gpt
	parted -s -a optimal -- "$(IMAGE)" mkpart primary ext2 40MiB 300MiB
	parted -s -a optimal -- "$(IMAGE)" mkpart primary ext4 340MiB 100$(PERCENT)
	# Write rootfs, kernel and boot config
	set -e; \
	MOUNTPOINT=$(shell mktemp -d); \
	if [ '/tmp' != "$${MOUNTPOINT:0:4}" ]; then echo "Misbehaved temp dir! Abort!"; exit 1; fi; \
	echo "Now requires superuser privileges to manipulate the partitions,"; \
	echo "rootless method haven't been implemented yet."; \
	echo "So it's dangous, please make sure you trust the script wont break your system."; \
	export DEVICES=$$($(SUDO) losetup -f -P --show "$(IMAGE)"); \
	echo "Creating filesystem"; \
	$(SUDO) mkfs.ext2 -F -L boot $${DEVICES}p1; \
	$(SUDO) mkfs.ext4 -F -L root $${DEVICES}p2; \
	echo "Writing rootfs and kernel"; \
	$(SUDO) mount $${DEVICES}p2 $${MOUNTPOINT}; \
	$(SUDO) mkdir $${MOUNTPOINT}/boot; \
	$(SUDO) mount $${DEVICES}p1 $${MOUNTPOINT}/boot; \
	$(SUDO) tar -x -f rootfs/$(ARCHIVE_ROOTFS) -C $${MOUNTPOINT}; \
	$(SUDO) tar -x -f "$(ARTIFACTS_OUTPUT_DIR)/kernel_package.tar.gz" -C $${MOUNTPOINT}; \
	$(SUDO) sh -c "echo '8723ds' >> $${MOUNTPOINT}/etc/modules-load.d/8723ds.conf"; \
	$(SUDO) mkdir -p $${MOUNTPOINT}/boot/extlinux; \
	$(SUDO) sh -c "echo 'label default' >> $${MOUNTPOINT}/boot/extlinux/extlinux.conf"; \
	$(SUDO) sh -c "echo '        linux   ../Image' >> $${MOUNTPOINT}/boot/extlinux/extlinux.conf"; \
	$(SUDO) sh -c "echo '        append  earlycon=sbi console=ttyS0,115200n8 root=/dev/mmcblk0p2 rootwait cma=96M' >> $${MOUNTPOINT}/boot/extlinux/extlinux.conf"; \
	echo "generate fstab"; \
	$(SUDO) sh -c "genfstab -U $${MOUNTPOINT} >> $${MOUNTPOINT}/etc/fstab"; \
	cat $${MOUNTPOINT}/etc/fstab; \
	echo "umount"; \
	$(SUDO) umount $${MOUNTPOINT}/boot; \
	$(SUDO) umount $${MOUNTPOINT}; \
	echo "Write bootloader"; \
	$(SUDO) dd if="$(ARTIFACTS_OUTPUT_DIR)/boot0_sdcard_sun20iw1p1.bin" of="$${DEVICES}" bs=8192 seek=16; \
	$(SUDO) dd if="$(ARTIFACTS_OUTPUT_DIR)/u-boot.toc1" of="$${DEVICES}" bs=512 seek=32800; \
	echo "clean up"; \
	$(SUDO) rm -rf $${MOUNTPOINT}; \
	$(SUDO) losetup -d $${DEVICES};

image: $(IMAGE)

clean-boot0 clean-u-boot clean-linux:
	+$(MAKE) -C $(subst clean-,,$@) clean

distclean-boot0 distclean-u-boot distclean-linux:
	+$(MAKE) -C $(subst distclean-,,$@) distclean

clean-all: clean-boot0 clean-u-boot clean-linux

distclean-all: distclean-boot0 distclean-u-boot distclean-linux

clean: clean-all
	rm -rf $(ARTIFACTS_OUTPUT_DIR)
	rm -f $(IMAGE)

distclean: distclean-all
	rm -rf $(ARTIFACTS_OUTPUT_DIR)
	rm -f $(IMAGE)

