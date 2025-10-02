#
# SPDX-FileCopyrightText: 2025 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Audio
PRODUCT_PACKAGES += \
    audio.usb.default \
    audio.r_submix.default

PRODUCT_PACKAGES += \
    android.hardware.audio.service

PRODUCT_PACKAGES += \
    android.hardware.audio@2.0.vendor \
    android.hardware.audio@4.0.vendor \
    android.hardware.audio.common-util.vendor \
    android.hardware.audio.common@4.0-util-v28 \
    android.hardware.audio.effect@2.0.vendor \
    android.hardware.audio.effect@4.0.vendor

PRODUCT_PACKAGES += \
    libaudiopreprocessing \
    libtinycompress \
    libalsautils \
    libnbaio_mono \
    libtinyxml

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/audio/,$(TARGET_COPY_OUT_VENDOR)/etc)

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml

# Binder
PRODUCT_PACKAGES += \
    libhidltransport \
    libhidltransport.vendor \
    libhwbinder.vendor \
    libhwbinder

# Display
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    disable_configstore

# Overlays
PRODUCT_ENFORCE_RRO_TARGETS := *

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.faketouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.faketouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/tablet_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/tablet_core_hardware.xml

# Recovery
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init/init.recovery.mt8163.rc:recovery/root/init.recovery.mt8163.rc \
    $(LOCAL_PATH)/init/init.recovery.mt8163.sh:recovery/root/init.recovery.mt8163.sh

# Rootdir
ifeq ($(TARGET_HAS_VENDOR_PARTITION),true)
_fstab_variant := vendor
else
_fstab_variant := legacy
endif
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init/fstab.mt8163_$(_fstab_variant):$(TARGET_COPY_OUT_VENDOR)/etc/fstab.mt8163 \
    $(LOCAL_PATH)/init/fstab.mt8163_$(_fstab_variant):$(TARGET_COPY_OUT_RAMDISK)/fstab.mt8163

PRODUCT_PACKAGES += \
    init.mt8163.rc \
    init.mt8163.usb.rc \
    init.mt8163.power.rc \
    ueventd.mt8163.rc

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Inherit the proprietary files
$(call inherit-product, vendor/amazon/mt8163-common/mt8163-common-vendor.mk)
