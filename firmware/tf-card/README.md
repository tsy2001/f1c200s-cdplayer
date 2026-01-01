# 制作SD卡启动盘  
此操作会清空你SD卡所有数据！  

### SD卡分区
``` sh
# 将读卡器连接虚拟机
sudo umount /dev/sdb1
sudo fdisk /dev/sdb
# 若有其他分区按 d 删除各个分区
# 第一分区操作：n p 1 2048 +16M y
# 第二分区操作：n 后面全部回车默认即可 y
# w 保存写入并退出
```
### SD卡格式化
``` sh
# 将第一分区格式化成FAT
sudo mkfs.vfat /dev/sdb1 
# 将第一分区格式化成EXT4
sudo mkfs.ext4 /dev/sdb2 
```
### 写入uboot
``` sh
sudo dd if=u-boot-sdcard.bin of=/dev/sdb bs=1024 seek=8
```
### 拷贝系统
``` sh
# 复制 zImage 和 univ-f1c100s-licheepi-nano.dtb 到第一个FAT分区
sudo tar -xf rootfs.tar -C /media/<username>/<your sdcard sdb2 partition>/
# 一定要sync
sync
# 建议删除rootfs/etc/init.d/S90APP自启动脚本，调试阶段最好还是不要让应用自启动，之后可以手动加回来
```