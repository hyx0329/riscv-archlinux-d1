# RISCV ArchLinux for Allwinner D1

[![Build ready-to-use ArchLinux image for AllWinner D1](https://github.com/hyx0329/riscv-archlinux-d1/actions/workflows/build-image.yml/badge.svg)](https://github.com/hyx0329/riscv-archlinux-d1/actions/workflows/build-image.yml)

An image Builder for Archlinux on an Allwinner D1 / Sipeed Lichee RV.

A Makefile based reimplementation of https://github.com/sehraf/riscv-arch-image-builder

Just for fun ;)

*Multitasking with make is really cool XD*

For ready-to-use(with Network Manager installed) disk images, see the artifacts in actions.

## How to use

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

