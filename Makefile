#
# Copyright (C) 2021 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=ufp
PKG_VERSION:=1

PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Felix Fietkau <nbd@nbd.name>

PKG_BUILD_DEPENDS:=bpf-headers

include $(INCLUDE_DIR)/package.mk

define Package/ufp
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Device fingerprinting daemon
  DEPENDS:=+ucode +ucode-mod-fs
endef

define Build/Compile
	ucode ./scripts/convert-devices.uc ./data/*.json > $(PKG_BUILD_DIR)/devices.json
endef

define Package/ufp/conffiles
/etc/config/ufp
endef

define Package/ufp/install
	$(INSTALL_DIR) $(1)/usr/share/ufp
	$(CP) $(PKG_BUILD_DIR)/devices.json $(1)/usr/share/ufp/
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,ufp))
