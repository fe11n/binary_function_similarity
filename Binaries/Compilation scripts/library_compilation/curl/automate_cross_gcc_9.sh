#!/bin/bash
##############################################################################
#                                                                            #
#  Code for the USENIX Security '22 paper:                                   #
#  How Machine Learning Is Solving the Binary Function Similarity Problem.   #
#                                                                            #
#  MIT License                                                               #
#                                                                            #
#  Copyright (c) 2019-2022 Cisco Talos                                       #
#                                                                            #
#  Permission is hereby granted, free of charge, to any person obtaining     #
#  a copy of this software and associated documentation files (the           #
#  "Software"), to deal in the Software without restriction, including       #
#  without limitation the rights to use, copy, modify, merge, publish,       #
#  distribute, sublicense, and/or sell copies of the Software, and to        #
#  permit persons to whom the Software is furnished to do so, subject to     #
#  the following conditions:                                                 #
#                                                                            #
#  The above copyright notice and this permission notice shall be            #
#  included in all copies or substantial portions of the Software.           #
#                                                                            #
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,           #
#  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF        #
#  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                     #
#  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE    #
#  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION    #
#  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION     #
#  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.           #
#                                                                            #
#  automate_cross_gcc_9.sh - Automate library compilation                    #
#                                                                            #
##############################################################################


# $1 -> gcc version
# $2 -> optimization
function do_gcc_x86 {
  unset CROSS_COMPILE
  unset AS
  unset LD
  unset AR
  unset RANLIB
  unset NM
  export CC=gcc-$1
  export CXX=g++-$1
  export CFLAGS="-fno-inline-functions -m32 -O$2 -I/usr/i686-linux-gnu/include/"
  make distclean
  ./buildconf
  ./configure --disable-shared  --without-zlib --without-ssl 
  make clean
  make
  rm -rf ../builds/x86-gcc-$1-O$2
  mkdir ../builds/x86-gcc-$1-O$2
  cp ./src/.libs/curl ../builds/x86-gcc-$1-O$2/curl_libs
  cp ./src/curl ../builds/x86-gcc-$1-O$2/curl
  cp ./lib/.libs/libcurl.so.4.6.0 ../builds/x86-gcc-$1-O$2/libcurl.so.4.6.0
  cp ./lib/.libs/libcurl.a ../builds/x86-gcc-$1-O$2/libcurl.a
}

function do_gcc_x64 {
  unset CROSS_COMPILE
  unset AS
  unset LD
  unset AR
  unset RANLIB
  unset NM
  export CC=gcc-$1
  export CXX=g++-$1
  export CFLAGS="-fno-inline-functions -m64 -O$2"
  make distclean
  ./buildconf
  ./configure --disable-shared  --without-zlib --without-ssl
  make clean
  make
  rm -rf ../builds/x64-gcc-$1-O$2
  mkdir ../builds/x64-gcc-$1-O$2
  cp ./src/.libs/curl ../builds/x64-gcc-$1-O$2/curl_libs
  cp ./src/curl ../builds/x64-gcc-$1-O$2/curl
  cp ./lib/.libs/libcurl.so.4.6.0 ../builds/x64-gcc-$1-O$2/libcurl.so.4.6.0
  cp ./lib/.libs/libcurl.a ../builds/x64-gcc-$1-O$2/libcurl.a
}

# $1 -> clang version
# $2 -> optimization
function do_clang_x86 {
  unset CROSS_COMPILE
  unset AS
  unset LD
  unset AR
  unset RANLIB
  unset NM
  export CC=clang-$1
  export CXX=clang++-$1
  export CFLAGS="-fno-inline-functions -m32 -O$2 -I/usr/i686-linux-gnu/include/"
  make distclean
  ./buildconf
  ./configure --disable-shared  --without-zlib --without-ssl
  make clean
  make
  rm -rf ../builds/x86-clang-$1-O$2
  mkdir ../builds/x86-clang-$1-O$2
  cp ./src/.libs/curl ../builds/x86-clang-$1-O$2/curl_libs
  cp ./src/curl ../builds/x86-clang-$1-O$2/curl
  cp ./lib/.libs/libcurl.so.4.6.0 ../builds/x86-clang-$1-O$2/libcurl.so.4.6.0
  cp ./lib/.libs/libcurl.a ../builds/x86-clang-$1-O$2/libcurl.a
}

