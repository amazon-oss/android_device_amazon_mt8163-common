#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Bootanimation
TARGET_BOOTANIMATION_HALF_RES := true

# Display
PRODUCT_PACKAGES += \
    libion

# Lights
PRODUCT_PACKAGES += \
    lights.mt8163

# Media (OMX)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/media/,$(TARGET_COPY_OUT_SYSTEM)/etc)

PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/media_codecs_google_video_le.xml

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# Power
PRODUCT_PACKAGES += \
    power.mt8163

# Rootdir
PRODUCT_PACKAGES += \
    fstab.mt8163 \
    init.mt8163.rc \
    init.mt8163.power.rc \
    init.mt8163.usb.rc \
    ueventd.mt8163.rc

# Shims
PRODUCT_PACKAGES += \
    libamazonlog

# Wi-Fi
PRODUCT_PACKAGES += \
    hostapd \
    wpa_supplicant

# Inherit the proprietary files
$(call inherit-product, vendor/amazon/mt8163-common/mt8163-common-vendor.mk)
