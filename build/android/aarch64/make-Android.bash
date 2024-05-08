#!/bin/bash

BUILD_TYPE="Release"
ANDROID_ABI="arm64-v8a"
ANDROID_STL="c++_shared"

#Specify Android NDK path if needed
ANDROID_NDK="/home/meonardo/Android/gstreamer/1.22.9/cerbero/build/android-ndk-21"

#Specify cmake if needed
CMAKE_PROGRAM=cmake

for ARG in "$@"; do
  if [[ "$ARG" == "-c" ]]; then
    clear
  fi
done

MPP_PWD=`pwd`

source ../env_setup.sh

${CMAKE_PROGRAM} -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN_FILE}                   \
      -DCMAKE_BUILD_TYPE=${BUILD_TYPE}                                      \
      -DCMAKE_MAKE_PROGRAM=${MAKE_PROGRAM}                                  \
      -DANDROID_FORCE_ARM_BUILD=ON                                          \
      -DANDROID_NDK=${ANDROID_NDK}                                          \
      -DANDROID_SYSROOT=${PLATFORM}                                         \
      -DANDROID_ABI=${ANDROID_ABI}                                          \
      -DANDROID_TOOLCHAIN_NAME=${TOOLCHAIN_NAME}                            \
      -DANDROID_NATIVE_API_LEVEL=${NATIVE_API_LEVEL}                        \
      -DANDROID_STL=${ANDROID_STL}                                          \
      -DANDROID_STL="c++_shared"                                            \
      -DCMAKE_INSTALL_PREFIX="./rockchip-mpp"                               \
      -DHAVE_DRM=ON                                                         \
      ../../../

if [ "${CMAKE_PARALLEL_ENABLE}" = "0" ]; then
    ${CMAKE_PROGRAM} --build .
else
    ${CMAKE_PROGRAM} --build . -j
fi

# ----------------------------------------------------------------------------
# usefull cmake debug flag
# ----------------------------------------------------------------------------
      #-DMPP_NAME="rockchip_mpp"                                             \
      #-DVPU_NAME="rockchip_vpu"                                             \
      #-DHAVE_DRM                                                            \
      #-DCMAKE_BUILD_TYPE=Debug                                              \
      #-DCMAKE_VERBOSE_MAKEFILE=true                                         \
      #--trace                                                               \
      #--debug-output                                                        \

#cmake --build . --clean-first -- V=1

# ----------------------------------------------------------------------------
# test script
# ----------------------------------------------------------------------------
#adb push osal/test/rk_log_test /system/bin/
#adb push osal/test/rk_thread_test /system/bin/
#adb shell sync
#adb shell logcat -c
#adb shell rk_log_test
#adb shell rk_thread_test
#adb logcat -d|tail -30

make install