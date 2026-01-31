# HiFi CD Player 
Linux BSP For Allinner F1C100S/F1C200S  

## Featres
1.Support CD-DA format music album decoding and playback.  
2.Supports mounting and playing audio files on CD ROMs or DVD ROMs in UFD and ISO9660 formats.  
3.Supports decoding of audio files in WAV, FLAC and MP3 formats with any baud rate or bit rate.  

## Hardware
On-Board ES9023P HiFi audio codec, can directly drive 32-ohm headphones.  
On-Board USB to SATA bridge, supporting any SATA optical drive.  
On-Board IR receiver, supporting IR remote control.  
https://oshwhub.com/tsy2001/quanzhi-f1c100sf1c200shificd-mus

## Preview
https://www.bilibili.com/video/BV1griABUEk2  
https://www.bilibili.com/video/BV1NMiGBAEQh

### Resource consumption
1.Decoding CD-DA music album:
```sh
Mem: 8068K used, 50160K free, 164K shrd, 0K buff, 2064K cached
CPU:  26% usr  41% sys   0% nic  29% idle   0% io   0% irq   1% sirq
Load average: 1.41 1.78 1.61 2/40 120
  PID  PPID USER     STAT   VSZ %VSZ %CPU COMMAND
  112    92 root     S    14292  25%  52% ./u8g2_hw_i2c_dvd
  119    92 root     R     1612   3%   9% top -d 1
   53     2 root     SW       0   0%   4% [usb-storage]
```
2.Decoding WAV audio file with 44100 sample rate, 16 bit depth:
```sh
Mem: 25928K used, 32300K free, 164K shrd, 52K buff, 19752K cached
CPU:   8% usr  11% sys   0% nic  79% idle   0% io   0% irq   0% sirq
Load average: 2.19 2.52 1.78 1/39 119
  PID  PPID USER     STAT   VSZ %VSZ %CPU COMMAND
  112    92 root     S    14292  25%  15% ./u8g2_hw_i2c_dvd
  119    92 root     R     1612   3%   4% top -d 1
   10     2 root     IW       0   0%   1% [rcu_preempt]
```
3.Decoding FLAC audio file with 96000 sample rate, 24 bit depth:
```sh
Mem: 45268K used, 12960K free, 164K shrd, 52K buff, 38684K cached
CPU:  69% usr   8% sys   0% nic  29% idle   0% io   0% irq   0% sirq
Load average: 3.06 2.52 1.64 1/39 118
  PID  PPID USER     STAT   VSZ %VSZ %CPU COMMAND
  112    92 root     S    14764  25%  72% ./u8g2_hw_i2c_dvd
  118    92 root     R     1612   3%   3% top -d 1
  111     2 root     IW       0   0%   1% [kworker/0:0-eve]
```
4.Decoding MP3 audio file with 44100 sample rate, 320kbps:
```sh
Mem: 21612K used, 36616K free, 164K shrd, 52K buff, 15372K cached
CPU:  61% usr   6% sys   0% nic  32% idle   0% io   0% irq   0% sirq
Load average: 2.83 2.27 1.39 1/40 118
  PID  PPID USER     STAT   VSZ %VSZ %CPU COMMAND
  112    92 root     S    14480  25%  62% ./u8g2_hw_i2c_dvd
  118    92 root     R     1612   3%   5% top -d 1
   10     2 root     IW       0   0%   1% [rcu_preempt]
```


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
  cp output/images/arm-buildroot-linux-uclibcgnueabi_sdk-buildroot.tar.gz  (PATH TO SAVE YOUR TOOLCHAIN)/
  tar -xf (PATH TO SAVE YOUR TOOLCHAIN)/arm-buildroot-linux-uclibcgnueabi_sdk-buildroot.tar.gz
  # append on ~/.bashrc
  export PATH=$PATH:(PATH TO SAVE YOUR TOOLCHAIN)/arm-buildroot-linux-uclibcgnueabi_sdk-buildroot/bin
```
checkout toolchain (Make sure the command is executable in any folder.)
``` sh
  arm-buildroot-linux-uclibcgnueabi-gcc -v  
```
``` sh
xec/gcc/arm-buildroot-linux-uclibcgnueabi/13.4.0/lto-wrapper
Target: arm-buildroot-linux-uclibcgnueabi
Configured with: ./configure --prefix=/home/tsy/F1C200S/flash/buildroot-2025.02.9/output/host --sysconfdir=/home/tsy/F1C200S/flash/buildroot-2025.02.9/output/host/etc --enable-static --target=arm-buildroot-linux-uclibcgnueabi --with-sysroot=/home/tsy/F1C200S/flash/buildroot-2025.02.9/output/host/arm-buildroot-linux-uclibcgnueabi/sysroot --enable-__cxa_atexit --with-gnu-ld --disable-libssp --disable-multilib --disable-decimal-float --enable-plugins --enable-lto --with-gmp=/home/tsy/F1C200S/flash/buildroot-2025.02.9/output/host --with-mpc=/home/tsy/F1C200S/flash/buildroot-2025.02.9/output/host --with-mpfr=/home/tsy/F1C200S/flash/buildroot-2025.02.9/output/host --with-pkgversion='Buildroot -g86fd5e06' --with-bugurl=https://gitlab.com/buildroot.org/buildroot/-/issues --without-zstd --disable-libquadmath --disable-libquadmath-support --disable-libsanitizer --enable-tls --enable-threads --without-isl --without-cloog --with-float=soft --with-abi=aapcs-linux --with-cpu=arm926ej-s --with-float=soft --with-mode=arm --enable-languages=c --with-build-time-tools=/home/tsy/F1C200S/flash/buildroot-2025.02.9/output/host/arm-buildroot-linux-uclibcgnueabi/bin --enable-shared --disable-libgomp
Thread model: posix
Supported LTO compression algorithms: zlib
gcc version 13.4.0 (Buildroot -g86fd5e06) 
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

### Compile Application
``` sh
  cd f1c200s-u8g2-cmp/user
  # Modify Makefile SYSROOT=<YOUR BUILDROOT SYSROOT>
  make
```
  
### Flash to SPI-Flash
``` sh
  ./dd_flash.sh
  sudo sunxi-fel -p spiflash-write 0 flashimg.bin 
```

### Flash to SD-CARD
``` sh
  not supported on v2.x
```



  