# $1 -> clang version
# $2 -> optimization
function do_clang_x64 {
  unset CROSS_COMPILE
  unset AS
  unset LD
  unset AR
  unset RANLIB
  unset NM
  export CC=clang-$1
  export CXX=clang++-$1
  export CFLAGS="-fno-inline-functions -m64 -O$2"
  make distclean
  ./buildconf
  ./configure --disable-shared  --without-zlib --without-ssl
  make clean
  make
  rm -rf ../builds/x64-clang-$1-O$2
  mkdir ../builds/x64-clang-$1-O$2
  cp ./src/.libs/curl ../builds/x64-clang-$1-O$2/curl_libs
  cp ./src/curl ../builds/x64-clang-$1-O$2/curl
  cp ./lib/.libs/libcurl.so.4.6.0 ../builds/x64-clang-$1-O$2/libcurl.so.4.6.0
  cp ./lib/.libs/libcurl.a ../builds/x64-clang-$1-O$2/libcurl.a
}


function do_gcc_arm_32 {
  export CROSS_COMPILE="arm-linux-gnueabi"
  export AR=${CROSS_COMPILE}-ar
  export AS=${CROSS_COMPILE}-as
  export LD=${CROSS_COMPILE}-ld
  export RANLIB=${CROSS_COMPILE}-ranlib
  export CC=${CROSS_COMPILE}-gcc-$1
  export NM=${CROSS_COMPILE}-nm
  export CFLAGS="-fno-inline-functions -march=armv8-a -O$2"
  export CXX=${CROSS_COMPILE}-g++-$1
  export CXXFLAGS="-fno-inline-functions -march=armv8-a -O$2"
  make distclean
  ./buildconf
  ./configure --disable-shared  --without-zlib --without-ssl  --target=${CROSS_COMPILE} --host=${CROSS_COMPILE} --build=i586-pc-linux-gnu
  make clean
  make
  rm -rf ../builds/arm32-gcc-$1-O$2
  mkdir ../builds/arm32-gcc-$1-O$2
  cp ./src/.libs/curl ../builds/arm32-gcc-$1-O$2/curl_libs
  cp ./src/curl ../builds/arm32-gcc-$1-O$2/curl
  cp ./lib/.libs/libcurl.so.4.6.0 ../builds/arm32-gcc-$1-O$2/libcurl.so.4.6.0
  cp ./lib/.libs/libcurl.a ../builds/arm32-gcc-$1-O$2/libcurl.a
}

function do_gcc_arm_48_32 {
  export CROSS_COMPILE="arm-linux-gnueabi"
  export AR=/mnt/hgfs/first_training_dataset/gcc-4.8.5_arm/install_dir/bin/arm-linux-gnueabi-ar
  export AS=/mnt/hgfs/first_training_dataset/gcc-4.8.5_arm/install_dir/bin/arm-linux-gnueabi-as
  export LD=/mnt/hgfs/first_training_dataset/gcc-4.8.5_arm/install_dir/bin/arm-linux-gnueabi-ld
  export RANLIB=/mnt/hgfs/first_training_dataset/gcc-4.8.5_arm/install_dir/bin/arm-linux-gnueabi-ranlib
  export CC=/mnt/hgfs/first_training_dataset/gcc-4.8.5_arm/install_dir/bin/arm-linux-gnueabi-gcc-4.8.5
  export NM=/mnt/hgfs/first_training_dataset/gcc-4.8.5_arm/install_dir/bin/arm-linux-gnueabi-nm
  export CFLAGS="-fno-inline-functions -march=armv8-a -O$2"
  export CXX=/mnt/hgfs/first_training_dataset/gcc-4.8.5_arm/install_dir/bin/arm-linux-gnueabi-g++-4.8.5
  export CXXFLAGS="-fno-inline-functions -march=armv8-a -O$2"
  make distclean
  ./buildconf
  ./configure --disable-shared  --without-zlib --without-ssl --target=${CROSS_COMPILE} --host=${CROSS_COMPILE} --build=i586-pc-linux-gnu
  make clean
  make
  rm -rf ../builds/arm32-gcc-$1-O$2
  mkdir ../builds/arm32-gcc-$1-O$2
  cp ./src/.libs/curl ../builds/arm32-gcc-$1-O$2/curl_libs
  cp ./src/curl ../builds/arm32-gcc-$1-O$2/curl
  cp ./lib/.libs/libcurl.so.4.6.0 ../builds/arm32-gcc-$1-O$2/libcurl.so.4.6.0
  cp ./lib/.libs/libcurl.a ../builds/arm32-gcc-$1-O$2/libcurl.a
}

