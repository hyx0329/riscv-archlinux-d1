# Build ArchLinux image for AllWinner D1

IMAGE 		 ?= archlinux_d1_full.img
CROSS_COMPILE ?= riscv64-linux-gnu-
OUTPUT_DIR ?= output
ARTIFACTS_OUTPUT_DIR = $(abspath $(OUTPUT_DIR))
ARCH       ?= riscv

SOURCE_BOOT0 ?= https://github.com/smaeul/sun20i_d1_spl
SOURCE_OPENSBI ?= https://github.com/smaeul/opensbi
SOURCE_UBOOT ?= https://github.com/smaeul/u-boot
SOURCE_LINUX ?= https://github.com/smaeul/linux

COMMIT_BOOT0 ?= 882671fcf53137aaafc3a94fa32e682cb7b921f1 # from 14.06.2022
COMMIT_UBOOT ?= afc07cec423f17ebb4448a19435292ddacf19c9b # equals d1-wip (28.05.2022)
COMMIT_LINUX ?= fe178cf0153d98b71cb01a46c8cc050826a17e77 # equals riscv/d1-wip head
KERNEL_TAG ?= riscv/d1-wip
KERNEL_RELEASE ?= 5.19.0-AllWinnerD1-Smaeul # must match commit!

ARCHIVE_ROOTFS ?= archriscv-20220727.tar.zst
ARCHIVE_ROOTFS_SOURCE ?= https://archriscv.felixc.at/images/
ARCHIVE_ROOTFS_STORAGE = $(ARTIFACTS_OUTPUT_DIR)/$(ARCHIVE_ROOTFS)

REQUIRED_EXECUTABLES = cpio swig riscv64-linux-gnu-gcc

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
	@echo " build everything except image: make"
	@echo " build a raw image:             make IMAGE=/path/to/img image"
	@echo " install everything:            make DEVICE=/path/to/block/device install"
	@echo " clean up:                      make clean"
	@echo ""
	@echo "Other available build targets:"
	@echo " boot0"
	@echo " u-boot"
	@echo " linux"
	@echo ""
	@echo "Configurable variables:"
	@echo " IMAGE         The system image to create. Defaults to $(IMAGE)."
	@echo " DEVICE        The target block device to install the system."

boot0 u-boot linux: prepare-directory
	$(MAKE) -C $@
	@echo "$@ built"

download-rootfs:
	$(MAKE) -C rootfs download
	@echo "$(ARCHIVE_ROOTFS) downloaded."

image: boot0 u-boot linux download-rootfs
	@echo "start building $@"
	$(error "not implemented yet")

install: boot0 u-boot linux download-rootfs
	@echo "start installing to device: $(DEVICE)"
	$(error "not implemented yet")

clean-boot0 clean-u-boot clean-linux:
	@make -C $(subst clean-,,$@) clean

distclean-boot0 distclean-u-boot distclean-linux:
	@make -C $(subst distclean-,,$@) clean

clean-all: clean-boot0 clean-u-boot clean-linux

distclean-all: distclean-boot0 distclean-u-boot distclean-linux

clean: clean-all
	rm -rf $(ARTIFACTS_OUTPUT_DIR)

distclean: distclean-all
	rm -rf $(ARTIFACTS_OUTPUT_DIR)

