/*
 * Copyright (C) 2019 The Android Open Source Project
 * Copyright (C) 2021-2022 KonstaKANG
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <signal.h>
#include <wakelock/wakelock.h>

int main() {
    android::wakelock::WakeLock wl{"suspend_blocker_mt8163"};  // RAII object

    sigset_t mask;
    sigemptyset(&mask);
    return sigsuspend(&mask);  // Infinite sleep
}
