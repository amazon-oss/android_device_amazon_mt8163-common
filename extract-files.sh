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
        vendor/bin/6620_launcher)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libbinder_shim.so" "${2}"
            ;;
        vendor/bin/amzn_dha_hmac|vendor/bin/amzn_dha_tool)
            patchelf --add-needed "libcrypto_shim.so" "${2}"
            patchelf --add-needed "libssl_shim.so" "${2}"
            ;;
        vendor/bin/ged_srv)
            patchelf --add-needed "libcutils_shim.so" "${2}"
            ;;
        vendor/bin/guiext-server)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/bin/kisd)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/bin/rpmb_svc)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/bin/wmt_loader)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/bin/hw/android.hardware.wifi@1.0-service-mediatek)
            patchelf --add-needed "libcompiler_rt-v29.so" "${2}"
            ;;
        vendor/bin/hw/hostapd)
            patchelf --add-needed "libcompiler_rt-v29.so" "${2}"
            ;;
        vendor/bin/hw/wpa_supplicant)
            patchelf --add-needed "libcompiler_rt-v29.so" "${2}"
            ;;
        vendor/lib*/egl/libGLES_mali.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libutilscallstack.so" "${2}"
            patchelf --replace-needed "libui.so" "libui-v28.so" "${2}"
            ;;
        vendor/lib*/hw/amzn_dha.mt8163.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/lib*/hw/audio.primary_amazon.mt8163.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libcompiler_rt.so" "${2}"
            patchelf --add-needed "libcutils_shim.so" "${2}"
            ;;
        vendor/lib*/hw/camera.primary.mt8163.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/hw/gralloc.mt8163.mali.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libmemset_shim.so" "${2}"
            ;;
        vendor/lib*/hw/hwcomposer.mt8163.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libcutils_shim.so" "${2}"
            patchelf --add-needed "libui_shim.so" "${2}"
            sed -i 's|_ZN7android19GraphicBufferMapper4lockEPK13native_handleiRKNS_4RectEPPv|_ZN7android19GraphicBufferMapper4lockEPK13native_handlejRKNS_4RectEPPv|g' "${2}"
            ;;
        vendor/lib*/hw/keystore.mt8163.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/lib*/hw/memtrack.mt8163.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/lib*/hw/thermal.mt8163.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/lib*/lib3a.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libGdmaScalerPipe.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libJpgDecPipe.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libJpgEncPipe.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libGdmaScalerPipe.so)
            patchelf --add-needed "libcutils_shim.so" "${2}"
            ;;
        vendor/lib*/libMtkOmxAIVPlayer.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libcutils_shim.so" "${2}"
            patchelf --add-needed "libgui_shim.so" "${2}"
            ;;
        vendor/lib*/libMtkOmxCore.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/lib*/libMtkOmxMp3Dec.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/lib*/libMtkOmxVdecEx.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libcutils_shim.so" "${2}"
            patchelf --add-needed "libui_shim.so" "${2}"
            sed -i 's|_ZN7android19GraphicBufferMapper4lockEPK13native_handleiRKNS_4RectEPPv|_ZN7android19GraphicBufferMapper4lockEPK13native_handlejRKNS_4RectEPPv|g' "${2}"
            ;;
        vendor/lib*/libMtkOmxVenc.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libcutils_shim.so" "${2}"
            patchelf --add-needed "libui_shim.so" "${2}"
            ;;
        vendor/lib*/libSwJpgCodec.so)
            patchelf --add-needed "libcutils_shim.so" "${2}"
            ;;
        vendor/lib*/libSwJpgCodec.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/lib_uree_mtk_modular_drm.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/lib*/lib_uree_mtk_video_secure_al.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/lib*/libaudiocomponentengine.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libutilscallstack.so" "${2}"
            ;;
        vendor/lib*/libaudiocustparam.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/lib*/libaudiostream.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libbinder_shim.so" "${2}"
            patchelf --add-needed "libcutils_shim.so" "${2}"
            ;;
        vendor/lib*/libaudiostream_jni.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/lib*/libbwc.so)
            patchelf --add-needed "libutils_shim.so" "${2}"
            patchelf --add-needed "libxlog.so" "${2}"
            sed -i 's/_ZN7android6Thread3run/_ZN7android6Custom3run/g' "${2}"
            ;;
        vendor/lib*/libcam.camadapter.so)
            patchelf --add-needed "libutils_shim.so" "${2}"
            patchelf --add-needed "libxlog.so" "${2}"
            patchelf --replace-needed "libskia.so" "libhwui.so" "${2}"
            sed -i 's/_ZN7android6Thread3run/_ZN7android6Custom3run/g' "${2}"
            ;;
        vendor/lib*/libcam.campipe.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libcam.camshot.so)
            patchelf --add-needed "libutils_shim.so" "${2}"
            patchelf --add-needed "libxlog.so" "${2}"
            sed -i 's/_ZN7android6Thread3run/_ZN7android6Custom3run/g' "${2}"
            ;;
        vendor/lib*/libcam.device1.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libcam.device3.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libcam.exif.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libcam.exif.v3.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libcam.hal3a.v3.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libcam.halsensor.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libcam.iopipe.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libcam.iopipe_FrmB.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libcam.metadata.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libcam.metadataprovider.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libcam.paramsmgr.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libcamdrv.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libcam.sdkclient.so)
            patchelf --add-needed "libutils_shim.so" "${2}"
            patchelf --add-needed "libxlog.so" "${2}"
            sed -i 's/_ZN7android6Thread3run/_ZN7android6Custom3run/g' "${2}"
            ;;
        vendor/lib*/libcam.utils.so)
            patchelf --add-needed "libutilscallstack.so" "${2}"
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libcam.utils.sensorlistener.so)
            patchelf --add-needed "libpthread_shim.so" "${2}"
            patchelf --add-needed "libsensor.so" "${2}"
            patchelf --add-needed "libutils_shim.so" "${2}"
            sed -i 's/_ZN7android6Thread3run/_ZN7android6Custom3run/g' "${2}"
            ;;
        vendor/lib*/libcam1_utils.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libcam1client.so)
            patchelf --add-needed "libui_shim.so" "${2}"
            patchelf --add-needed "libutils_shim.so" "${2}"
            patchelf --add-needed "libxlog.so" "${2}"
            sed -i 's/_ZN7android6Thread3run/_ZN7android6Custom3run/g' "${2}"
            ;;
        vendor/lib*/libcam3_app.so)
            patchelf --add-needed "libutils_shim.so" "${2}"
            patchelf --add-needed "libxlog.so" "${2}"
            sed -i 's/_ZN7android6Thread3run/_ZN7android6Custom3run/g' "${2}"
            ;;
        vendor/lib*/libcam3_hwnode.so)
            patchelf --add-needed "libutils_shim.so" "${2}"
            patchelf --add-needed "libxlog.so" "${2}"
            sed -i 's/_ZN7android6Thread3run/_ZN7android6Custom3run/g' "${2}"
            ;;
        vendor/lib*/libcam3_hwpipeline.so)
            patchelf --add-needed "libutils_shim.so" "${2}"
            patchelf --add-needed "libxlog.so" "${2}"
            sed -i 's/_ZN7android6Thread3run/_ZN7android6Custom3run/g' "${2}"
            ;;
        vendor/lib*/libcam3_pipeline.so)
            patchelf --add-needed "libutils_shim.so" "${2}"
            patchelf --add-needed "libxlog.so" "${2}"
            sed -i 's/_ZN7android6Thread3run/_ZN7android6Custom3run/g' "${2}"
            ;;
        vendor/lib*/libcam3_utils.so)
            patchelf --add-needed "libutils_shim.so" "${2}"
            sed -i 's/_ZN7android6Thread3run/_ZN7android6Custom3run/g' "${2}"
            ;;
        vendor/lib*/libcam_platform.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libcam_utils.so)
            patchelf --add-needed "libui_shim.so" "${2}"
            patchelf --add-needed "libutilscallstack.so" "${2}"
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libcamalgo.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libcameracustom.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libdpframework.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libdrmmtkutil.so)
            patchelf --add-needed "libbinder_shim.so" "${2}"
            ;;
        vendor/lib*/libdrmmtkwhitelist.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/lib*/libged.so)
            patchelf --add-needed "libcutils_shim.so" "${2}"
            ;;
        vendor/lib*/libfeatureio.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libfeatureiodrv.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libgpu_aux.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libcutils_shim.so" "${2}"
            ;;
        vendor/lib*/libimageio.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libimageio_FrmB.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libimageio_plat_drv.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libimageio_plat_drv_FrmB.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libm4u.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/lib*/libmmsdkservice.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libmtk_mmutils.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            patchelf --add-needed "libcutils_shim.so" "${2}"
            patchelf --add-needed "libui_shim.so" "${2}"
            ;;
        vendor/lib*/libnvram_daemon_callback.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/lib*/libnvramagentclient.so)
            patchelf --add-needed "libbinder_shim.so" "${2}"
            ;;
        vendor/lib*/libpq_prot.so)
            patchelf --add-needed "libxlog.so" "${2}"
            ;;
        vendor/lib*/libsensors.mt8163.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/lib*/libsmartvolume.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/lib*/libthermalservice.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/lib*/libtz_uree.so)
            patchelf --add-needed "libamazonlog.so" "${2}"
            ;;
        vendor/lib*/libvcodecdrv.so)
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
