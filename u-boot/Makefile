
.PHONY: build clean distclean

.DEFAULT: build

FILES_TO_BUILD = \
  boot.scr \
  u-boot.toc1

build: $(FILES_TO_BUILD)
	@$(foreach filetobuild,$(FILES_TO_BUILD),\
     $(shell cp $(filetobuild) $(ARTIFACTS_OUTPUT_DIR)))

opensbi/build/platform/generic/firmware/fw_dynamic.bin:
	[ -d opensbi ] || git clone "$(SOURCE_OPENSBI)" -b d1-wip --depth=1 opensbi
	+$(MAKE) -C opensbi CROSS_COMPILE="$(CROSS_COMPILE)" PLATFORM=generic FW_PIC=y FW_OPTIONS=0x2
	#cp opensbi/build/platform/generic/firmware/fw_dynamic.bin "$(OUTPUT_DIR)"

u-boot/u-boot:
	if [ ! -d "u-boot" ]; then git clone "$(SOURCE_UBOOT)" u-boot; fi
	cd u-boot; git checkout $(COMMIT_UBOOT); git reset --hard $(COMMIT_UBOOT); git apply ../uboot-makefile.patch
	+$(MAKE) -C u-boot CROSS_COMPILE="$(CROSS_COMPILE)" ARCH="$(ARCH)" nezha_defconfig
	+$(MAKE) -C u-boot CROSS_COMPILE="$(CROSS_COMPILE)" ARCH="$(ARCH)"

u-boot.toc1: u-boot/u-boot opensbi/build/platform/generic/firmware/fw_dynamic.bin
	u-boot/tools/mkimage -T sunxi_toc1 -d licheerv_toc1.cfg u-boot.toc1

boot.scr: u-boot/u-boot
	u-boot/tools/mkimage -T script -C none -O linux -A "$(ARCH)" -d bootscr.txt boot.scr

clean:
	+if [ -d opensbi ]; then $(MAKE) -C opensbi clean; fi
	+if [ -d u-boot ]; then $(MAKE) -C u-boot clean; fi
	rm -f boot.scr
	rm -f u-boot.toc1

distclean:
	rm -rf opensbi
	rm -rf u-boot
	rm -f boot.scr
	rm -f u-boot.toc1

