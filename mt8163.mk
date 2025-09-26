#
# SPDX-FileCopyrightText: 2025 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Overlays
PRODUCT_ENFORCE_RRO_TARGETS := *

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

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Inherit the proprietary files
$(call inherit-product, vendor/amazon/mt8163-common/mt8163-common-vendor.mk)
