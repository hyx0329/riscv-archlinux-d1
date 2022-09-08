
.PHONY: download

$(ARCHIVE_ROOTFS):
	@echo "Downloading rootfs tarball: $@"
	curl -o "$@" "$(ARCHIVE_ROOTFS_SOURCE)$(ARCHIVE_ROOTFS)"

download: $(ARCHIVE_ROOTFS)

clean:

distclean:
	rm *.tar.zst

