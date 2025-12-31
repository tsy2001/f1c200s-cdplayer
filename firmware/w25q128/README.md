# flash烧录  
仅支持W25Q128系列NOR FLASH存储器!!! 

## 全量烧录
flashimg.bin为全量镜像，初次使用只需烧录这一个  
``` sh
sudo sunxi-fel -p spiflash-write 0 flashimg.bin 
```
注: uboot对cpu和ddr进行超频，CPU 720MHz,DDR 168MHz,如果你的uboot启动不来请单独再烧一遍这个  
``` sh
sudo sunxi-fel -p spiflash-write 0 u-boot-no-overclocking.bin 
```

## flash分区表
|分区序号  |分区大小            |分区作用	   |地址空间及分区名                  |
| --------| ---------------- |------------ | ----------------------------- |
|mtd0     |300KB (0x04B000)   |spl+uboot   |0x0000000-0x004B000 : “uboot”  |
|mtd1     |20KB (0x005000)    |dtb文件      |0x004B000-0x0050000 : “dtb”    |
|mtd2     |3072KB (0x300000)  |linux内核	|0x0050000-0x0350000 : “kernel”  |
|mtd3     |12992KB(0xCB0000)  |根文件系统    |0x0350000-0x1000000 : “rootfs”  |

## 分段烧录
./single files/下为uboot、kernel、设备树、app单独编译出的二进制文件，需根据分区表地址依次烧录
``` sh
#uboot:
sudo sunxi-fel -p spiflash-write 0 u-boot-sunxi-with-spl.bin
#dtb:
sudo sunxi-fel -p spiflash-write 0x4B000 suniv-f1c100s-licheepi-nano.dtb
#kernel
sudo sunxi-fel -p spiflash-write 0x50000 zImage
#rootfs
tar -xf rootfs.tar
cp u8g2_hw_i2c_dvd ./rootfs/app/u8g2_hw_i2c_dvd
chmod +x ./rootfs/app/u8g2_hw_i2c_dvd
mkfs.jffs2 -s 0x100 -e 0x10000 --pad=0xCB0000 -d rootfs/ -o jffs2.img
sudo sunxi-fel -p spiflash-write 0x350000 jffs2.img
```