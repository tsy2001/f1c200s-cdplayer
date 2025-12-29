#!/bin/sh
set -eu

UBOOT_FILE=./f1c200s-uboot/u-boot-sunxi-with-spl.bin
#UBOOT_FILE=./u-boot-2025.04/u-boot-sunxi-with-spl.bin
DTB_FILE=./f1c200s-linux5.7/arch/arm/boot/dts/suniv-f1c100s-licheepi-nano.dtb
KERNEL_FILE=./f1c200s-linux5.7/arch/arm/boot/zImage
ROOTFS_TAR=./buildroot-2025.02.9/output/images/rootfs.tar
APP_FILE=./f1c200s-u8g2-cmp/output/bin/u8g2_hw_i2c_dvd

FLASH_SIZE=$((16 * 1024 * 1024))

# 分区（按你当前布局）
UBOOT_MAX=$((0x4B000))
DTB_MAX=$((0x5000))
KERNEL_MAX=$((0x300000))
ROOTFS_MAX=$((0xCB0000))

DTB_OFF=$((0x4B000))
KERNEL_OFF=$((0x50000))
ROOTFS_OFF=$((0x350000))

need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing tool: $1"; exit 1; }; }
need dd
need tar
need mkfs.jffs2
need python3
need stat

check_size() {
  f="$1"; max="$2"
  sz=$(stat -c%s "$f")
  if [ "$sz" -gt "$max" ]; then
    printf "ERROR: %s too large: %d > %d bytes\n" "$f" "$sz" "$max"
    exit 1
  fi
}

check_size "$UBOOT_FILE"  "$UBOOT_MAX"
check_size "$DTB_FILE"    "$DTB_MAX"
check_size "$KERNEL_FILE" "$KERNEL_MAX"

rm -f flashimg.bin jffs2.img
rm -rf rootfs

# 1) 生成 16MB、全 0xFF 的镜像（SPI-NOR 擦除态）
python3 - <<PY
size = $FLASH_SIZE
with open("flashimg.bin", "wb") as f:
    f.write(b"\xFF" * size)
PY

# 2) 写入各分区
dd if="$UBOOT_FILE"  of=flashimg.bin bs=1 seek=0           conv=notrunc
dd if="$DTB_FILE"    of=flashimg.bin bs=1 seek=$DTB_OFF    conv=notrunc
dd if="$KERNEL_FILE" of=flashimg.bin bs=1 seek=$KERNEL_OFF conv=notrunc

# 3) 准备 rootfs 目录并注入 app
mkdir -p rootfs
tar -xf "$ROOTFS_TAR" -C rootfs

mkdir -p rootfs/app
install -m 0755 "$APP_FILE" rootfs/app/u8g2_hw_i2c_dvd

# 4) 生成 JFFS2（SPI-NOR：eraseblock=0x10000；建议加 -n 禁用 cleanmarker）
mkfs.jffs2 -e 0x10000 -n --pad=$ROOTFS_MAX -d rootfs -o jffs2.img

# 保险：校验 jffs2.img 不超过 rootfs 分区
check_size "jffs2.img" "$ROOTFS_MAX"

dd if=jffs2.img of=flashimg.bin bs=1 seek=$ROOTFS_OFF conv=notrunc

rm -rf rootfs jffs2.img

echo "OK: flashimg.bin generated"