function do_gcc_arm_64 {
  export CROSS_COMPILE="aarch64-linux-gnu"
  export AR=${CROSS_COMPILE}-ar
  export AS=${CROSS_COMPILE}-as
  export LD=${CROSS_COMPILE}-ld
  export RANLIB=${CROSS_COMPILE}-ranlib
  export CC=${CROSS_COMPILE}-gcc-$1
  export NM=${CROSS_COMPILE}-nm
  export CFLAGS="-fno-inline-functions -march=armv8-a -O$2"
  export CXX=${CROSS_COMPILE}-g++-$1
  export CXXFLAGS="-fno-inline-functions -march=armv8-a -O$2"
  make distclean
  ./buildconf
  ./configure  --disable-shared  --without-zlib --without-ssl --target=${CROSS_COMPILE} --host=${CROSS_COMPILE} --build=i586-pc-linux-gnu
  make clean
  make
  rm -rf ../builds/arm64-gcc-$1-O$2
  mkdir ../builds/arm64-gcc-$1-O$2
  cp ./src/.libs/curl ../builds/arm64-gcc-$1-O$2/curl_libs
  cp ./src/curl ../builds/arm64-gcc-$1-O$2/curl
  cp ./lib/.libs/libcurl.so.4.6.0 ../builds/arm64-gcc-$1-O$2/libcurl.so.4.6.0
  cp ./lib/.libs/libcurl.a ../builds/arm64-gcc-$1-O$2/libcurl.a
}

function do_gcc_mips_32 {
  export CROSS_COMPILE="mips-linux-gnu"
  export AR=${CROSS_COMPILE}-ar
  export AS=${CROSS_COMPILE}-as
  export LD=${CROSS_COMPILE}-ld
  export RANLIB=${CROSS_COMPILE}-ranlib
  export CC=${CROSS_COMPILE}-gcc-$1
  export NM=${CROSS_COMPILE}-nm
  export CFLAGS="-fno-inline-functions -march=mips32r2 -O$2"
  export CXX=${CROSS_COMPILE}-g++-$1
  export CXXFLAGS="-fno-inline-functions -march=mips32r2 -O$2"
  make distclean
  ./buildconf
  ./configure --disable-shared  --without-zlib --without-ssl --target=${CROSS_COMPILE} --host=${CROSS_COMPILE} --build=i586-pc-linux-gnu
  make clean
  make
  rm -rf ../builds/mips32-gcc-$1-O$2
  mkdir ../builds/mips32-gcc-$1-O$2
  cp ./src/.libs/curl ../builds/mips32-gcc-$1-O$2/curl_libs
  cp ./src/curl ../builds/mips32-gcc-$1-O$2/curl
  cp ./lib/.libs/libcurl.so.4.6.0 ../builds/mips32-gcc-$1-O$2/libcurl.so.4.6.0
  cp ./lib/.libs/libcurl.a ../builds/mips32-gcc-$1-O$2/libcurl.a
}

