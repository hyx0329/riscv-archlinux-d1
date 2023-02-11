# RISCV ArchLinux for Allwinner D1

[![Build ready-to-use ArchLinux image for AllWinner D1](https://github.com/hyx0329/riscv-archlinux-d1/actions/workflows/build-image.yml/badge.svg)](https://github.com/hyx0329/riscv-archlinux-d1/actions/workflows/build-image.yml)

An image Builder for Archlinux on an Allwinner D1 / Sipeed Lichee RV.

A Makefile based reimplementation of https://github.com/sehraf/riscv-arch-image-builder

Just for fun ;)

*Multitasking with make is really cool XD*

For ready-to-use(with Network Manager installed) disk images, see the image in the latest release.

## How to use this tool

I use git submodules to pin the versions. To prepare the source code:
```
git clone --recursive --depth=1 https://github.com/hyx0329/riscv-archlinux-d1
```

*Note: linux code base is HUGE so you'd better clone it manually with limited history depth.*

This tool will check necessary utilities required before building the image, install them if corresponding
error info shows up.
*Or you can refer to the GitHub Action configurations, I build the image on a Ubuntu 22.04 host.*

+ help: `make help`
+ build all necessary(without image): `make artifacts`
    - rootfs downloaded in `rootfs`
    - all other artifacts in `output` by default
+ build a simple kernel tarball: `make linux-release-tarball`
    - packaged as `output/kernel_package.tar.gz`
    - install it by extract it in the rootfs
    - real packaging planned
+ build full image(which can be directly `dd` to your TF Card): `make IMAGE=/path/to/image image`
+ install to disk: `make DEVICE=/path/to/block/device install`
+ **if you have a very powerful multicore CPU, append `-j$(nproc)` to the command line to speed up the whole process :)**

## Notes

components are same as riscv-arch-image-builder

- opensbi, u-boot and linux kernel by smaeul
- wifi driver by lwfinger
- rootfs on `https://archriscv.felixc.at`
    - default root password is `sifive`

