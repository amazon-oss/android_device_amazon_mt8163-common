#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# Rootdir
PRODUCT_PACKAGES += \
    fstab.mt8163 \
    init.mt8163.rc \
    init.mt8163.power.rc \
    init.mt8163.usb.rc \
    ueventd.mt8163.rc

# Inherit the proprietary files
$(call inherit-product, vendor/amazon/mt8163-common/mt8163-common-vendor.mk)