function do_gcc_mips_48_32 {
  export CROSS_COMPILE="mips-linux-gnu"
  export AR=/mnt/hgfs/first_training_dataset/gcc-4.8.5_mips/install_dir/bin/mips-linux-ar
  export AS=/mnt/hgfs/first_training_dataset/gcc-4.8.5_mips/install_dir/bin/mips-linux-as
  export LD=/mnt/hgfs/first_training_dataset/gcc-4.8.5_mips/install_dir/bin/mips-linux-ld
  export RANLIB=/mnt/hgfs/first_training_dataset/gcc-4.8.5_mips/install_dir/bin/mips-linux-ranlib
  export CC=/mnt/hgfs/first_training_dataset/gcc-4.8.5_mips/install_dir/bin/mips-linux-gcc-4.8.5
  export NM=/mnt/hgfs/first_training_dataset/gcc-4.8.5_mips/install_dir/bin/mips-linux-nm
  export CFLAGS="-fno-inline-functions -march=mips32r2 -O$2"
  export CXX=/mnt/hgfs/first_training_dataset/gcc-4.8.5_mips/install_dir/bin/mips-linux-g++-4.8.5
  export CXXFLAGS="-fno-inline-functions -march=mips32r2 -O$2"
  make distclean
  ./buildconf
  ./configure --disable-shared  --without-zlib --without-ssl --target=${CROSS_COMPILE} --host=${CROSS_COMPILE} --build=i586-pc-linux-gnu
  make clean
  make
  rm -rf ../builds/mips32-gcc-$1-O$2
  mkdir ../builds/mips32-gcc-$1-O$2
  cp ./src/.libs/curl ../builds/mips32-gcc-$1-O$2/curl_libs
  cp ./src/curl ../builds/mips32-gcc-$1-O$2/curl
  cp ./lib/.libs/libcurl.so.4.6.0 ../builds/mips32-gcc-$1-O$2/libcurl.so.4.6.0
  cp ./lib/.libs/libcurl.a ../builds/mips32-gcc-$1-O$2/libcurl.a
}

function do_gcc_mips_64 {
  export CROSS_COMPILE="mips64-linux-gnuabi64"
  export AR=${CROSS_COMPILE}-ar
  export AS=${CROSS_COMPILE}-as
  export LD=${CROSS_COMPILE}-ld
  export RANLIB=${CROSS_COMPILE}-ranlib
  export CC=${CROSS_COMPILE}-gcc-$1
  export NM=${CROSS_COMPILE}-nm
  export CFLAGS="-fno-inline-functions -march=mips64r2 -O$2"
  export CXX=${CROSS_COMPILE}-g++-$1
  export CXXFLAGS="-fno-inline-functions -march=mips64r2 -O$2"
  make distclean
  ./buildconf
  ./configure --disable-shared  --without-zlib --without-ssl --target=${CROSS_COMPILE} --host=${CROSS_COMPILE} --build=i586-pc-linux-gnu
  make clean
  make
  rm -rf ../builds/mips64-gcc-$1-O$2
  mkdir ../builds/mips64-gcc-$1-O$2
  cp ./src/.libs/curl ../builds/mips64-gcc-$1-O$2/curl_libs
  cp ./src/curl ../builds/mips64-gcc-$1-O$2/curl
  cp ./lib/.libs/libcurl.so.4.6.0 ../builds/mips64-gcc-$1-O$2/libcurl.so.4.6.0
  cp ./lib/.libs/libcurl.a ../builds/mips64-gcc-$1-O$2/libcurl.a
}

