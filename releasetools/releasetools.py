#!/bin/env python3
#
# Copyright (C) 2025 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import common

BLOCK_DEVICE_DIR = "/dev/block/platform/soc/11230000.mmc/"
BY_NAME_SYMLINK = "/dev/block/platform/soc/11230000.mmc/by-name"
BY_NAME_TARGET = "/dev/block/platform/soc/by-name/"

def FullOTA_Assertions(info):
  SetupBlockDevicePaths(info)
  return

def IncrementalOTA_Assertions(info):
  SetupBlockDevicePaths(info)
  return

def SetupBlockDevicePaths(info):
  info.script.AppendExtra('run_program("/sbin/mkdir", "-p", "{}");'.format(BLOCK_DEVICE_DIR))
  info.script.AppendExtra('run_program("/sbin/ln", "-sf", "{}", "{}");'.format(BY_NAME_TARGET, BY_NAME_SYMLINK))
