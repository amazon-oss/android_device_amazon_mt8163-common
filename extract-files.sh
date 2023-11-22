#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

ONLY_COMMON=
ONLY_TARGET=
KANG=
SECTION=

while [ "${#}" -gt 0 ]; do
    case "${1}" in
        --only-common )
                ONLY_COMMON=true
                ;;
        --only-target )
                ONLY_TARGET=true
                ;;
        -n | --no-cleanup )
                CLEAN_VENDOR=false
                ;;
        -k | --kang )
                KANG="--kang"
                ;;
        -s | --section )
                SECTION="${2}"; shift
                CLEAN_VENDOR=false
                ;;
        * )
                SRC="${1}"
                ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

function blob_fixup() {
    case "${1}" in
        bin/6620_launcher)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        bin/bin/aal)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        bin/ged_srv)
            patchelf --add-needed "libcutils_shim.so" "${2}"
            ;;
        bin/guiext-server)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        bin/kisd)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        bin/rpmb_svc)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        bin/wmt_loader)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/egl/libGLES_mali.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libutilscallstack.so" "${2}"
            ;;
        lib*/hw/audio.primary.mt8163.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/hw/gralloc.mt8163.mali.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libmemset_shim.so" "${2}"
            ;;
        lib*/hw/hwcomposer.mt8163.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libcutils_shim.so" "${2}"
            ;;
        lib*/hw/memtrack.mt8163.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/hw/amzn_dha.mt8163.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/hw/thermal.mt8163.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/hw/keystore.mt8163.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libMtkOmxAIVPlayer.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libcutils_shim.so" "${2}"
            ;;
        lib*/libMtkOmxCore.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libMtkOmxMp3Dec.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libMtkOmxVdecEx.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libcutils_shim.so" "${2}"
            ;;
        lib*/libMtkOmxVenc.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libcutils_shim.so" "${2}"
            ;;
        lib*/lib_uree_mtk_modular_drm.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/lib_uree_mtk_video_secure_al.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libaal.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libaal_cust.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libaudiocomponentengine.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libaudiocustparam.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libaudiostream.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libcutils_shim.so" "${2}"
            ;;
        lib*/libaudiostream_jni.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libbluetooth_hw_test.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libbluetooth_jni.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libbluetooth_mtk.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libbluetooth_mtk_pure.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libbluetooth_relayer.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libbluetoothem_mtk.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libdrmmtkwhitelist.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libgpu_aux.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libcutils_shim.so" "${2}"
            ;;
        lib*/libm4u.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libmtk_mmutils)
            patchelf --add-needed "libcutils_shim.so" "${2}"
            ;;
        lib*/libnvram_daemon_callback.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libsensors.mt8163.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libsmartvolume.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libthermalservice.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libtz_uree.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        lib*/libvcodecdrv.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libcutils_shim.so" "${2}"
            ;;
    esac
}

if [ -z "${ONLY_TARGET}" ]; then
    # Initialize the helper for common device
    setup_vendor "${DEVICE_COMMON}" "${VENDOR_COMMON:-$VENDOR}" "${ANDROID_ROOT}" true "${CLEAN_VENDOR}"

    extract "${MY_DIR}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"
fi

if [ -z "${ONLY_COMMON}" ] && [ -s "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-files.txt" ]; then
    # Reinitialize the helper for device
    source "${MY_DIR}/../../${VENDOR}/${DEVICE}/extract-files.sh"
    setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

    extract "${MY_DIR}/../../${VENDOR}/${DEVICE}/proprietary-files.txt" "${SRC}" "${KANG}" --section "${SECTION}"
fi

"${MY_DIR}/setup-makefiles.sh"