function do_gcc_mips_48_64 {
  export CROSS_COMPILE="mips64-linux-gnu"
  export AR=/mnt/hgfs/first_training_dataset/gcc-4.8.5_mips64/install_dir/bin/mips64-linux-gnuabi64-ar
  export AS=/mnt/hgfs/first_training_dataset/gcc-4.8.5_mips64/install_dir/bin/mips64-linux-gnuabi64-as
  export LD=/mnt/hgfs/first_training_dataset/gcc-4.8.5_mips64/install_dir/bin/mips64-linux-gnuabi64-ld
  export RANLIB=/mnt/hgfs/first_training_dataset/gcc-4.8.5_mips64/install_dir/bin/mips64-linux-gnuabi64-ranlib
  export CC=/mnt/hgfs/first_training_dataset/gcc-4.8.5_mips64/install_dir/bin/mips64-linux-gnuabi64-gcc-4.8.5
  export NM=/mnt/hgfs/first_training_dataset/gcc-4.8.5_mips64/install_dir/bin/mips64-linux-gnuabi64-nm
  export CFLAGS="-fno-inline-functions -march=mips64r2 -O$2"
  export CXX=/mnt/hgfs/first_training_dataset/gcc-4.8.5_mips64/install_dir/bin/mips64-linux-gnuabi64-g++-4.8.5
  export CXXFLAGS="-fno-inline-functions -march=mips64r2 -O$2"
  make distclean
  ./buildconf
  ./configure --disable-shared  --without-zlib --without-ssl --target=${CROSS_COMPILE} --host=${CROSS_COMPILE} --build=i586-pc-linux-gnu
  make clean
  make
  rm -rf ../builds/mips64-gcc-$1-O$2
  mkdir ../builds/mips64-gcc-$1-O$2
  cp ./src/.libs/curl ../builds/mips64-gcc-$1-O$2/curl_libs
  cp ./src/curl ../builds/mips64-gcc-$1-O$2/curl
  cp ./lib/.libs/libcurl.so.4.6.0 ../builds/mips64-gcc-$1-O$2/libcurl.so.4.6.0
  cp ./lib/.libs/libcurl.a ../builds/mips64-gcc-$1-O$2/libcurl.a
}

function do_clang_arm_32 {
  export CROSS_COMPILE="arm-linux-gnueabi"
  export CC=clang-$1
  export CXX=clang++-$1
  export CFLAGS="-fno-inline-functions  --target=arm-linux-gnu -march=armv8-a -mfloat-abi=soft --sysroot=/usr/arm-linux-gnueabi -O$2 -Wl,-z,notext -I/usr/arm-linux-gnueabi/include/c++/7/arm-linux-gnueabi/"
  export CXXFLAGS="-fno-inline-functions --target=arm-linux-gnu -march=armv8-a -mfloat-abi=soft --sysroot=/usr/arm-linux-gnueabi -O$2 -Wl,-z,notext -I/usr/arm-linux-gnueabi/include/c++/7/arm-linux-gnueabi/"
  # Due to the following error, -Wl,-z,notext needs to be added
  # ld.lld: error: can't create dynamic relocation R_MIPS_32 against local symbol in readonly segment; recompile object files with -fPIC or pass '-Wl,-z,notext' to allow text relocations in the output
  export LDFLAGS="-fuse-ld=lld --target=arm-linux-gnu --sysroot=/usr/arm-linux-gnueabi"
  export LD="ld.lld-$1"
  export LIBS="-ldl -lpthread"

  make distclean
  ./buildconf
  ./configure --disable-shared --without-zlib --without-ssl --target=${CROSS_COMPILE} --host=${CROSS_COMPILE} --build=x86_64-pc-linux-gnu
  make clean
  make
  rm -rf ../builds/arm32-clang-$1-O$2
  mkdir ../builds/arm32-clang-$1-O$2
  cp ./src/.libs/curl ../builds/arm32-clang-$1-O$2/curl_libs
  cp ./src/curl ../builds/arm32-clang-$1-O$2/curl
  cp ./lib/.libs/libcurl.so.4.6.0 ../builds/arm32-clang-$1-O$2/libcurl.so.4.6.0
  cp ./lib/.libs/libcurl.a ../builds/arm32-clang-$1-O$2/libcurl.a
}

