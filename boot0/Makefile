
CLONE_DIRECTORY = sun20i_d1_spl
ARGS_BUILD = CROSS_COMPILE=$(CROSS_COMPILE) p=sun20iw1p1
FILES_TO_BUILD = \
	$(CLONE_DIRECTORY)/nboot/boot0_sdcard_sun20iw1p1.bin

.PHONY: default clean clone_source build distclean

default: build

clone_source:
	[ -d "$(CLONE_DIRECTORY)" ] || git clone --depth=1 "$(SOURCE_BOOT0)" "$(CLONE_DIRECTORY)"

$(CLONE_DIRECTORY)/nboot/boot0_sdcard_sun20iw1p1.bin:
	+$(MAKE) clone_source
	+$(MAKE) -C "$(CLONE_DIRECTORY)" $(ARGS_BUILD) mmc

build: $(FILES_TO_BUILD)
	@$(foreach filetobuild,$(FILES_TO_BUILD),\
     $(shell cp $(filetobuild) $(ARTIFACTS_OUTPUT_DIR)))

distclean:
	rm -rf "$(CLONE_DIRECTORY)"

clean:
	$(MAKE) -C "$(CLONE_DIRECTORY)" $(ARGS_BUILD) clean

