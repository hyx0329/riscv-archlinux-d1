
.PHONY: build clean distclean

.DEFAULT: build

FILES_TO_BUILD = \
	u-boot/u-boot-sunxi-with-spl.bin

build: $(FILES_TO_BUILD)
	@$(foreach filetobuild,$(FILES_TO_BUILD),\
     $(shell cp $(filetobuild) $(ARTIFACTS_OUTPUT_DIR)))

opensbi/build/platform/generic/firmware/fw_dynamic.bin:
	[ -d opensbi ] || git clone "$(SOURCE_OPENSBI)" -b d1-wip --depth=1 opensbi
	+$(MAKE) -C opensbi CROSS_COMPILE="$(CROSS_COMPILE)" PLATFORM=generic FW_PIC=y FW_OPTIONS=0x2
	#cp opensbi/build/platform/generic/firmware/fw_dynamic.bin "$(OUTPUT_DIR)"

u-boot/u-boot-sunxi-with-spl.bin: opensbi/build/platform/generic/firmware/fw_dynamic.bin
	#if [ ! -d "u-boot" ]; then git clone "$(SOURCE_UBOOT)" u-boot; fi
	#cd u-boot; git checkout $(COMMIT_UBOOT); git reset --hard $(COMMIT_UBOOT); git apply ../uboot-makefile.patch
	+$(MAKE) -C u-boot CROSS_COMPILE="$(CROSS_COMPILE)" ARCH="$(ARCH)" nezha_defconfig
	+$(MAKE) -C u-boot CROSS_COMPILE="$(CROSS_COMPILE)" ARCH="$(ARCH)" OPENSBI=opensbi/build/platform/generic/firmware/fw_dynamic.bin

clean:
	+if [ -d opensbi ]; then $(MAKE) -C opensbi clean; fi
	+if [ -d u-boot ]; then $(MAKE) -C u-boot clean; fi
	rm -f boot.scr
	rm -f u-boot.toc1

distclean:
	#rm -rf opensbi
	#rm -rf u-boot
	rm -f boot.scr
	rm -f u-boot.toc1
	git --git-dir=opensbi/.git --work-tree=opensbi reset --hard
	+if [ -d u-boot ]; then $(MAKE) -C u-boot distclean; fi
	git --git-dir=u-boot/.git --work-tree=u-boot reset --hard

