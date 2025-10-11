//
// SPDX-FileCopyrightText: 2025 The LineageOS Project
// SPDX-License-Identifier: Apache-2.0
//

int mtk_bt_op(int opcode, void *param)
{
    // Audio HAL uses this to query BT SCO capabilities of the current
    // connectivity chipset. However, this breaks down when either:
    // - The current chipset is not supported by the libbluetooth_mtk_pure.so lib
    // - The current chipset is not a MediaTek one.
    // If mtk_bt_op fails, then the Audio HAL just crashes before playing audio
    // via bluetooth.
    // So instead, we provide a stub function that returns 0 to keep the HAL happy.
    return 0;
}
