# RISCV ArchLinux for Allwinner D1

An image Builder for Archlinux on an Allwinner D1 / Sipeed Lichee RV.

A Makefile based reimplementation of https://github.com/sehraf/riscv-arch-image-builder

Just for fun ;)

*Multitasking with make is really cool XD*

## How to use

+ help: `make help`
+ build all necessary(without image): `make artifacts`
    - rootfs downloaded in `rootfs`
    - all other artifacts in `output` by default
+ build a simple kernel tarball: `make linux-release-tarball`
    - packaged as `output/kernel_package.tar.gz`
    - install it by extract it in the rootfs
    - real packaging planned
+ build image: `make IMAGE=/path/to/image image` (TBW)
+ install to disk: `make DEVICE=/path/to/block/device install` (TBW)

