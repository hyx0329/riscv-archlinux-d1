
.PHONY: build clean distclean

.DEFAULT: build

build: build-opensbi build-u-boot-toc build-bootscr

opensbi/build/platform/generic/firmware/fw_dynamic.bin:
	[ -d opensbi ] || git clone "$(SOURCE_OPENSBI)" -b d1-wip --depth=1 opensbi
	$(MAKE) -C opensbi CROSS_COMPILE="$(CROSS_COMPILE)" PLATFORM=generic FW_PIC=y FW_OPTIONS=0x2
	#cp opensbi/build/platform/generic/firmware/fw_dynamic.bin "$(OUTPUT_DIR)"

build-opensbi: opensbi/build/platform/generic/firmware/fw_dynamic.bin

u-boot/u-boot:
	if [ ! -d "u-boot" ]; then git clone "$(SOURCE_UBOOT)" u-boot; fi
	cd u-boot; git checkout $(COMMIT_UBOOT); git reset --hard $(COMMIT_UBOOT); git apply ../uboot-makefile.patch
	$(MAKE) -C u-boot CROSS_COMPILE="$(CROSS_COMPILE)" ARCH="$(ARCH)" nezha_defconfig
	$(MAKE) -C u-boot CROSS_COMPILE="$(CROSS_COMPILE)" ARCH="$(ARCH)"

build-u-boot: u-boot/u-boot

u-boot.toc1: build-u-boot
	u-boot/tools/mkimage -T sunxi_toc1 -d licheerv_toc1.cfg u-boot.toc1
	cp u-boot.toc1 "$(ARTIFACTS_OUTPUT_DIR)/u-boot.toc1"

build-u-boot-toc: u-boot.toc1

boot.scr: build-u-boot 
	u-boot/tools/mkimage -T script -C none -O linux -A "$(ARCH)" -d bootscr.txt boot.scr
	cp boot.scr "$(ARTIFACTS_OUTPUT_DIR)/boot.scr"

build-bootscr: boot.scr

clean:
	if [ -d opensbi ]; then $(MAKE) -C opensbi clean; fi
	if [ -d u-boot ]; then $(MAKE) -C u-boot clean; fi
	rm -f boot.scr
	rm -f u-boot.toc1

distclean:
	rm -rf opensbi
	rm -rf u-boot
	rm -f boot.scr
	rm -f u-boot.toc1

