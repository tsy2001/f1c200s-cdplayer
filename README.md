# High-Res CD Player 
Linux BSP For Allinner F1C100S/F1C200S


### Ubuntu 20.04 environment 
```sh
  sudo apt-get install xz-utils mtd-utils nano wget unzip build-essential git bc swig libncurses5-dev libpython3-dev libssl-dev pkg-config zlib1g-dev libz-dev libfdt-dev libusb-dev libusb-1.0-0-dev python3-pip gawk bison flex python2.7 python2.7-dev python-dev python-setuptools
```

### SDK download from GitHub
``` sh
  git clone https://github.com/tsy2001/f1c200s-cdplayer.git
  cd ./f1c200s-cdplayer
  git submodule update --init --recursive
```

### Compile sunxi-tools
``` sh
  cd sunxi-tools/
  sudo make
  # test
  sudo ./sunxi-fel -h
  # install
  sudo make install
```

### Compile Buildroot
``` sh
  cd buildroot-2025.02.9/
  make menuconfig
  make -j8
```
get buildroot toolchain
``` sh
  make sdk
  cp output/images/arm-buildroot-linux-musleabi_sdk-buildroot.tar.gz  (PATH TO SAVE YOUR TOOLCHAIN)/
  tar -xf (PATH TO SAVE YOUR TOOLCHAIN)/arm-buildroot-linux-musleabi_sdk-buildroot.tar.gz
  # append on ~/.bashrc
  export PATH=$PATH:(PATH TO SAVE YOUR TOOLCHAIN)/arm-buildroot-linux-musleabi_sdk-buildroot/bin
```
checkout toolchain (Make sure the command is executable in any folder.)
``` sh
  arm-buildroot-linux-musleabi-gcc -v  
```
``` sh
xec/gcc/arm-buildroot-linux-musleabi/13.4.0/lto-wrapper
Target: arm-buildroot-linux-musleabi
Configured with: ./configure --prefix=/home/tsy/F1C200S/flash/buildroot-2025.02.9/output/host --sysconfdir=/home/tsy/F1C200S/flash/buildroot-2025.02.9/output/host/etc --enable-static --target=arm-buildroot-linux-musleabi --with-sysroot=/home/tsy/F1C200S/flash/buildroot-2025.02.9/output/host/arm-buildroot-linux-musleabi/sysroot --enable-__cxa_atexit --with-gnu-ld --disable-libssp --disable-multilib --disable-decimal-float --enable-plugins --enable-lto --with-gmp=/home/tsy/F1C200S/flash/buildroot-2025.02.9/output/host --with-mpc=/home/tsy/F1C200S/flash/buildroot-2025.02.9/output/host --with-mpfr=/home/tsy/F1C200S/flash/buildroot-2025.02.9/output/host --with-pkgversion='Buildroot 2025.02.9' --with-bugurl=https://gitlab.com/buildroot.org/buildroot/-/issues --without-zstd --disable-libmpx --disable-libquadmath --disable-libquadmath-support --disable-libsanitizer --enable-tls --enable-threads --without-isl --without-cloog --with-float=soft --with-abi=aapcs-linux --with-cpu=arm926ej-s --with-float=soft --with-mode=arm --enable-languages=c --with-build-time-tools=/home/tsy/F1C200S/flash/buildroot-2025.02.9/output/host/arm-buildroot-linux-musleabi/bin --enable-shared --disable-libgomp
Thread model: posix
Supported LTO compression algorithms: zlib
gcc version 13.4.0 (Buildroot 2025.02.9)
```

### Compile Linux Kernel
``` sh
  cd f1c200s-linux5.7/
  make menuconfig
  make -j8
```

### Compile Uboot
``` sh
  cd f1c200s-uboot/
  make menuconfig
  make -j8
```
  
### Flash to SPI-Flash
``` sh
  ./dd_flash.sh
  sudo sunxi-fel -p spiflash-write 0 flashimg.bin 
```

### Flash to SD-CARD
``` sh
  sudo fdisk /dev/sdb
  d #delete all partitions
  n p 1 2048 +16M
  n p 2 2018 # just press "Enter"
  w # save

  sudo mkfs.vfat /dev/sdb1
  sudo mkfs.ext4 /dev/sdb2
```
  copy f1c200s-linux5.7/arch/arm/boot/zImage  
  and  f1c200s-linux5.7/arch/arm/boot/dts/suniv-f1c100s-licheepi-nano.dtb  
  to /dev/sdb1
``` sh
  sudo tar -xf buildroot-2025.02.9/output/images/rootfs.tar -C /media/<username>/<your sdcard sdb2 partition>/
  sync
```
recompile uboot
``` sh
  cd f1c200s-uboot/
  git checkout nano-v2018.01
  make ARCH=arm CROSS_COMPILE=arm-buildroot-linux-musleabi-
  sudo dd if=u-boot-sunxi-with-spl.bin of=/dev/sdb bs=1024 seek=8
```



  
