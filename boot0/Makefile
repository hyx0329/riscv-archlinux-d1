
CLONE_DIRECTORY = sun20i_d1_spl

.PHONY: default clean clone_source build

default: build

clone_source:
	[ -d "$(CLONE_DIRECTORY)" ] || git clone --depth=1 "$(SOURCE_BOOT0)" "$(CLONE_DIRECTORY)"

build: clone_source
	$(MAKE) -C "$(CLONE_DIRECTORY)" CROSS_COMPILE=$(CROSS_COMPILE) p=sun20iw1p1 mmc
	cp $(CLONE_DIRECTORY)/nboot/boot0_sdcard_sun20iw1p1.bin $(ARTIFACTS_OUTPUT_DIR)/boot0.bin

clean:
	rm -rf "$(CLONE_DIRECTORY)"

