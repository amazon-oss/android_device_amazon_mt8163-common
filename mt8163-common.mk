#
# Copyright (C) 2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Display
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    android.hardware.renderscript@1.0-impl

PRODUCT_PACKAGES += \
    libion \
    libgralloc_extra \
    libgui_ext \
    libui_ext

# Overlays
PRODUCT_ENFORCE_RRO_TARGETS := *

# Recovery
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/init.recovery.mt8163.rc:recovery/root/init.recovery.mt8163.rc

PRODUCT_PACKAGES += \
    amazon_init.recovery

# Rootdir
PRODUCT_PACKAGES += \
    fstab.mt8163 \
    fstab.mt8163_ramdisk \
    init.mt8163.rc \
    init.mt8163.usb.rc \
    ueventd.mt8163.rc

PRODUCT_PACKAGES += \
    amazon_init

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/amazon \
    hardware/mediatek

# Inherit the proprietary files
$(call inherit-product, vendor/amazon/mt8163-common/mt8163-common-vendor.mk)
