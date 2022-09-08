# RISCV ArchLinux for D1

A Makefile based reimplementation of https://github.com/sehraf/riscv-arch-image-builder .

Just for fun ;)

## How to use

+ help: `make help`
+ build all(without image): `make artifacts`
    - rootfs downloaded in `rootfs`
    - all other artifacts in `output` by default
+ build image: `make IMAGE=/path/to/image image` (TBW)
+ install: `make DEVICE=/path/to/block/device install` (TBW)