function do_clang_arm_64 {
  export CROSS_COMPILE="aarch64-linux-gnu"
  export CC=clang-$1
  export CXX=clang++-$1
  export CFLAGS="-fno-inline-functions  --target=aarch64-linux-gnu -march=armv8-a --sysroot=/usr/aarch64-linux-gnu -O$2 -Wl,-z,notext -I/usr/aarch64-linux-gnu/include/c++/7/"
  export CXXFLAGS="-fno-inline-functions  --target=aarch64-linux-gnu -march=armv8-a --sysroot=/usr/aarch64-linux-gnu -O$2 -Wl,-z,notext -I/usr/aarch64-linux-gnu/include/c++/7/"
  # Due to the following error, -Wl,-z,notext needs to be added
  # ld.lld: error: can't create dynamic relocation R_MIPS_32 against local symbol in readonly segment; recompile object files with -fPIC or pass '-Wl,-z,notext' to allow text relocations in the output
  export LD="ld.lld-$1"
  export LIBS="-ldl -lpthread"
  export LDFLAGS="-fuse-ld=lld --target=aarch64-linux-gnu --sysroot=/usr/aarch64-linux-gnu"

  make distclean
  ./buildconf
  ./configure --disable-shared  --without-zlib --without-ssl --target=${CROSS_COMPILE} --host=${CROSS_COMPILE} --build=i586-pc-linux-gnu
  make clean
  make
  rm -rf ../builds/arm64-clang-$1-O$2
  mkdir ../builds/arm64-clang-$1-O$2
  cp ./src/.libs/curl ../builds/arm64-clang-$1-O$2/curl_libs
  cp ./src/curl ../builds/arm64-clang-$1-O$2/curl
  cp ./lib/.libs/libcurl.so.4.6.0 ../builds/arm64-clang-$1-O$2/libcurl.so.4.6.0
  cp ./lib/.libs/libcurl.a ../builds/arm64-clang-$1-O$2/libcurl.a
}

function do_clang_mips_32 {
  export CROSS_COMPILE="mips-linux-gnu"
  export CC=clang-$1
  export CXX=clang++-$1
  export CFLAGS="-fno-inline-functions --target=mips-linux-gnu -march=mips32r2 --sysroot=/usr/mips-linux-gnu -O$2 -Wl,-z,notext -I/usr/mips-linux-gnu/include/c++/7/mips-linux-gnu/"
  export CXXFLAGS="-fno-inline-functions --target=mips-linux-gnu -march=mips32r2 --sysroot=/usr/mips-linux-gnu -O$2 -Wl,-z,notext -I/usr/mips-linux-gnu/include/c++/7/mips-linux-gnu/"
  export LD="ld.lld-$1"
  export LIBS="-ldl -lpthread"
  # Due to the following error, -Wl,-z,notext needs to be added
  # ld.lld: error: can't create dynamic relocation R_MIPS_32 against local symbol in readonly segment; recompile object files with -fPIC or pass '-Wl,-z,notext' to allow text relocations in the output
  export LD="ld.lld-$1"
  export LIBS="-ldl -lpthread"
  export LDFLAGS="-fuse-ld=lld --target=mips-linux-gnu --sysroot=/usr/mips-linux-gnu"

  make distclean
  ./buildconf
  ./configure --disable-shared  --without-zlib --without-ssl --target=${CROSS_COMPILE} --host=${CROSS_COMPILE} --build=i586-pc-linux-gnu
  make clean
  make
  rm -rf ../builds/mips32-clang-$1-O$2
  mkdir ../builds/mips32-clang-$1-O$2
  cp ./src/.libs/curl ../builds/mips32-clang-$1-O$2/curl_libs
  cp ./src/curl ../builds/mips32-clang-$1-O$2/curl
  cp ./lib/.libs/libcurl.so.4.6.0 ../builds/mips32-clang-$1-O$2/libcurl.so.4.6.0
  cp ./lib/.libs/libcurl.a ../builds/mips32-clang-$1-O$2/libcurl.a
}

