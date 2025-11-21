#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================

# 修改uhttpd配置文件，启用nginx
# sed -i "/.*uhttpd.*/d" .config
# sed -i '/.*\/etc\/init.d.*/d' package/network/services/uhttpd/Makefile
# sed -i '/.*.\/files\/uhttpd.init.*/d' package/network/services/uhttpd/Makefile
sed -i "s/:80/:81/g" package/network/services/uhttpd/files/uhttpd.config
sed -i "s/:443/:4443/g" package/network/services/uhttpd/files/uhttpd.config
cp -a $GITHUB_WORKSPACE/configfiles/etc/* package/base-files/files/etc/
# ls package/base-files/files/etc/


# 追加binder内核参数
echo "CONFIG_PSI=y
CONFIG_KPROBES=y" >> target/linux/rockchip/armv8/config-6.6


# 集成CPU性能跑分脚本
cp -f $GITHUB_WORKSPACE/configfiles/coremark/coremark-arm64 package/base-files/files/bin/coremark-arm64
cp -f $GITHUB_WORKSPACE/configfiles/coremark/coremark-arm64.sh package/base-files/files/bin/coremark.sh
chmod 755 package/base-files/files/bin/coremark-arm64
chmod 755 package/base-files/files/bin/coremark.sh


# iStoreOS-settings
git clone --depth=1 -b main https://github.com/xiaomeng9597/istoreos-settings package/default-settings


# 定时限速插件
git clone --depth=1 https://github.com/sirpdboy/luci-app-eqosplus package/luci-app-eqosplus



# 增加bdy_g18-pro
# echo -e "\\ndefine Device/bdy_g18-pro
# \$(call Device/Legacy/rk3568,\$(1))
#   DEVICE_VENDOR := BDY
#   DEVICE_MODEL := G18
#   DEVICE_DTS := rk3568/rk3568-bdy-g18-pro
#   DEVICE_PACKAGES += kmod-nvme kmod-ata-ahci-dwc kmod-hwmon-pwmfan kmod-thermal kmod-switch-rtl8306 kmod-switch-rtl8366-smi kmod-switch-rtl8366rb kmod-switch-rtl8366s kmod-switch-rtl8367b swconfig kmod-swconfig kmod-r8169 kmod-mt7615-firmware
# endef
# TARGET_DEVICES += bdy_g18-pro" >> target/linux/rockchip/image/legacy.mk

#增加bd_1rt
echo -e "\\ndefine Device/bd_1rt
\$(call Device/Legacy/rk3568,\$(1))
  DEVICE_VENDOR := BD
  DEVICE_MODEL := 1RT
  DEVICE_DTS := rk3568/rk3568-bd-1rt
  DEVICE_PACKAGES += kmod-nvme kmod-ata-ahci-dwc kmod-hwmon-pwmfan kmod-thermal kmod-switch-rtl8366s kmod-switch-rtl8367 kmod-switch-rtl8367b swconfig kmod-swconfig
endef
TARGET_DEVICES += bd_1rt" > target/linux/rockchip/image/legacy.mk

#增加对RTL8211F、RLT8367S支持
#cp -f target/linux/generic/pending-6.6/721-net-phy-realtek-support-combo-mode-for-RTL8211FS.patch target/linux/generic/hack-6.6/721-net-phy-realtek-support-combo-mode-for-RTL8211FS.patch

# 复制 02_network 网络配置文件到 target/linux/rockchip/armv8/base-files/etc/board.d/ 目录下
rm -f target/linux/rockchip/armv8/base-files/etc/board.d/02_network
cp -f $GITHUB_WORKSPACE/configfiles/02_network target/linux/rockchip/armv8/base-files/etc/board.d/02_network


# 加入初始化交换机脚本
cp -f $GITHUB_WORKSPACE/configfiles/swconfig_install package/base-files/files/etc/init.d/swconfig_install
chmod 755 package/base-files/files/etc/init.d/swconfig_install


# 集成 nsy_g68-plus WiFi驱动
#mkdir -p package/base-files/files/lib/firmware/mediatek
#cp -f $GITHUB_WORKSPACE/configfiles/WirelessDriver/mt7916_eeprom.bin package/base-files/files/lib/firmware/mediatek/mt7916_eeprom.bin


# rtl8367b驱动资源包，暂时使用这样替换
wget https://github.com/xiaomeng9597/files/releases/download/files/rtl8367b.tar.gz
tar -xvf rtl8367b.tar.gz


# 复制dts设备树文件到指定目录下
#cp -f $GITHUB_WORKSPACE/configfiles/dts/rk3568-bdy-g18-pro.dts target/linux/rockchip/dts/rk3568/rk3568-bdy-g18-pro.dts
cp -f $GITHUB_WORKSPACE/configfiles/dts/rk3568-bd-1rt.dts target/linux/rockchip/dts/rk3568/rk3568-bd-1rt.dts

