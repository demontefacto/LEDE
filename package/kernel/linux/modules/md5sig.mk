include $(INCLUDE_DIR)/kernel.mk

# name
PKG_NAME:=md5sig
PKG_VERSION:=1.0
PKG_RELEASE:=0

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)
PKG_CHECK_FORMAT_SECURITY:=0

include $(INCLUDE_DIR)/package.mk

define KernelPackage/$(PKG_NAME)
    SUBMENU:=Other modules
    TITLE:=TCP md5 sig support
    KCONFIG:=CONFIG_TCP_MD5SIG
    FILES:=$(LINUX_DIR)/crypto/md5sig.ko
endef

define KernelPackage/$(PKG_NAME)/description
    md5 sig support
endef

define Build/Prepare
    mkdir -p $(PKG_BUILD_DIR)
    $(CP) ./src/* $(PKG_BUILD_DIR)/
endef

MAKE_OPTS:= \
    ARCH="$(LINUX_KARCH)" \
    CROSS_COMPILE="$(TARGET_CROSS)" \
    SUBDIRS="$(PKG_BUILD_DIR)"

define Build/Compile
    $(MAKE) -C "$(LINUX_DIR)" \
        $(MAKE_OPTS) \
        CONFIG_TCP_MD5SIG=m \ # THIS LINE IS MISSING
        modules
endef

$(eval $(call KernelPackage,$(PKG_NAME)))