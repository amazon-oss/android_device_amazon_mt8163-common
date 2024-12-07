#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

## AAPT
PRODUCT_AAPT_CONFIG := normal mdpi
PRODUCT_AAPT_PREF_CONFIG := mdpi
TARGET_RECOVERY_DENSITY := hdpi

# Audio
PRODUCT_PACKAGES += \
    audio.a2dp.default \
    audio.r_submix.default \
    audio.usb.default

PRODUCT_PACKAGES += \
    libalsautils \
    libaudioroute \
    libaudio-resampler \
    libtinyalsa \
    libtinycompress \
    libtinyxml \
    tinymix

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/audio/,$(TARGET_COPY_OUT_SYSTEM)/etc)

# Display
PRODUCT_PACKAGES += \
    libion

PRODUCT_PACKAGES += \
    libgui_ext \
    libui_ext \
    libgralloc_extra

# Lights
PRODUCT_PACKAGES += \
    lights.mt8163

# Media (OMX)
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/media/,$(TARGET_COPY_OUT_SYSTEM)/etc)

PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/media_codecs_google_video_le.xml

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/seccomp_policy/,$(TARGET_COPY_OUT_SYSTEM)/etc/seccomp_policy/)

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# Power
PRODUCT_PACKAGES += \
    power.mt8163

# Rootdir
PRODUCT_PACKAGES += \
    fstab.mt8163 \
    init.mt8163.rc \
    init.mt8163.usb.rc \
    ueventd.mt8163.rc

# Wi-Fi
PRODUCT_PACKAGES += \
    lib_driver_cmd_mt66xx \
    libwifi-hal-mt66xx \
    libwpa_client

PRODUCT_PACKAGES += \
    hostapd \
    hostapd_cli \
    wpa_cli

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/wifi,$(TARGET_COPY_OUT_SYSTEM)/etc/wifi)

# Call dalvik heap config
$(call inherit-product, frameworks/native/build/tablet-7in-hdpi-1024-dalvik-heap.mk)

# Call hwui memory config
$(call inherit-product-if-exists, frameworks/native/build/phone-xxhdpi-2048-hwui-memory.mk)

# Inherit the proprietary files
$(call inherit-product, vendor/amazon/mt8163-common/mt8163-common-vendor.mk)
