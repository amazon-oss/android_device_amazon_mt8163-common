#
# SPDX-FileCopyrightText: 2025 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Android Go optimisations
$(call inherit-product, device/amazon/mt8163-common/go_opt.mk)

# Audio
PRODUCT_PACKAGES += \
    audio.bluetooth.default \
    audio.usb.default \
    audio.r_submix.default

PRODUCT_PACKAGES += \
    android.hardware.audio.service

PRODUCT_PACKAGES += \
    android.hardware.bluetooth.audio@2.0-impl

PRODUCT_PACKAGES += \
    libaudiopreprocessing \
    libbase_shim \
    libbluetooth_mtk_pure \
    libtinycompress \
    libalsautils \
    libnbaio_mono \
    libtinyxml

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/audio/,$(TARGET_COPY_OUT_VENDOR)/etc)

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_in_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml

# Amazon Init
PRODUCT_PACKAGES += \
    amazon_init

# Binder
PRODUCT_PACKAGES += \
    libhidltransport \
    libhidltransport.vendor \
    libhwbinder.vendor \
    libhwbinder

# Camera
PRODUCT_PACKAGES += \
    camera.device@1.0-impl \
    camera.device@3.2-impl \
    libsensorndkbridge

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml

# Display
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    disable_configstore

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm@1.3-service.clearkey

PRODUCT_PACKAGES += \
    libprotobuf-cpp-lite-v29

# Gatekeeper
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service.software

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-service \
    android.hardware.health@2.1-impl

# Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.1-service

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light-service.mt8163

# Livedisplay
PRODUCT_PACKAGES += \
    vendor.lineage.livedisplay@2.0-service-mt8163

# Media
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/media/,$(TARGET_COPY_OUT_VENDOR)/etc) \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/seccomp/,$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy)

PRODUCT_COPY_FILES += \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video_le.xml

PRODUCT_PACKAGES += \
    libui-v28

# Overlays
PRODUCT_ENFORCE_RRO_TARGETS := *
PRODUCT_PACKAGES += \
    FrameworksResOverlayMT8163

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
    init.insmod.sh \
    init.mt8163.rc \
    init.mt8163.usb.rc \
    init.mt8163.power.rc \
    ueventd.mt8163.rc

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-service \
    android.hardware.sensors@1.0-impl

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/amazon

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service.basic

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

# Wi-Fi
PRODUCT_PACKAGES += \
    hostapd \
    wpa_supplicant

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml

# Inherit the proprietary files
$(call inherit-product, vendor/amazon/mt8163-common/mt8163-common-vendor.mk)
