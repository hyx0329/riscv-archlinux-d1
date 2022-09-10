
.PHONY: build clean distclean patch-source fetch-source

.DEFAULT: build

SOURCE_DIR = linux
BUILD_DIR = linux-build
PKG_DIR := $(abspath linux-pkg)
BUILD_ARGS = ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE)
ARTIFACTS_OUTPUT_DIR ?= ./
KERNEL = $(BUILD_DIR)/arch/riscv/boot/Image
WIFI_MODULE = rtl8723ds/8723ds.ko

export KERNEL WIFI_MODULE BUILD_DIR

fetch-source:
	if [ -d $(SOURCE_DIR) ]; then \
	  cd $(SOURCE_DIR); \
	 	git reset --hard $(COMMIT_LINUX); \
	else \
	  git clone --depth 1 "$(SOURCE_LINUX)" -b "$(KERNEL_TAG)" $(SOURCE_DIR); \
	  if [ "$(COMMIT_LINUX)" != "$$(git rev-parse HEAD)" ]; then \
		  echo "Commit mismatch!"; \
			rm -rf $(SOURCE_DIR); \
	    exit 1; \
		fi; \
	fi;
	touch $(SOURCE_DIR)/.scmversion

patch-source: fetch-source
	echo 'CONFIG_LOCALVERSION="$(KERNEL_LOCALVERSION)"' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_LOCALVERSION_AUTO=n' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	# enable WiFi
	echo 'CONFIG_WIRELESS=y' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_CFG80211=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	# enable /proc/config.gz
	echo 'CONFIG_IKCONFIG=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_IKCONFIG_PROC=y' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	# There is no LAN. so let there be USB-LAN
	echo 'CONFIG_USB_NET_DRIVERS=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_CATC=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_KAWETH=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_PEGASUS=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_RTL8150=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_RTL8152=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_LAN78XX=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_USBNET=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_AX8817X=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_AX88179_178A=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_CDCETHER=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_CDC_EEM=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_CDC_NCM=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_HUAWEI_CDC_NCM=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_CDC_MBIM=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_DM9601=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_SR9700=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_SR9800=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_SMSC75XX=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_SMSC95XX=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_GL620A=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_NET1080=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_PLUSB=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_MCS7830=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_RNDIS_HOST=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_CDC_SUBSET_ENABLE=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_CDC_SUBSET=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_ALI_M5632=y' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_AN2720=y' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_BELKIN=y' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_ARMLINUX=y' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_EPSON2888=y' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_KC2190=y' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_ZAURUS=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_CX82310_ETH=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_KALMIA=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_QMI_WWAN=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_INT51X1=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_IPHETH=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_SIERRA_NET=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_VL600=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_CH9200=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_NET_AQC111=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_USB_RTL8153_ECM=m' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	# enable systemV IPC (needed by fakeroot during makepkg)
	echo 'CONFIG_SYSVIPC=y' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_SYSVIPC_SYSCTL=y' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	# enable swap
	echo 'CONFIG_SWAP=y' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_ZSWAP=y' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
		        #enable Cedrus VPU Drivers
	echo 'CONFIG_MEDIA_SUPPORT=y' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_MEDIA_CONTROLLER=y' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_MEDIA_CONTROLLER_REQUEST_API=y' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_V4L_MEM2MEM_DRIVERS=y' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	echo 'CONFIG_VIDEO_SUNXI_CEDRUS=y' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig
	# enable binfmt_misc
	echo 'CONFIG_BINFMT_MISC=y' >> $(SOURCE_DIR)/arch/riscv/configs/nezha_defconfig

$(KERNEL):
	+$(MAKE) patch-source
	# prepare build directory
	+$(MAKE) -C $(SOURCE_DIR) $(BUILD_ARGS) O=../$(BUILD_DIR) nezha_defconfig
	# build
	+$(MAKE) -C $(BUILD_DIR) $(BUILD_ARGS)
	# save artifacts
	cp $(KERNEL) "$(ARTIFACTS_OUTPUT_DIR)"
	cp $(KERNEL).gz "$(ARTIFACTS_OUTPUT_DIR)"

$(WIFI_MODULE): $(KERNEL)
	[ -d rtl8723ds ] || git clone https://github.com/lwfinger/rtl8723ds.git rtl8723ds
	+$(MAKE) -C rtl8723ds $(BUILD_ARGS) KSRC=../$(BUILD_DIR) modules
	cp rtl8723ds/8723ds.ko $(ARTIFACTS_OUTPUT_DIR)

kernel_package.tar.gz: $(KERNEL)
	fakeroot -- bash -c '\
	set -e; \
	K_VER=$(shell make -C ${BUILD_DIR} -s kernelversion)$(KERNEL_LOCALVERSION); \
	mkdir "$(PKG_DIR)"; \
	install -D -o root -g root -m 755 -T "$(KERNEL)" "$(PKG_DIR)/boot/Image-$${K_VER}"; \
	ln -s "Image-$${K_VER}" "$(PKG_DIR)/boot/Image"; \
	install -D -o root -g root -m 644 -T "$(KERNEL).gz" "$(PKG_DIR)/boot/Image.gz-$${K_VER}"; \
	make -C $(BUILD_DIR) INSTALL_MOD_PATH="$(PKG_DIR)/usr" ARCH="$(ARCH)" modules_install; \
	install -D -o root -g root -m 644 -t "$(PKG_DIR)/usr/lib/modules/$${K_VER}/kernel/drivers/net/wireless" $(WIFI_MODULE); \
	rm -f "$(PKG_DIR)/usr/lib/modules/$${K_VER}/source"; \
	rm -f "$(PKG_DIR)/usr/lib/modules/$${K_VER}/build"; \
	depmod -a -b "$(PKG_DIR)/usr" "$${K_VER}"; \
	if tar -c -z -f $@ -C $(PKG_DIR) $$(ls $(PKG_DIR)); then \
		rm -rf $(PKG_DIR); \
	else \
		rm $@; \
	  rm -rf $(PKG_DIR); \
		exit 1;\
	fi; \
	'
	cp $@ $(ARTIFACTS_OUTPUT_DIR)

release-tarball: kernel_package.tar.gz
release-pkg: kernel_package.tar.gz
	makepkg -A

build: $(KERNEL) $(WIFI_MODULE)

clean-pkg:
	rm -rf src pkg

clean: clean-pkg
	rm -rf $(BUILD_DIR)
	rm -rf $(PKG_DIR)
	rm -f kernel.pkg.zst
	rm -f kernel_package.tar.gz

distclean: clean
	rm -rf $(SOURCE_DIR)
	rm -rf rtl8723ds