function do_clang_mips_64 {
  export CROSS_COMPILE="mips64-linux-gnu"
  export CC=clang-$1
  export CXX=clang++-$1
  export CFLAGS="-fno-inline-functions -fuse-ld=lld --target=mips64-linux-gnuabi64 -march=mips64r2 --sysroot=/usr/mips64-linux-gnuabi64 -O$2 -Wl,-z,notext -I/usr/mips64-linux-gnuabi64/include/c++/7/mips64-linux-gnuabi64" 
  export CXXFLAGS="-fno-inline-functions -fuse-ld=lld --target=mips64-linux-gnuabi64 -march=mips64r2 --sysroot=/usr/mips64-linux-gnuabi64 -O$2 -Wl,-z,notext -I/usr/mips64-linux-gnuabi64/include/c++/7/mips64-linux-gnuabi64"
  # Due to the following error, -fPIC needs to be added
  # ld.lld: error: can't create dynamic relocation R_MIPS_32 against local symbol in readonly segment; recompile object files with -fPIC or pass '-Wl,-z,notext' to allow text relocations in the output
  export LD="ld.lld-$1"
  export LIBS="-ldl -lpthread"  
  export LDFLAGS="-fuse-ld=lld --target=mips64-linux-gnuabi64 --sysroot=/usr/mips64-linux-gnuabi64"

  make distclean
  ./buildconf
  ./configure --disable-shared  --without-zlib --without-ssl --target=${CROSS_COMPILE} --host=${CROSS_COMPILE} --build=i586-pc-linux-gnu
  make clean
  make
  rm -rf ../builds/mips64-clang-$1-O$2
  mkdir ../builds/mips64-clang-$1-O$2
  cp ./src/.libs/curl ../builds/mips64-clang-$1-O$2/curl_libs
  cp ./src/curl ../builds/mips64-clang-$1-O$2/curl
  cp ./lib/.libs/libcurl.so.4.6.0 ../builds/mips64-clang-$1-O$2/libcurl.so.4.6.0
  cp ./lib/.libs/libcurl.a ../builds/mips64-clang-$1-O$2/libcurl.a
}

function do_gcc_mips_9_64 {
  export CROSS_COMPILE="mips64-linux-gnu"
  export AR=/home/dockeruser/gcc-9_mips64/install_dir/bin/mips64-linux-gnuabi64-ar
  export AS=/home/dockeruser/gcc-9_mips64/install_dir/bin/mips64-linux-gnuabi64-as
  export LD=/home/dockeruser/gcc-9_mips64/install_dir/bin/mips64-linux-gnuabi64-ld
  export RANLIB=/home/dockeruser/gcc-9_mips64/install_dir/bin/mips64-linux-gnuabi64-ranlib
  export CC=/home/dockeruser/gcc-9_mips64/install_dir/bin/mips64-linux-gnuabi64-gcc
  export NM=/home/dockeruser/gcc-9_mips64/install_dir/bin/mips64-linux-gnuabi64-nm
  export CFLAGS="-fno-inline-functions -march=mips64r2 -O$2"
  export CXX=/home/dockeruser/gcc-9_mips64/install_dir/bin/mips64-linux-gnuabi64-g++
  export CXXFLAGS="-fno-inline-functions -march=mips64r2 -O$2"
  make distclean
  ./buildconf
  ./configure --disable-shared  --without-zlib --without-ssl --target=${CROSS_COMPILE} --host=${CROSS_COMPILE} --build=i586-pc-linux-gnu
  make clean
  make
  rm -rf ../builds/mips64-gcc-$1-O$2
  mkdir ../builds/mips64-gcc-$1-O$2
  cp ./src/.libs/curl ../builds/mips64-gcc-$1-O$2/curl_libs
  cp ./src/curl ../builds/mips64-gcc-$1-O$2/curl
  cp ./lib/.libs/libcurl.so.4.6.0 ../builds/mips64-gcc-$1-O$2/libcurl.so.4.6.0
  cp ./lib/.libs/libcurl.a ../builds/mips64-gcc-$1-O$2/libcurl.a
}


# GCC MIPS64 // 9 must be done on 19.10 / 4.8 must be done differently 
for gcc_v in 9 
do
    for opt_level in 0 1 2 3 s 
    do
        do_gcc_mips_9_64 $gcc_v $opt_level
    done
done

# GCC ARM64 // 9 must be done on 19.10 
for gcc_v in 9 
do
    for opt_level in 0 1 2 3 s
    do
       do_gcc_arm_64 $gcc_v $opt_level
   done
done

exit

# GCC MIPS32 // 9 must be done on 19.10 / 4.8 must be done differently 
for gcc_v in 9 
do
    for opt_level in 0 1 2 3 s
    do
        do_gcc_mips_32 $gcc_v $opt_level
    done
done


# GCC ARM32 // 9 must be done on 19.10, 4.8 must be done differently 
for gcc_v in 9 
do
    for opt_level in 0 1 2 3 s
    do
        do_gcc_arm_32 $gcc_v $opt_level
    done
done



