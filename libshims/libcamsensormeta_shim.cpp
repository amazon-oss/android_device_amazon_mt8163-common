/*
 * Copyright (C) 2026 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <dlfcn.h>

namespace {

constexpr const char kHalSensor[] = "libcam.halsensor.so";
constexpr const char kMetadataProvider[] = "libcam.metadataprovider.so";
constexpr const char kMetadata[] = "libmtkcam_metadata.so";

// MTK_STATISTICS_INFO_AVAILABLE_FACE_DETECT_MODES, section 18 << 16.
constexpr unsigned int kAvailableFaceDetectModes = 0x120000;
constexpr unsigned char kFaceDetectModeOff = 0;

using ConstructMetadata = int (*)(void*, void*);

void* lookup(const char* library, const char* symbol) {
    void* handle = dlopen(library, RTLD_NOW);
    if (handle == nullptr) {
        return nullptr;
    }
    return dlsym(handle, symbol);
}

ConstructMetadata resolve(const char* library, const char* symbol) {
    return reinterpret_cast<ConstructMetadata>(lookup(library, symbol));
}

void denyFaceDetect(void* metadata) {
    using Ctor = void (*)(void*, unsigned int);
    using PushBack = void (*)(void*, const unsigned char*, int);
    using Update = int (*)(void*, unsigned int, const void*);
    using Dtor = void (*)(void*);

    static auto ctor = reinterpret_cast<Ctor>(
            lookup(kMetadata, "_ZN5NSCam9IMetadata6IEntryC1Ej"));
    static auto pushBack = reinterpret_cast<PushBack>(
            lookup(kMetadata, "_ZN5NSCam9IMetadata6IEntry9push_backERKhNS_9Type2TypeIhEE"));
    static auto update = reinterpret_cast<Update>(
            lookup(kMetadata, "_ZN5NSCam9IMetadata6updateEjRKNS0_6IEntryE"));
    static auto dtor = reinterpret_cast<Dtor>(
            lookup(kMetadata, "_ZN5NSCam9IMetadata6IEntryD1Ev"));

    if (ctor == nullptr || pushBack == nullptr || update == nullptr || dtor == nullptr) {
        return;
    }

    // Oversized on purpose, IEntry is a handful of words...
    alignas(8) unsigned char entry[512] = {};
    ctor(entry, kAvailableFaceDetectModes);
    pushBack(entry, &kFaceDetectModeOff, 0);
    update(metadata, kAvailableFaceDetectModes, entry);
    dtor(entry);
}

}  // namespace

#define ALIAS(alias, library, target)                             \
    extern "C" int alias(void* metadata, void* info) {            \
        static ConstructMetadata fn = resolve(library, #target);  \
        return fn != nullptr ? fn(metadata, info) : 0;            \
    }

#define ALIAS_NO_FACE_DETECT(alias, library, target)              \
    extern "C" int alias(void* metadata, void* info) {            \
        static ConstructMetadata fn = resolve(library, #target);  \
        if (fn == nullptr) {                                      \
            return 0;                                             \
        }                                                         \
        int status = fn(metadata, info);                          \
        denyFaceDetect(metadata);                                 \
        return status;                                            \
    }

ALIAS(constructCustStaticMetadata_DEVICE_CAMERA_SENSOR_DRVNAME_OV02B_MIPI_RAW, kHalSensor,
      constructCustStaticMetadata_DEVICE_CAMERA_SENSOR_DRVNAME_GC2375MIPI_RAW_CHXT_REAR)
ALIAS(constructCustStaticMetadata_DEVICE_FLASHLIGHT_SENSOR_DRVNAME_OV02B_MIPI_RAW, kHalSensor,
      constructCustStaticMetadata_DEVICE_FLASHLIGHT_SENSOR_DRVNAME_GC2375MIPI_RAW_CHXT_REAR)
ALIAS(constructCustStaticMetadata_DEVICE_LENS_SENSOR_DRVNAME_OV02B_MIPI_RAW, kHalSensor,
      constructCustStaticMetadata_DEVICE_LENS_SENSOR_DRVNAME_GC2375MIPI_RAW_CHXT_REAR)
ALIAS(constructCustStaticMetadata_DEVICE_SENSOR_SENSOR_DRVNAME_OV02B_MIPI_RAW, kHalSensor,
      constructCustStaticMetadata_DEVICE_SENSOR_SENSOR_DRVNAME_GC2375MIPI_RAW_CHXT_REAR)
ALIAS(constructCustStaticMetadata_DEVICE_TUNING_3A_SENSOR_DRVNAME_OV02B_MIPI_RAW, kHalSensor,
      constructCustStaticMetadata_DEVICE_TUNING_3A_SENSOR_DRVNAME_GC2375MIPI_RAW_CHXT_REAR)

ALIAS_NO_FACE_DETECT(constructCustStaticMetadata_DEVICE_FEATURE_SENSOR_DRVNAME_OV02B_MIPI_RAW,
                     kMetadataProvider,
                     constructCustStaticMetadata_DEVICE_FEATURE_SENSOR_DRVNAME_GC2375MIPI_RAW_CHXT_REAR)
ALIAS(constructCustStaticMetadata_DEVICE_REQUEST_SENSOR_DRVNAME_OV02B_MIPI_RAW, kMetadataProvider,
      constructCustStaticMetadata_DEVICE_REQUEST_SENSOR_DRVNAME_GC2375MIPI_RAW_CHXT_REAR)
ALIAS(constructCustStaticMetadata_DEVICE_SCALER_SENSOR_DRVNAME_OV02B_MIPI_RAW, kMetadataProvider,
      constructCustStaticMetadata_DEVICE_SCALER_SENSOR_DRVNAME_GC2375MIPI_RAW_CHXT_REAR)
ALIAS(constructCustRequestMetadata_SENSOR_DRVNAME_OV02B_MIPI_RAW, kMetadataProvider,
      constructCustRequestMetadata_SENSOR_DRVNAME_GC2375MIPI_RAW_CHXT_REAR)

ALIAS(constructCustStaticMetadata_DEVICE_CAMERA_SENSOR_DRVNAME_OV9734_MIPI_RAW, kHalSensor,
      constructCustStaticMetadata_DEVICE_CAMERA_SENSOR_DRVNAME_GC2375MIPI_RAW_CHXT_REAR)
ALIAS(constructCustStaticMetadata_DEVICE_FLASHLIGHT_SENSOR_DRVNAME_OV9734_MIPI_RAW, kHalSensor,
      constructCustStaticMetadata_DEVICE_FLASHLIGHT_SENSOR_DRVNAME_GC2375MIPI_RAW_CHXT_REAR)
ALIAS(constructCustStaticMetadata_DEVICE_LENS_SENSOR_DRVNAME_OV9734_MIPI_RAW, kHalSensor,
      constructCustStaticMetadata_DEVICE_LENS_SENSOR_DRVNAME_GC2375MIPI_RAW_CHXT_REAR)
ALIAS(constructCustStaticMetadata_DEVICE_SENSOR_SENSOR_DRVNAME_OV9734_MIPI_RAW, kHalSensor,
      constructCustStaticMetadata_DEVICE_SENSOR_SENSOR_DRVNAME_GC2375MIPI_RAW_CHXT_REAR)
ALIAS(constructCustStaticMetadata_DEVICE_TUNING_3A_SENSOR_DRVNAME_OV9734_MIPI_RAW, kHalSensor,
      constructCustStaticMetadata_DEVICE_TUNING_3A_SENSOR_DRVNAME_GC2375MIPI_RAW_CHXT_REAR)

ALIAS_NO_FACE_DETECT(constructCustStaticMetadata_DEVICE_FEATURE_SENSOR_DRVNAME_OV9734_MIPI_RAW,
                     kMetadataProvider,
                     constructCustStaticMetadata_DEVICE_FEATURE_SENSOR_DRVNAME_GC2375MIPI_RAW_CHXT_REAR)
ALIAS(constructCustStaticMetadata_DEVICE_REQUEST_SENSOR_DRVNAME_OV9734_MIPI_RAW, kMetadataProvider,
      constructCustStaticMetadata_DEVICE_REQUEST_SENSOR_DRVNAME_GC2375MIPI_RAW_CHXT_REAR)
ALIAS(constructCustStaticMetadata_DEVICE_SCALER_SENSOR_DRVNAME_OV9734_MIPI_RAW, kMetadataProvider,
      constructCustStaticMetadata_DEVICE_SCALER_SENSOR_DRVNAME_GC2375MIPI_RAW_CHXT_REAR)
ALIAS(constructCustRequestMetadata_SENSOR_DRVNAME_OV9734_MIPI_RAW, kMetadataProvider,
      constructCustRequestMetadata_SENSOR_DRVNAME_GC2375MIPI_RAW_CHXT_REAR)
